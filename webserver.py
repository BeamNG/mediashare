#!/usr/bin/python3.4

# warning: using python 3.4 now

import tornado.ioloop
import tornado.web
import tornado.httpserver
import tornado.autoreload
import os
import tornado.options
import random
from tornado.options import options as opts
from config import *
from webserver.utils import *

class Application(tornado.web.Application):
    def __init__(self, appType):
        server = __import__('webserver.%s' % appType, fromlist=["webserver"])
        if not server.handlers:
            raise Exception('invalid server')
            return
        settings = {
            "debug": DEBUG,
            "template_path": os.path.join(WEBROOT, "templates"),
            "cookie_secret": COOKIE_SECRET,
        }
        tornado.web.Application.__init__(self, server.handlers, **settings)

def main():
    opts.define('debug', default=False, type=bool, help='enables debug mode')
    opts.define('port', default=9090, type=int, help='Tornado server port')
    opts.define('bind', default='127.0.0.1', type=str, help='ip tp bind to')
    opts.define('type', default='repo_ro', type=str, help='server type')
    opts.define('threads', default=0, type=int, help='numer of threads to spawn')
    opts.parse_command_line()

    DEBUG = opts.debug
    if DEBUG or opts.threads > 1:
        print("WARNING: DEBUG requires single threaded mode")
        opts.threads = 1

    app = Application(opts.type)
    
    http_server = tornado.httpserver.HTTPServer(app, max_buffer_size=MAX_UPLOAD_SIZE, xheaders=True)
    if opts.threads == 1:
        http_server.listen(opts.port, address=opts.bind)
    else:
        http_server.bind(opts.port)
        http_server.start(opts.threads)  # Forks multiple sub-processes
    
    print("server %s running on port %s:%d ..." % (opts.type, opts.bind, opts.port))
    
    if DEBUG:
        tornado.autoreload.start()
        tornado.autoreload.watch(os.path.abspath(__file__))

    tornado.ioloop.IOLoop.instance().start()

if __name__ == "__main__":
    main()