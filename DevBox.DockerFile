FROM ubuntu:20.04

USER root
ENV TZ=US/Eastern

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
echo $TZ > /etc/timezone

RUN DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get install -y build-essential
RUN apt install -y curl ssh vim
    
RUN apt install -y apache2
RUN apt-get clean

RUN add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt install -y php8.0 libapache2-mod-php8.0 
RUN apt install -y php8.0-fpm php8.0-xdebug php8.0-cli php8.0-common php8.0-curl php8.0-gd php8.0-gmp php8.0-imap php8.0-intl php8.0-mbstring php8.0-mysql php8.0-pgsql php8.0-soap php8.0-sqlite3 php8.0-xml php8.0-xmlrpc php8.0-zip 
        
RUN a2enconf php8.0-fpm
# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php \
  && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer

#install node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

ENV APACHE_RUN_USER  www-data

ENV APACHE_RUN_GROUP www-data

ENV APACHE_LOG_DIR   /var/log/apache2

ENV APACHE_PID_FILE  /var/run/apache2/apache2.pid

ENV APACHE_RUN_DIR   /var/run/apache2

ENV APACHE_LOCK_DIR  /var/lock/apache2

RUN mkdir -p $APACHE_RUN_DIR

RUN mkdir -p $APACHE_LOCK_DIR

RUN mkdir -p $APACHE_LOG_DIR

WORKDIR /var/www/html
# Copy existing application directory permissions
RUN chown -R www-data:www-data /var/www/html

CMD ["apachectl","-D","FOREGROUND"]
RUN a2enmod rewrite
EXPOSE 80
EXPOSE 443



