FROM php:5.6-fpm

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN apt-get update && \
    apt-get install -y libmcrypt-dev libpq-dev netcat && \
    rm -rf /var/lib/apt/
RUN apt-get install -qq -y libgd-dev libfreetype6-dev libjpeg62-turbo-dev libpng12-dev
docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
docker-php-ext-install gd

RUN docker-php-ext-install \
        mcrypt \
        bcmath \
        mbstring \
        openssl \
        git \
        unzip \
        zip \
        opcache \
        mysqli \
        pdo pdo_mysql\
        make ruby ruby-dev \
        sass
        
#install compass 
RUN gem install --no-rdoc --no-ri compass

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version

#install ext-soap
RUN apt-get update -y \
  && apt-get install -y \
    libxml2-dev \
    php-soap \
  && apt-get clean -y \
  && docker-php-ext-install soap

RUN yes | pecl install xdebug-beta \
        && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini
