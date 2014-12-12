#########################################
#                                       #
# Docker fo Keepass                     #
#                                       #
#                                       #
# VERSION      0.0.1                    #
# AUTHOR       Philip Bergman           #
#                                       #
#########################################
FROM		debian:stable
MAINTAINER 	Philip Bergman <philip@zicht.nl>
# update repository
RUN echo "deb http://ftp.nl.debian.org/debian/ stable main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -yq
# install packages
RUN apt-get install mono-complete -qy
RUN apt-get install php5-cli  -qy
RUN apt-get install curl  -qy
RUN apt-get install git  -qy
# install composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
#  Add group
RUN groupadd --gid 1000 \
             --non-unique \
             keepasss
#  Add user
RUN useradd --comment 'keepass user' \
		    --shell /bin/bash \
		    --create-home \
		    --home-dir /home/keepass \
            --uid 1000 \
            --gid 1000 \
            --non-unique \
		    keepass
RUN echo "keepass:k33p@$$" | chpasswd
RUN echo "root:r00t3r" | chpasswd
# Change user
USER keepass
# Setup keepass env
ENV HOME /home/keepass
ENV USER KeePass
WORKDIR  /home/keepass
# Get and setup keepass cli
RUN git clone https://github.com/pbergman/KeePassCli.git
RUN composer --working-dir="${HOME}/KeePassCli" install --optimize-autoloader
ADD config/KeePass.yml /home/keepass/KeePassCli/vendor/pbergman/keepass/PBergman/KeePass/Config/KeePass.yml
RUN ln -sf /home/keepass/KeePassCli/vendor/pbergman/keepass/bin/KeePass/KeePass.exe /home/keepass/KeePassCli/KeePass.exe
