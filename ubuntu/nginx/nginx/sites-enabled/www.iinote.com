server {
        listen   80;
        server_name  *.iinote.com;
        access_log  /var/log/nginx/www.iinote.com.access.log;
        rewrite  ^/(.*)$  http://iinote.com  permanent;
}

upstream thin {
        server 127.0.0.1:9011;
}

server {
        listen 80;
        server_name iinote.com;
        access_log  /var/log/nginx/www.iinote.com.access.log;
        root /home/hidden/iinote/web/public;

        client_header_buffer_size 256k;
        large_client_header_buffers 4 256k;
        client_max_body_size             50m;
        client_body_buffer_size        256k;
        client_header_timeout     10m;
        client_body_timeout 10m;
        send_timeout             10m;
        charset utf-8;

        error_page  404 /404.html;

        location /404.html {
            root /home/hidden/iinote/web/public;
        }

        error_page 500 502 503 504 /500.html;

        location /500.html {
            root /home/hidden/iinote/web/public;
        }

        location ~ ^/?(favicon\.ico|amcharts|images|javascripts|stylesheets|js|css|flash|media|static)/ {
            	root /home/hidden/iinote/web/public;
                access_log  off;
                expires 30d;
        }

        location ~* ^.+\.(html|htm|xhtml)$ {
            	root /home/hidden/iinote/web/public;
                access_log off;
                expires 30d;
        }

        location / {
            proxy_pass http://thin;
            include proxy.conf;
        }
}
