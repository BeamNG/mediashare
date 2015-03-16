import tornado.web
import sqlite3
import json
import logging
from config import *
from webserver.utils import *

# the read-only sqlite connection for this server
# "?mode=ro" requires the newest sqlite python3.4 wrappers to be enabled
dbcon = sqlite3.connect(DBPREFIX + 'media.db?mode=ro', uri=True)
dbcur = dbcon.cursor()

# the main website
class MainHandler(BaseHandler):
    def get(self):
        self.render("media/main.tpl")

# the tag handler which deals with the tags
class TagViewHandler(BaseHandler):
    def get(self, tag):
        isAdmin = False
        if tag == ADMIN_SECRET:
            # list all files ordered by upload date
            isAdmin = True
            dbcur.execute('SELECT * FROM files order by date_created desc   ')
        else:
            dbcur.execute('SELECT * FROM files where tag = :tag or batchtag = :tag order by date_created asc', {'tag':tag})

        files = fetchResultList(dbcur)
        if len(files) == 0:
            raise tornado.web.HTTPError(404)
            return

        # management view
        admintag = self.get_argument('admin', False)
        if isAdmin or admintag:
            firstFile = next(iter(files))
            if isAdmin or firstFile['changetag'] == admintag:
                for i in range(0,len(files)):
                    files[i]['videoinfostr'] = files[i]['videoinfo']
                    if len(files[i]['videoinfo']) == 0:
                        files[i]['videoinfo'] = {}
                    else:
                        try:
                            files[i]['videoinfo'] = json.loads(files[i]['videoinfo'])
                        except:
                            files[i]['videoinfo'] = {}
                self.render("media/filesoverview.tpl", files=files, tag=tag, admintag=admintag, batchtag=firstFile['batchtag'], isAdmin=isAdmin)
            else:
                raise tornado.web.HTTPError(403)
            return

        # if one file, then view that file directly
        if len(files) == 1:
            file = next(iter(files))
            fn = 'media_%010d.bin' % file['id']
            return self.nginxDownload(UPLOADS_MEDIA, fn, file['filename'], file['filesize'], True, int(file['videosnapshottime']))

        # if multiple files, use the gallery mode
        self.render("media/gallery.tpl", files=files, tag=tag)

# the video viewer
class TagViewVideoHandler(BaseHandler):
    def get(self, tag):
        self.render("media/videoplayer.tpl", tag=tag)

handlers = [
    (r"/", MainHandler),
    (r"/v/(?P<tag>[^\/]+)", TagViewVideoHandler),
    (r"/(?P<tag>[^\/]+)", TagViewHandler),
    (r"/(?P<tag>[^\/]+)/.*", TagViewHandler)
]