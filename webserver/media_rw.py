import subprocess
import sqlite3
import json
import glob
import os
import logging
from config import *
from webserver.utils import *

# the read/write connection to the sqlite database. You can ony run one thread of this, otherwise you run into threading problems with sqlite
dbcon = dbcon = sqlite3.connect(DBPREFIX + 'media.db', uri=True)
dbcur = dbcur = dbcon.cursor()

# the upload handler
class RestUploadMediaFileHandler(BaseHandler):
    def post(self):
        file_name = self.request.files['file'][0].filename
        file_contents = self.request.files['file'][0].body
        file_size = len(file_contents)
        tag = getRandomTag(16)
        batchtag = self.get_argument("t", getRandomTag(32))
        changetag = self.get_argument("a", getRandomTag(64))

        # write basics first, then update with the image sizes later on
        dbcur.execute("insert into files (filename, filesize, tag, batchtag, changetag, imagewidth, imageheight) VALUES(?,?,?,?,?,?,?)", [
                file_name,
                file_size,
                tag,
                batchtag,
                changetag,
                -1,
                -1])
        file_id = int(dbcur.lastrowid)
        dbcon.commit()

        filenameAbs = WEBROOT + UPLOADS_MEDIA + "media_%010d.bin" % file_id

        with open(filenameAbs, "wb") as f:
            f.write(file_contents)

        _unused, fileExtension = os.path.splitext(file_name)
        logging.info("fileExtension: %s", fileExtension)

        # find out the image sizes
        if THUMBNAIL_GENERATION and fileExtension.lower() in IMAGE_EXTS:
            from PIL import Image
            imagewidth = -1
            imageheight = -1
            img = Image.open(filenameAbs)
            if img:
                (imagewidth, imageheight) = img.size
                dbcur.execute("update files set imagewidth=?, imageheight=? where id = ?", [imagewidth, imageheight, file_id])
                dbcon.commit()
            else:
                logging.error("unable to open image: %s", filenameAbs)


        if VIDEO_THUMBNAIL_GENERATION and fileExtension.lower() in VIDEO_EXTS:
            cmd = AVPROBE_CMDLINE % {'inputFilename':filenameAbs}
            formatJson = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE).stdout.read()
            formatJson = formatJson.decode('utf8')
            logging.info("formatOut: %s", formatJson)

            snapShotTime = 10
            try:
                video_format = json.loads(formatJson)
                video_format = video_format['format']
                duration = float(video_format["duration"])
                if snapShotTime > duration:
                    snapShotTime = duration * VIDEO_THUMBNAIL_DEFAULT_PERCENT
                #logging.info("snapShotTime: %d, duration: %d", snapShotTime, duration)
            except:
                pass
            dbcur.execute("update files set videoinfo=?, videosnapshottime=? where id = ?", [formatJson, snapShotTime, file_id])
            dbcon.commit()
        

        self.write({'ok':1, 'tag':tag})
        self.finish()

class DeleteFileHandler(BaseHandler):
    def post(self):
        tag = self.get_argument('tag')
        admintag = self.get_argument('admintag')
        dbcur.execute('SELECT * FROM files where tag = :tag and changetag = :changetag', {'tag':tag,'changetag':admintag})
        files = fetchResultList(dbcur)
        if len(files) != 1:
            self.write({'ok':0})
            return

        file = next(iter(files))
        fn = WEBROOT + UPLOADS_MEDIA + 'media_%010d.bin' % file['id']
        if os.path.isfile(fn):
            os.remove(fn)
        if os.path.isfile(fn):
            logging.error("unable to delete file: %s", fn)
            self.write({'ok':0})
            return

        globMask = 'media_%010d_*' % file['id']
        os.chdir(WEBROOT + UPLOADS_MEDIA)
        for file in glob.glob(globMask):
            fn = WEBROOT + UPLOADS_MEDIA + file
            os.remove(fn)
            if os.path.isfile(fn):
                logging.error("unable to delete file: %s", fn)
                self.write({'ok':0})
                return

        dbcur.execute("delete from files where tag = ? and changetag = ?", [tag, admintag])
        dbcon.commit()
        if dbcur.rowcount == 1:
            self.write({'ok':1})
            return
        logging.error("unable to delete file db entry")
        self.write({'ok':0})

# simple handler to update the snapshot time
class ChangeThumbTimeFileHandler(BaseHandler):
    def post(self):
        tag = self.get_argument('tag')
        admintag = self.get_argument('admintag')
        time = float(self.get_argument('time', 10))
        dbcur.execute('update files set videosnapshottime = :time where tag = :tag and changetag = :changetag', {'time':time, 'tag':tag,'changetag':admintag})
        dbcon.commit()
        if dbcur.rowcount == 1:
            self.write({'ok':1})
            return
        logging.error("setting time for tag: %s (admintag: %s) = %f", tag, admintag, time)
        self.write({'ok':0})

# the routes associated with this server
# you ahve to prefix them with /s4/ so nginx will use this server and not the other one
handlers = [
    (r"/s4/u/", RestUploadMediaFileHandler),
    (r"/s4/v1/deletefile", DeleteFileHandler),
    (r"/s4/v1/changethumbtime", ChangeThumbTimeFileHandler),
]