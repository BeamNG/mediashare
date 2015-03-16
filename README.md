Simple, small and efficient media serving solution

## Demo
 * http://media.beamng.com

## Features
 * Automatic Gallery mode if multiple files are uploaded. [Example](http://media.beamng.com/IuhbLdmRnB4uPWRxjk5URm2JnkBPdnZc)
 * Automatic thumbnail generation for uploaded images and videos
 * Very simple token authentication: no registration or user accounts
 * Fullscreen video player. [Example](http://media.beamng.com/v/exTFTN1FHjkWM2Yu)
 * Simple file management backend after upload. [Example screenshot](http://media.beamng.com/8yOFsKia3y7SQbz8)

### Simple URL features:
Some examples:

 * direct link to the raw file using its tag: [/exTFTN1FHjkWM2Yu](http://media.beamng.com/exTFTN1FHjkWM2Yu)
 * direct link to the raw file with additional arg to show the filename at the end (useful for some downloadtools, etc): [/XYZ/myfilename.mp4](http://media.beamng.com/exTFTN1FHjkWM2Yu/myfilename.mp4)
 * using the video player using v/ : [/v/XYZ](http://media.beamng.com/v/exTFTN1FHjkWM2Yu)
 * 1: full resolution thumbnail (only useful for videos): [/XYZ?thumb=1](http://media.beamng.com/exTFTN1FHjkWM2Yu?thumb=1)
 * 400px thumbnail: [/XYZ?thumb=400](http://media.beamng.com/exTFTN1FHjkWM2Yu?thumb=400)
 * 150px thumbnail: [/XYZ?thumb=15](http://media.beamng.com/exTFTN1FHjkWM2Yu?thumb=150)
 * thumbnail that fits in 200x300 pixels: [/XYZ?thumb=200x300](http://media.beamng.com/exTFTN1FHjkWM2Yu?thumb=200x300)
 * thumbnail at 3 seconds into the video: [/XYZ?thumb=1&time=3](http://media.beamng.com/exTFTN1FHjkWM2Yu?thumb=1&time=3)

## Architecture

- Nginx front webserver redirecting to N read only tornado webservers
- N tornado read only webservers which handle the file transfers via Nginx's 'send-file'
- One write only tornado webserver which handles the uploads and data changes

### Software stack

 * [lightGallery](http://sachinchoolur.github.io/lightGallery) - tiny addon and modification for it that allows the hashtag to be used to store the current progress and link to it correctly
 * [VideoJS HTML5 video player](http://www.videojs.com/)
 * [DropZone uploader](http://www.dropzonejs.com/)
 * [Tornado Python web framework](http://www.tornadoweb.org/en/stable/)
 * [Python Imaging Library (PIL)](http://en.wikipedia.org/wiki/Python_Imaging_Library) - for the thumbnail generation
 * [nginx webserver](http://nginx.org/)
 * [libav](https://libav.org/) - used for the creation of the video thumbnails

## Installation

### Ubuntu 10.04 LTS

#### Add the user that runs tornado (or use an existing user)

```bash
sudo useradd -m tornado
# no password for this account, interactive logins disabled:
sudo passwd -d tornado
```

#### Install tornado webservers and dependencies

```bash
sudo apt-get install git-core sqlite3 python3-pil libav-tools
sudo su tornado
cd
git clone hasdasd media
cd media
wget https://pypi.python.org/packages/source/t/tornado/tornado-4.1.tar.gz
tar xvfz tornado-*.tar.gz
mv tornado-4.1/tornado ./tornado
rm -rf tornado-*

# install the database
sqlite3 media.db < misc/schema-media.sql

# now change the config accordingly
nano config.py

# test if its working
python3.4 webserver.py --port=9092 --type=media_ro --threads=1 --logging=info
# you should see "server media_ro running on port 127.0.0.1:9092 ..."
```

#### Add upstart script for the tornado webservers

Upstart does not like links, so you got to copy the config files there. As your normal user (not tornado!) run:

```bash
sudo cp /home/tornado/media/misc/upstart/tornado-media_ro.conf /etc/init/
sudo cp /home/tornado/media/misc/upstart/tornado-media_rw.conf /etc/init/
```

Then start the services up:

```bash
sudo start tornado-media_ro
sudo start tornado-media_rw
```

You can tail their logs to see if  they are up and running:

```bash
tail -f /home/tornado/media/media_r*.log
```

#### Install nginx and the site

```bash
sudo apt-get install nginx

# replace with your website name:
sudo cp /home/tornado/media/misc/nginx/media.website.com /etc/nginx/sites-enabled/my.website.com

# change the config:
# change at least the server_name
sudo nano /etc/nginx/sites-enabled/my.website.com

# then restart nginx
/etc/init.d/nginx restart
```


## Customization

You might want to change the following locations to give your page a more custom look and feel:

 * templates/media/main.tpl - the start website
 * static/400.html / static/500.html - the nginx error websites. You should to change the links in there.


## License

~~~
The MIT License (MIT)

Copyright (c) 2015 Thomas Fischer <tfischer{AT}beamng(DOT)com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
~~~
