server {
    listen 80;
    listen [::]:80;

    root /home/tornado/media/;
    
    # CHANGE ME (at least) #######
    server_name media.website.com;
    ##############################
    
    client_max_body_size 512M;

    error_page 500 502 503 504 /static/500.html;
    error_page 400 402 403 404 /static/400.html;
    
    location /uploads {
        root /home/tornado/media/;
        limit_rate_after 0;
        limit_rate 150k;
#       try_files $uri =404;
        internal;
    }
    
    location / {
        add_header        Cache-Control private;
        expires           0;
        root /home/tornado/media/static/;
        try_files $uri @proxy_to_app;
    }

    location @proxy_to_app {
        proxy_pass_header Server;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Scheme $scheme;
        proxy_pass_request_headers      on;
        proxy_pass http://127.0.0.1:9092;
        expires off;
        }

    location /s3/ {
        proxy_pass_header Server;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Scheme $scheme;
        proxy_pass_request_headers      on;
        proxy_pass http://127.0.0.1:9092;
        expires off;
        }

    location /s4/ {
        proxy_pass_header Server;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Scheme $scheme;
        proxy_pass_request_headers      on;
        proxy_pass http://127.0.0.1:9093;
        expires off;
        }


}
