<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<title>error {{status_code}}</title>
<style>

@import url(http://fonts.googleapis.com/css?family=Bree+Serif|Source+Sans+Pro:300,400);

*{
    maring: 0;
    padding: 0;
}
body{
    font-family: 'Source Sans Pro', sans-serif;
    background: #ddd;
    color: #ff7800;
}
a:link{
    color: #ff7800;
    text-decoration: none;
}
a:active{
    color: #ff7800;
    text-decoration: none;
}
a:hover{
    color: #ffa85b;
    text-decoration: none;
}
a:visited{
    color: #ff7800;
    text-decoration: none;
}

a.underline, .underline{
    text-decoration: underline;
}

.bree-font{
    font-family: 'Bree Serif', serif;
}

#content{
    margin: 0 auto;
    width: 960px;
}

.clearfix:after {
    content: ".";
    display: block;
    clear: both;
    visibility: hidden;
    line-height: 0;
    height: 0;
}
 
.clearfix {
    display: block;
}
nav{
    float: right;
    display: block;
}
nav ul > li{
    list-style: none;
    float: left;
    margin: 0 2em;
    display: block;
}

#main-body{
    text-align: center;
}

.enormous-font{
    font-size: 10em;
    margin-bottom: 0em;
}
.big-font{
    font-size: 2em;
}
hr{
    width: 25%;
    height: 1px;
    background: #de6901;
    border: 0px;
}
</style>
</head>
<body>
    <div id="content">
        <header>
            <div id="logo">
            </div>
            <nav>
                <ul>
                    <li><a href="{{WEBSITE_URL}}">Home</a></li>
                    {% if len(WEBSITE_IMPRINT) > 0 %}<li><a href="{{WEBSITE_IMPRINT}}">Imprint</a></li>{% end %}
                    {% if len(WEBSITE_CONTACT) > 0 %}<li><a href="{{WEBSITE_CONTACT}}">Contact</a></li>{% end %}
                </ul>
            </nav>
        </header>
        
        <div class="clearfix"></div>
        
        <div id="main-body">
            <p class="enormous-font bree-font"> {{status_code}} </p>
            {% if status_code == 404 %}
            <p class="big-font"> This is just embarrassing; this file does not exist... </p>
            {% end %}
        </div>
    </div>
</body>
</html>