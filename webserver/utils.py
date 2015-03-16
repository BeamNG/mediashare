import tornado.ioloop
import tornado.web
import tornado.httpserver
import sqlite3
import mimetypes
import random
import string
import logging
from config import *

# formats bytes
def sizeof_fmt(num, suffix='B'):
    for unit in ['','Ki','Mi','Gi','Ti','Pi','Ei','Zi']:
        if abs(num) < 1024.0:
            return "%3.1f%s%s" % (num, unit, suffix)
        num /= 1024.0
    return "%.1f%s%s" % (num, 'Yi', suffix)
  
# converts the result into a list of columnname/value rows
def fetchResultList(dbcur):
    schema = [s[0] for s in dbcur.description]
    return [dict(zip(schema, row)) for row in dbcur]

# generates a random string
def getRandomTag(length):
  lst = [random.choice(string.ascii_letters + string.digits) for n in iter(range(length))]
  return "".join(lst)

# the base handler class which extens the default tornado implementation a bit
class BaseHandler(tornado.web.RequestHandler):
  # render our own error page
  def write_error(self, status_code, **kwargs):
      self.render("error.tpl", status_code=status_code)

  # add some config variables to the template arguments
  def render(self, template, **kwargs):
    kwargs['requestHeaders'] = self.request.headers
    kwargs['WEBSITE_URL'] = WEBSITE_URL
    kwargs['WEBSITE_IMPRINT'] = WEBSITE_IMPRINT
    kwargs['WEBSITE_CONTACT'] = WEBSITE_CONTACT
    kwargs['PROJECT_NAME'] = PROJECT_NAME
    kwargs['MAX_UPLOAD_SIZE'] = MAX_UPLOAD_SIZE
    kwargs['DROPZONE_ACCEPTED_FILES'] = DROPZONE_ACCEPTED_FILES
    kwargs['DROPZONE_MESSAGE'] = DROPZONE_MESSAGE

    self.set_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
    super(BaseHandler, self).render(template, **kwargs)

  # the wrapper to tell nginx which file to deliver to the client
  # also generates thumbnails on the fly
  def nginxDownload(self, uploadPathRel, filenameRelative, suggestedFilename, filesize, enableThumbnails = False, videothumbpos = 10):
    filenameAbs = WEBROOT + uploadPathRel + filenameRelative
    if not os.path.isfile(filenameAbs):
      logging.error("file not found: %s", filenameAbs)
      raise tornado.web.HTTPError(404)

    # clear the tornado header and set the mime type correctly if possible
    self.clear_header('Server')
    self.clear_header('Content-Type')
    mime = mimetypes.guess_type(suggestedFilename)
    if mime != None and mime[0] != None:
        self.set_header('Content-Type', mime[0])
    else:
        self.set_header('Content-Type', 'application/octet-stream')

    # requested a thumbnail?
    thumbArg = self.get_argument('thumb', '')
    if enableThumbnails and thumbArg != '':
      if thumbArg.find('x') == -1:
        thumbArg = thumbArg + 'x' + thumbArg

      thumbsizea = thumbArg.split('x')
      if len(thumbsizea) != 2:
        logging.error("invalid thumb args: %s", thumbArg)
        raise tornado.web.HTTPError(500)        
      thumbsizex = int(thumbsizea[0])
      thumbsizey = int(thumbsizea[1])
      thumbext = '_thumb%dx%d.bin' % (thumbsizex,thumbsizey)
      _unused, fileExtension = os.path.splitext(suggestedFilename)
      if THUMBNAIL_GENERATION and fileExtension.lower() in IMAGE_EXTS:
        # iamge thumbnail generation via PIL
        from PIL import Image
        # generate a thumbnail from a source image
        filenameAbsFull = filenameAbs
        filenameAbs = filenameAbsFull[:filenameAbsFull.rfind('.')] + thumbext
        if not os.path.isfile(filenameAbs):
          #logging.info("generating thumbnail: ", filenameAbsFull, ' -> ', filenameAbs)
          img = Image.open(filenameAbsFull)
          if img:
            img.thumbnail((thumbsizex, thumbsizey), Image.ANTIALIAS)
            img.save(filenameAbs, "JPEG", quality=THUMB_JPG_QUALITY, optimize=True, progressive=True)
          else:
            logging.error("unable to open file: %s", filenameAbsFull)
            raise tornado.web.HTTPError(500)
        if not os.path.isfile(filenameAbs):
          logging.error("unable to generate thumbnail")
          raise tornado.web.HTTPError(500)
      
      elif VIDEO_THUMBNAIL_GENERATION and fileExtension.lower() in VIDEO_EXTS:
        # video thumbnail generation
        inputFilename = filenameAbs
        timeSec = int(self.get_argument('time', videothumbpos))
        m, s = divmod(timeSec, 60)
        h, m = divmod(m, 60)
        timeStr = "%d:%02d:%02d" % (h, m, s)

        thumbext = '_vidthumb%dx%d_%d.bin' % (thumbsizex,thumbsizey,timeSec)
        outputFilename = filenameAbs[:filenameAbs.rfind('.')] + thumbext
        if not os.path.isfile(outputFilename):
          scalearg = '-vf scale=%d:-1' % thumbsizex
          if thumbsizex == 1:
            scalearg = ''
          cmd = AVCONV_CMDLINE % {
            'inputFilename':inputFilename,
            'seekTime':timeStr,
            'scaleArg':scalearg,
            'outputFilename':outputFilename}
          #logging.info(cmd)
          # TODO: replace with subprocess
          os.system(cmd)
        filenameAbs = outputFilename
      # if requested a thumbnail, set the content type accordingly
      self.set_header('Content-Type', 'image/jpeg')
      suggestedFilename = suggestedFilename + ".thumb.jpg"

    # render inline or download as attachment?
    download = self.get_argument('download', False)
    if download:
        self.set_header('Content-Disposition','attachment; filename="' + suggestedFilename + '"')
    else:
        self.set_header('Content-Disposition','inline; filename="' + suggestedFilename + '"')

    # now send it to nginx:

    # rate limit the download?
    #self.set_header('X-Accel-Limit-Rate', 'off') # default = off
    #self.set_header('X-Accel-Limit-Rate', 1024000) # 1024 kB/s = 1MB/s

    # nginx only likes relative paths, so get relative path again
    filenameAbs = filenameAbs[len(WEBROOT):]
    #logging.info('%s', filenameAbs)

    # finally redirect
    self.set_header('X-Accel-Redirect', filenameAbs)
    self.finish()