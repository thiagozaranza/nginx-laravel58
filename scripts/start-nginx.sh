#!/bin/bash

sed -i "s/memory_limit = .*/memory_limit = ${MEMORY_LIMIT}M/" /etc/php/7.4/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = ${UPLOAD_MAX_FILESIZE}M/" /etc/php/7.4/fpm/php.ini
sed -i "s/proxy_connect_timeout   300;/proxy_connect_timeout   ${PROXY_CONNECT_TIMEOUT};/" /etc/nginx/conf.d/proxy-settings.conf
sed -i "s/proxy_send_timeout   300;/proxy_send_timeout    ${PROXY_SEND_TIMEOUT};/" /etc/nginx/conf.d/proxy-settings.conf
sed -i "s/send_timeout   300;/send_timeout   ${SEND_TIMEOUT};/" /etc/nginx/conf.d/proxy-settings.conf

chown -R nginx:nginx /usr/share/nginx/html/
/usr/sbin/nginx -g "daemon off;"