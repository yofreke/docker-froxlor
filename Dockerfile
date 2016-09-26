FROM ubuntu:15.10
MAINTAINER Joe B <jbrown@blackstormlabs.com>

USER root
RUN apt-get update -y


# Adding Froxlor's Package Repository
RUN apt-get update -y && \
    apt-get install -y python-software-properties
RUN touch /etc/apt/sources.list.d/froxlor.list
RUN echo 'deb http://debian.froxlor.org jessie main' > /etc/apt/sources.list.d/froxlor.list
RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-key FD88018B6F2D5390D051343FF6B4A8704F9E9BBC

RUN apt-get update -y && apt-get upgrade -y


# Install server deps
# no candidate: php5-suhosin
RUN apt-get --yes --force-yes update && \
    apt-get install --force-yes -y wget curl apache2 \
        php5 php5-cgi php5-cli php5-common php5-curl php5-dev php5-gd php5-tidy \
        php5-xmlrpc php5-xsl php5-mcrypt php5-imap php5-imagick \
        libapache2-mod-php5
# Utilities
RUN apt-get --yes --force-yes install \
  wget curl vim nano htop
# Install mysql
RUN echo 'mysql-server mysql-server/root_password password root' | debconf-set-selections && \
    echo 'mysql-server mysql-server/root_password_again password root' | debconf-set-selections && \
    apt-get --yes --force-yes install mysql-server php5-mysql


# Download tarbal
RUN mkdir -p /var/www && \
    cd /var/www/ && \
    wget http://files.froxlor.org/releases/froxlor-latest.tar.gz && \
    tar xvfz froxlor-latest.tar.gz && \
    rm froxlor-latest.tar.gz

RUN chown -R www-data:www-data /var/www/froxlor
# Point apache root to /var/www
RUN sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www/' /etc/apache2/sites-available/000-default.conf

ADD launch.sh /launch.sh

ENTRYPOINT /launch.sh
