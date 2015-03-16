{% import webserver.ui_methods %}<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{PROJECT_NAME}}</title>

    <link href="/css/font-awesome.min.css" rel="stylesheet">
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/dropzone.css" rel="stylesheet">
    <link href="/videojs/video-js.css" rel="stylesheet">

    <script src="/js/jquery-2.1.3.min.js"></script>
    <script src="/js/dropzone.js"></script>
    <script src="/videojs/video.js"></script>
    <script>
      videojs.options.flash.swf = "/videojs/video-js.swf"
    </script>
    {% block header %}{% end %}
  </head>
<body>
{% block content %}
{% end %}
<script src="/js/bootstrap.min.js"></script>
</body>
</html>