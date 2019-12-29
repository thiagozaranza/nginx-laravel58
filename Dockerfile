FROM nginx:1.17.6

LABEL MAINTAINER="<thiagozaranza@gmail.com>"

ENV DEBIAN_VERSION "stretch"

ENV APP_ENV="dev"
ENV APP_NAME="bvsb-api"

RUN apt update
RUN apt upgrade

RUN apt install -y \
				apt-transport-https \
				lsb-release \
				ca-certificates \
				vim \
				procps \
				supervisor \
				perl \
				git \
				wget \
				cron \
				software-properties-common 				

RUN set -ex \
	&& wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
 	&& sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
	&& mkdir /run/php/ 

RUN echo "deb https://packages.sury.org/php/ stretch main " >> /etc/apt/sources.list

RUN apt-get update

ENV PHP_VERSION="php7.4"
ENV APP_ENV="dev"
ENV MEMORY_LIMIT="512"
ENV UPLOAD_MAX_FILESIZE="256"
ENV PROXY_CONNECT_TIMEOUT="500"
ENV PROXY_SEND_TIMEOUT="300"
ENV SEND_TIMEOUT="300"

RUN apt install -y \
		$PHP_VERSION-common \
		$PHP_VERSION-readline \
		$PHP_VERSION-fpm \
		$PHP_VERSION-cli \
		$PHP_VERSION-gd \
		7.1-mcrypt \
		$PHP_VERSION-curl \
		$PHP_VERSION-mbstring \
		$PHP_VERSION-opcache \
		$PHP_VERSION-json \
		$PHP_VERSION-pgsql \
		$PHP_VERSION-xmlwriter \
		$PHP_VERSION-zip \
		$PHP_VERSION-tokenizer

RUN set -ex \
		&& sed -i "s/zlib.output_compression = .*/zlib.output_compression = on/" /etc/php/7.4/fpm/php.ini \
		&& sed -i "s/max_execution_time = .*/max_execution_time = 18000/" /etc/php/7.4/fpm/php.ini \
 		&& wget -O ~/installer http://getcomposer.org/installer \
		&& php ~/installer --install-dir=/usr/bin --filename=composer \
		&& rm -rf ~/installer 

RUN set -ex \
		&& php-fpm7.4 -t \
		&& service php7.4-fpm restart

RUN apt-get clean

ADD scripts/crontab /var/spool/cron/crontabs/root
ADD scripts/supervisord.conf /etc/supervisord.conf
ADD scripts/supervisord.conf /etc/supervisord.conf
ADD scripts/default.conf /etc/nginx/conf.d/default.conf
ADD scripts/php-fpm.conf /etc/php7/php-fpm.conf
ADD scripts/proxy-settings.conf /etc/nginx/conf.d/proxy-settings.conf

ADD scripts/start-compose.sh /start-compose.sh
RUN chmod +x /start-compose.sh

ADD scripts/start-queue.sh /start-queue.sh
RUN chmod +x /start-queue.sh

ADD scripts/start-cron.sh /start-cron.sh
RUN chmod +x /start-cron.sh

ADD scripts/start-nginx.sh /start-nginx.sh
RUN chmod +x /start-nginx.sh

ADD scripts/start.sh /start.sh
RUN chmod +x /start.sh

ENV TZ="America/Fortaleza" 
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 80 443
WORKDIR /usr/share/nginx/html

CMD ["/start.sh"]
