import os
import math
from config import *

# this file contains helper functions which are made available inside the tornado template system. Example:
"""
{% import webserver.ui_methods %}

...

{% if webserver.ui_methods.is_video_filename(f['filename']) %}
...
{% end %}
"""

# formats bytes
def sizeof_fmt(num, suffix='B'):
  for unit in ['','Ki','Mi','Gi','Ti','Pi','Ei','Zi']:
    if abs(num) < 1024.0:
      return "%3.1f%s%s" % (num, unit, suffix)
    num /= 1024.0
  return "%.1f%s%s" % (num, 'Yi', suffix)
  
# checks a filename against the video extension list
def is_video_filename(fn):
  _unused, fn = os.path.splitext(fn)
  return (fn.lower() in VIDEO_EXTS)

# checks a filename against the image extension list
def is_image_filename(fn):
  _unused, fn = os.path.splitext(fn)
  return (fn.lower() in IMAGE_EXTS)

# math.floor wrapper
def floor(n):
  return math.floor(n)
