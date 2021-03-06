FROM resin/raspberrypi3-debian:jessie
MAINTAINER Josh Lamb

ENV PROJECT /var/www/html
# Enable systemd
ENV INITSYSTEM on
EXPOSE 80

RUN apt-get update && apt-get install -y --no-install-recommends git

RUN git clone https://github.com/kiswa/TaskBoard $PROJECT

RUN apt-get update && apt-get install -y --no-install-recommends apache2 curl git openjdk-7-jre php5 php5-cli php5-sqlite libapache2-mod-php5 sqlite 

RUN a2enmod rewrite
RUN a2enmod expires

WORKDIR $PROJECT

RUN ./build/composer.phar install
RUN ./build/build-all

RUN chmod -R +w $PROJECT/api/
RUN chown -R www-data:www-data $PROJECT/
RUN service apache2 restart
