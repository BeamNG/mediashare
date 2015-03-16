#!/bin/false

###############################################################################
Installation

# links for nginx
ln -s /home/tornado/repo/misc/nginx/repo.beamng.com /etc/nginx/sites-enabled/
ln -s /home/tornado/repo/misc/nginx/media.beamng.com /etc/nginx/sites-enabled/

#copy for upstart (it does not support symlinks)
cd /home/tornado/repo/
cp misc/upstart/tornado-media_rw.conf /etc/init/
cp misc/upstart/tornado-media_ro.conf /etc/init/
cp misc/upstart/tornado-repo_rw.conf /etc/init/
cp misc/upstart/tornado-repo_ro.conf /etc/init/
chown tornado:tornado * -R

#install ffmpeg
# https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu


###############################################################################
Runtime snippets


# start them
service tornado-repo_ro start
service tornado-repo_rw start
service tornado-media_ro start
service tornado-media_rw start

#stop them
service tornado-repo_ro stop
service tornado-repo_rw stop
service tornado-media_ro stop
service tornado-media_rw stop

#restart them
service tornado-repo_ro restart
service tornado-repo_rw restart
service tornado-media_ro restart
service tornado-media_rw restart



# redirect port via iptables
#iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
#iptables -A INPUT -i eth0 -p tcp --dport 8080 -j ACCEPT
#iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080

# redo the databases

# su torando

# rm repo.db
# sqlite3 repo.db < misc/schema-repo.sql
# rm -rf uploads/*

# rm media.db
# sqlite3 media.db < misc/schema-media.sql




#mkdir uploads



# start manually?
