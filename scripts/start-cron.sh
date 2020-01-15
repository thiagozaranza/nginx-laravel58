#!/bin/bash

while [ true ]
    do
      php /usr/share/nginx/html/artisan schedule:run --verbose --no-interaction &
      sleep 60
    done