#!/bin/bash

echo -e "AMBIENTE $APP_ENV"

if [ $APP_ENV == "dev" ]
then
  echo -e "exec command: chown -R nginx:nginx * \n"
  chown -R nginx:nginx *

  echo -e "exec command: mkdir -pv /usr/share/nginx/html/{public/reports,bootstrap/cache,storage/framework/{sessions,views,cache}}\n"
  mkdir -pv /usr/share/nginx/html/{public/reports,bootstrap/cache,storage/framework/{sessions,views,cache}}
  
  echo -e "exec command: composer update --ansi --no-progress --optimize-autoloader\n"
  composer install --ansi --no-progress --optimize-autoloader 

  echo -e "exec command: php artisan view:clear --env=$APP_ENV \n"
  php artisan view:clear --env=$APP_ENV 

  echo -e "exec command: php artisan cache:clear --env=$APP_ENV \n"
  php artisan cache:clear --env=$APP_ENV

  echo -e "exec command:  php artisan optimize --env=$APP_ENV  \n" 
  php artisan optimize --env=$APP_ENV 
fi
