<nav class="navbar navbar-default" style="margin-top:20px">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
    </div>  
    <div id="navbar" class="navbar-collapse collapse">
      <ul class="nav navbar-nav">
        <li><a href="{{WEBSITE_URL}}">{{PROJECT_NAME}}</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        {% if len(WEBSITE_IMPRINT) > 0 %}<li><a target="_blank" href="{{WEBSITE_IMPRINT}}">Imprint</a></li>{% end %}
        {% if len(WEBSITE_CONTACT) > 0 %}<li><a target="_blank" href="{{WEBSITE_CONTACT}}">Contact</a></li>{% end %}
      </ul>
    </div>
  </div>
</nav>