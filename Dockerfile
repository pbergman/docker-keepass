# KeePass
#
# VERSION               0.0.1
FROM		debian:stable
MAINTAINER 	Philip Bergman <philip@zicht.nl>

# update repository
RUN echo "deb http://ftp.nl.debian.org/debian/ stable main contrib non-free" > /etc/apt/sources.list
RUN apt-get update

# install packages
RUN apt-get install mono-complete -qy
RUN apt-get install php5-cli  -qy
RUN apt-get install curl  -qy
RUN apt-get install git  -qy

# install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

#  Add user
RUN useradd --comment 'keepass user' \
		    --user-group \ 
		    --system \ 
		    --shell /bin/bash \ 
		    --create-home \ 
		    --home-dir /home/keepass \ 
		    keepass
RUN echo "keepass:k33p@$$" | chpasswd
RUN echo "root:root@123456" | chpasswd

# Change user
USER keepass

# Setup keepass
ENV HOME /home/keepass
RUN cd /home/keepass && git clone https://github.com/pbergman/KeePassCli.git
RUN cd /home/keepass/KeePassCli && composer install
ADD config/KeePass.yml /home/keepass/KeePassCli/vendor/pbergman/keepass/PBergman/KeePass/Config/KeePass.yml