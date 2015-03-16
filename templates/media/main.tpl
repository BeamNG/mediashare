{% extends "base.tpl" %}

{% block content %}

<div class="container" style="margin-top:20px;">
<div class="jumbotron">
  <h2>high quality and simple media sharing</h2>
<!--  <p>Only upload content that you own the rights on and that is related to YOUR PORJECT HERE</p> -->
</div>

<form action="/s4/u/" class="dropzone" id="mediafiledrop"></form>

<script>
function randomID(len) {
  var res = "";
  var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  for(var i=0; i < len; i++ ) {
    res += possible.charAt(Math.floor(Math.random() * possible.length));
  }
  return res;
}
var batchID = randomID(32);
var adminID = randomID(64);
{% include parts/dropzone.tpl %}
</script>

{% include parts/footer.tpl %}

</div>
{% end %}