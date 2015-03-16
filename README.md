Simple, small and efficient media serving solution

# Demo
 * http://media.beamng.com

# Features
 * Automatic Gallery mode if multiple files are uploaded. Example: http://media.beamng.com/IuhbLdmRnB4uPWRxjk5URm2JnkBPdnZc
 * automatic thumbnail generation for uploaded images and videos
 * very simple token authentication: no registration or user accounts
 * Fullscreen video player: http://media.beamng.com/v/exTFTN1FHjkWM2Yu

# Architecture

- Nginx front webserver redirecting to N read only tornado webservers
- N tornado read only webservers which handle the file transfers via Nginx's 'send-file'
- One write only tornad webserver which handles the uploads and data changes

## Software stack

 * [lightGallery](http://sachinchoolur.github.io/lightGallery) - tiny addon and modification for it that allows the hashtag to be used to store the current progress and link to it correctly
 * [VideoJS HTML5 video player](http://www.videojs.com/)
 * [DropZone uploader](http://www.dropzonejs.com/)
 * [Tornado Python web framework](http://www.tornadoweb.org/en/stable/)
 * [Python Imaging Library (PIL)](http://en.wikipedia.org/wiki/Python_Imaging_Library) - for the thumbnail generation
 * [nginx webserver](http://nginx.org/)
 * [libav](https://libav.org/) - used for the creation of the video thumbnails

# Installation

## Ubuntu 10.04 LTS

### Add the user that runs tornado (or use an existing user)

~~~
sudo useradd -m tornado
# no password for this account, interactive logins disabled:
sudo passwd -d tornado
~~~

### Install tornado webservers and dependencies

~~~
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
# run a test
python3.4 webserver.py --port=9092 --type=media_ro --threads=1 --logging=info
~~~

you should see "server media_ro running on port 127.0.0.1:9092 ..."

### Add upstart script for the tornado webservers

Upstart does not like links, so you got to copy the config files there. As your normal user (not tornado!) run:

~~~
sudo cp /home/tornado/media/misc/upstart/tornado-media_ro.conf /etc/init/
sudo cp /home/tornado/media/misc/upstart/tornado-media_rw.conf /etc/init/
~~~

Then start the services up:

~~~
sudo start tornado-media_ro
sudo start tornado-media_rw
~~~

You can tail their logs to see if  they are up and running:

~~~
tail -f /home/tornado/media/media_r*.log
~~~

### Install nginx and the site

~~~
sudo apt-get install nginx
sudo ln -s /home/tornado/media/misc/nginx/media.beamng.com /etc/nginx/sites-enabled/
# change the config:
# change at least the server_name
nano /home/tornado/media/misc/nginx/media.beamng.com
# then restart nginx
/etc/init.d/nginx restart
~~~


# Customization

You might want to change the following locations to give your page a more custom look and feel:

 * templates/media/main.tpl - the start website
 * static/400.html / static/500.html - the nginx error websites. You have to uncomment/change the links inthere
