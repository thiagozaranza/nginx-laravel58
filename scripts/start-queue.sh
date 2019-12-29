#!/bin/bash

if [ -d /usr/share/nginx/html ]
then
    chown -R nginx:nginx /usr/share/nginx/html
    php /usr/share/nginx/html/artisan queue:work --tries=3
fi
