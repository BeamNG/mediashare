import os

# The project title, used in the header and the foote
PROJECT_NAME = 'My.media'

# the root URL of this, use // instead of http/https to provide support for both transparently if you like
WEBSITE_URL     = '//media.website.com'

# the link to the imprint on some pages, leave empty to remove
WEBSITE_IMPRINT  = '//website.com/imprint'
# the link to the contact us form on some pages, leave empty to remove
WEBSITE_CONTACT  = '//website.com/contactus'

# Debug mode: This enables app wide debug mode (more log messages, one thread only, automatic reloading when you change the files)
# DO NOT USE IN PRODUCTION
DEBUG    = False
# this is the installation path of this, it uses it to find the absolute paths of things as well
WEBROOT  = os.path.abspath(os.path.dirname(os.path.realpath(__file__)))

# the upload directories relative to the WEBROOT
UPLOADS_MEDIA = '/uploads_media/'

# the URI to the database (basically the folder)
DBPREFIX = 'file:/home/tornado/media/'

# the maximum upload size in bytes
MAX_UPLOAD_SIZE = 1000000000 # in bytes

# generate thumbnails from videos? - requires working avconv and avprobe
VIDEO_THUMBNAIL_GENERATION = True
# extensions for what to generate thumbnails for
VIDEO_EXTS = ['.webm', '.mp4', '.avi']
# this is the percentage in the video which is used to determine where the thumbnail should be taken from (0 = at the start, 0.5 = in the middle of it, 1 = at the end)
VIDEO_THUMBNAIL_DEFAULT_PERCENT = 0.2

# generate thumbnails for images? - requires the PIL (Python imaging library)
THUMBNAIL_GENERATION = True
# extensions for whihc it will generate thumbnails
IMAGE_EXTS = ['.jpeg', '.jpg', '.png']
# the JPEG quality of the thumbnails the less quality, the faster they load ;)
THUMB_JPG_QUALITY = 80

# the accepted files by dropzone: use <mime type>,fileextension, etc
DROPZONE_ACCEPTED_FILES = 'image/png,.png,image/jpeg,.jpg,image/jpeg,.jpeg,video/webm,.webm,video/mp4,.mp4'
# the message in the dropzone area
DROPZONE_MESSAGE = 'Click or drop any of the following files here to upload: PNG, JPG, MP4, WEBM (Max size: %0.0f MB)' % (MAX_UPLOAD_SIZE/(1<<20))

# the command line for the ffmpeg / fprobe utilities used for taking video thumbnails
AVCONV_CMDLINE = '/usr/bin/avconv -y -i %(inputFilename)s -ss %(seekTime)s -vframes 1 -f mjpeg %(scaleArg)s %(outputFilename)s'
AVROBE_CMDLINE = '/usr/bin/avprobe -show_format -show_streams -of json %(inputFilename)s'

# set this to a secure random value of your own. This application should not use cookies though
COOKIE_SECRET = 'C%Zl#Aqu6:pMpeXG2zfs#B,e-b08NFOb5Qi6Fx=^cW;P#4+VoOl?tGen35Q4bHpppbD!b!k3l@%u0Lg,@h3gkcW0y7FFT,83+.E$IQs?XJo#+ZH13eTX0Q)A60(fV2c)IauoBh%Mb:HJ.$%YBaw8A=8)ylJy1Yff4oBAQpYhFYnv9*qaL%48fmH!YV8$B-cn0HxNv-3L'

# this is the admin tag that is used to get the full fle list, it may be advised to use only characters that do not need urlencode translation: a-z,A-Z,0-9,-,_
ADMIN_SECRET = 'hggeoyfnKHwnj2SqDK1afYtsqGR8qrby6kgirn88TDhdhI5TkNHbDjZcIiM1nJdZcReSoB0mvcnImEApQt76rybFqHXsOFdMtTNi5Vks07TwhALn4UrkJDOclEk1MRlkM0YuYTfPqpUuoRjeS7RrbhJBhyR3eqp2'

