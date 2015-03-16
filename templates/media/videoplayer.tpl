{% extends "base.tpl" %}

{% block content %}
<video class="video-js vjs-default-skin vjs-fullscreen" controls preload="none" width="auto" height="auto" poster="{{WEBSITE_URL}}/{{tag}}?thumb=1" data-setup='{"techOrder": ["html5", "flash"]}'>
 <source src="{{WEBSITE_URL}}/{{tag}}" type="video/mp4"/>
 <p class="vjs-no-js">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a></p>
</video>

{% end %}