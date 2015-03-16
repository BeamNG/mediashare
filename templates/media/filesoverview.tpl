{% extends "base.tpl" %}

{% block header %}
<link type="text/css" rel="stylesheet" href="/css/filelist.css" />                    
{% end %}


{% block content %}
<div class="container" style="margin-top:20px;">

<div class="jumbotron">
  {% if isAdmin %}
    <h1>Global Admin View</h1>
  {% else %}
    <h1>Gallery Admin View</h1>
  {% end %}
</div>

<div class="alert alert-danger" role="alert">
  <span class="glyphicon glyphicon-eye-close" aria-hidden="true"></span>
  {% if isAdmin %}
    <b>Global Admin View</b>: Never ever share this url
  {% else %}
    <b>Admin View</b>: Save this URL to access this gallery, do not give it to others
  {% end %}
</div>

{% if not isAdmin %}
<div class="alert alert-success" role="alert">
  <span class="glyphicon glyphicon-bullhorn" aria-hidden="true"></span>
  <b>Public gallery permalink</b>: <a href="{{WEBSITE_URL}}/{{tag}}" target="_blank">{{WEBSITE_URL}}/{{tag}}</a>
</div>
{% end %}

<table class="table">
<thead>
  <tr>
    <th>Thumbnail</th>
    <th>Filename / Links / Info</th>
    <th>Sharing options</th>
  </tr>
</thead>
<tbody>
{% for f in files %}
<tr>
  <td width="300">
    <a target="_blank" href="{{WEBSITE_URL}}/{{f['tag']}}" class="thumbnail">
    <img src="/{{f['tag']}}?thumb=300" >
    </a>
  </td>
  <td>

  {% if webserver.ui_methods.is_video_filename(f['filename']) %}
    <a target="_blank" href="{{WEBSITE_URL}}/v/{{f['tag']}}">{{f['filename']}}&nbsp;(video&nbsp;player)</a><br/>
    <a target="_blank" href="{{WEBSITE_URL}}/{{f['tag']}}">{{f['filename']}}&nbsp;(raw&nbsp;file)</a><br/>

    <div style="font-size:small;font-family:monospace">
      <b>Filesize</b>: {{webserver.ui_methods.sizeof_fmt(f['filesize'])}}<br/>
      <b>Uploaded</b>: {{f['date_created']}}<br/> 

      {#
      <pre>
      {{f['videoinfostr'])}}
      </pre>
      #}

      {% if 'format' in f['videoinfo'] and 'duration' in f['videoinfo']['format'] %}
      <b>Format</b>: {{f['videoinfo']['format']['format_long_name']}}<br/>
      <b>Bitrate</b>: {{'%0.0f' %  (float(f['videoinfo']['format']['bit_rate']) / 1000)}} kB/s<br/>
      <b>Duration</b>: {{'%0.2f' % float(f['videoinfo']['format']['duration'])}} seconds<br/>
      <b>Default Thumbnail position</b>: {{'%0.3f' % float(f['videosnapshottime'])}} seconds<br/>
      <input onchange="changeThumbTimePos('{{f['tag']}}', '{{f['changetag']}}', $(this).val());" type="range" min="0" step="0.01" max="{{f['videoinfo']['format']['duration']}}" value="{{f['videosnapshottime']}}">
    </div>
    {% end %}

  {% else %}
    <a target="_blank" href="{{WEBSITE_URL}}/{{f['tag']}}">{{f['filename']}}</a>
    <div style="font-size:small;font-family:monospace">
      <b>Filesize</b>: {{webserver.ui_methods.sizeof_fmt(f['filesize'])}}<br/>
      <b>Uploaded</b>: {{f['date_created']}}<br/> 
    </div>
  {% end %}
  </td>
  <td>
    {% if webserver.ui_methods.is_video_filename(f['filename']) %}
      <input type="text" size="16" onClick="this.select();" value="[mvideo]{{WEBSITE_URL}}/{{f['tag']}}[/mvideo]"/><br/><br/>
    {% elif webserver.ui_methods.is_image_filename(f['filename']) %}
      <input type="text" size="16" onClick="this.select();" value="[mimg]{{WEBSITE_URL}}/{{f['tag']}}[/mimg]"/><br/><br/>
    {% end %}
    Thumbnails:
    {% if webserver.ui_methods.is_video_filename(f['filename']) %}
      <a target="_blank" href="{{WEBSITE_URL}}/{{f['tag']}}?thumb=1">[Full res]</a>,
    {% end %}
    <a target="_blank" href="{{WEBSITE_URL}}/{{f['tag']}}?thumb=150">150 px</a>,
    <a target="_blank" href="{{WEBSITE_URL}}/{{f['tag']}}?thumb=300">300 px</a>, 
    <a target="_blank" href="{{WEBSITE_URL}}/{{f['tag']}}?thumb=400">400 px</a><br/>
    <br/>
    <a href="javascript:deleteFile('{{f['tag']}}','{{f['changetag']}}',{% if len(files) == 1 %}true{% else %}false{% end %});" type="button" class="btn btn-danger">Delete</a>
  </td>
</tr>
{% end %}
</tbody>
</table>
<small>Tip: you can change the time offset for the thumbnails by adding "&time=33" to the end of the URL (i.e. replace 33 with the amount of seconds you want)</small>

{% if not isAdmin %}
<h2>Mass BBCode embed</h2>
<textarea cols="120" rows="10" style="font-size:small;font-family:monospace;" onClick="this.select();">
{% for f in files %}{% if webserver.ui_methods.is_video_filename(f['filename']) %}[mfvideo]{{WEBSITE_URL}}/{{f['tag']}}[/mfvideo]{% elif webserver.ui_methods.is_image_filename(f['filename']) %}[mimg]{{WEBSITE_URL}}/{{f['tag']}}[/mimg]{% end %}{% end %}
</textarea>

<h1>Upload more files</h1>
<form action="/s4/u/" class="dropzone" id="mediafiledrop"></form>
{% end %}

<script>
// simple ajax query wrapper
function queryAPI(url, postData, cbfunc) {
  if (postData === undefined) postData = {}
  var jqxhr = $.ajax({
    url: '{{WEBSITE_URL}}' + url,
    data: postData,
    type: "POST",
    dataType: "JSON"
  })
  .done(function(data) {
    if(cbfunc) cbfunc(data);
  })
  .fail(function(jqXHR, textStatus) {
    console.log("API call failed: " + textStatus);
    if(cbfunc) cbfunc({'ok':0});
  });
}

// file deletion wrapper
function deleteFile(tag, admintag, confirmDeletion) {
  if(confirmDeletion) {
    var c = confirm("Are you sure you wish to delete the last file? This will delete the gallery as a whole.");
    if(!c) return;
  }

  queryAPI('/s4/v1/deletefile', {tag:tag, admintag:admintag}, function(data) {
    location.reload();
  });
  return false;
};

// video thumbnail changing wrapper
function changeThumbTimePos(tag, admintag, time) {
  queryAPI('/s4/v1/changethumbtime', {tag:tag, admintag:admintag, time:time}, function(data) {
    location.reload();
  });
  return false;
};

{% if not isAdmin %}
  var batchID = '{{batchtag}}';
  var adminID = '{{admintag}}';
  {% include parts/dropzone.tpl %}
{% end %}
</script>

{% include parts/footer.tpl %}

</div>

</div> <!-- container -->

{% end %}