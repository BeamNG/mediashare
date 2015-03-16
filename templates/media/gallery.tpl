{% extends "base.tpl" %}

{% block header %}
<link type="text/css" rel="stylesheet" href="/css/lightGallery.css" />                    
<script src="/js/lightGallery.js"></script>

<link href='http://fonts.googleapis.com/css?family=Cinzel+Decorative:400,700,900' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Dosis:200,300,400,500,600,700,800|Roboto+Slab:400,300,700,100' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Roboto:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic,900,900italic|Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>
{% end %}

{% block content %}

<style>
list-unstyled {
  padding-left: 0;
  list-style: none;
}
ul, ol {
  margin-top: 0;
  margin-bottom: 9px;
  list-style-position: inside;
}

.gallery {
  /* Prevent vertical gaps */
  line-height: 0;
   
  -webkit-column-count: 6;
  -webkit-column-gap:   0px;
  -moz-column-count:    6;
  -moz-column-gap:      0px;
  column-count:         6;
  column-gap:           0px;  
}
@media (max-width: 1200px) {
  .gallery {
  -moz-column-count:    4;
  -webkit-column-count: 4;
  column-count:         4;
  }
}
@media (max-width: 1000px) {
  .gallery {
  -moz-column-count:    3;
  -webkit-column-count: 3;
  column-count:         3;
  }
}
@media (max-width: 800px) {
  .gallery {
  -moz-column-count:    2;
  -webkit-column-count: 2;
  column-count:         2;
  }
}
@media (max-width: 400px) {
  .gallery {
  -moz-column-count:    1;
  -webkit-column-count: 1;
  column-count:         1;
  }
}
.gallery li {
  width: 100% !important;
  height: auto !important;
}
#lightGallery-close {
    display:hidden !important;
}
</style>

<ul id="lightGallery" class="gallery list-unstyled">
{% for f in files %}
{% if webserver.ui_methods.is_video_filename(f['filename']) %}
  <li data-html='<video class="video-js vjs-default-skin vjs-fullscreen" controls preload="none" width="auto" height="auto" poster="{{WEBSITE_URL}}/{{f["tag"]}}?thumb=1"> <source src="{{WEBSITE_URL}}/{{f["tag"]}}" type="video/mp4"/><p class="vjs-no-js">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a></p></video>'>
    <img src="{{WEBSITE_URL}}/{{f['tag']}}?thumb=300" />
  </li>
{% else %}
  <li data-src="{{WEBSITE_URL}}/{{f['tag']}}/{{f['filename']}}">
    <img src="{{WEBSITE_URL}}/{{f['tag']}}?thumb=300" />
  </li>
{% end %}
{% end %}
</ul>

<script type="text/javascript">
var g = null;
$(document).ready(function() {

    var startIndex = 0;
    var autoPlay = true;
    if(window.location.hash && window.location.hash.length > 0) {
        console.log(window.location.hash);
        startIndex = parseInt(location.hash.substr(1)) - 1;
        autoPlay=false;
    }

    g = $("#lightGallery").lightGallery({
        showAfterLoad   : true,  // Show Content once it is fully loaded.
        //showThumbByDefault   : true,    // Whether to display thumbnails by default..
        counter:true,
        escKey           : false,  // Whether lightGallery should be closed when user presses "Esc".
        closable         : false,  //allows clicks on dimmer to close gallery
        index: startIndex,
        thumbWidth           : 100,      // Width of each thumbnails
        speed     : 200,      // Transition duration (in ms).
        preload         : 2,    //number of preload slides. will exicute only after the current slide is fully loaded. ex:// you clicked on 4th image and if preload = 1 then 3rd slide and 5th slide will be loaded in the background after the 4th slide is fully loaded.. if preload is 2 then 2nd 3rd 5th 6th slides will be preloaded.. ... ...
        thumbnail            : true,     // Whether to display a button to show thumbnails.
        animateThumb         : true,     // Enable thumbnail animation.
        controls         : true,  // Whether to display prev/next buttons.
        loop:true,
        pause:5000,
        auto             : autoPlay, // Enables slideshow mode.
        onSlideAfter : function(el, idx) {
            window.location.hash = idx + 1;
        }
    });
    
    // open it
    $('ul#lightGallery li:first').trigger('click');

});
</script>
{% end %}