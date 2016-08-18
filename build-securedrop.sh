#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

# Start the build with an empty ACI
acbuild --debug begin

# In the event of the script exiting, end the build
trap "{ export EXT=$?; acbuild --debug end && exit $EXT; }" EXIT

# Name the ACI
acbuild --debug set-name linx.li/securedrop

# Based on ubuntu
acbuild --debug dep add quay.io/sameersbn/ubuntu

# Install apt-transport-https 
# acbuild --debug run -- /bin/sh -c 'echo "deb http://security.ubuntu.com/ubuntu trusty-security main" >> /etc/apt/sources.list'
# acbuild --debug run -- apt-get update
# acbuild --debug run -- apt-get -y install apt-transport-https

# # Install securedrop-app-code
# acbuild --debug run -- apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-keys B89A29DB2128160B8E4B1B4CBADDE0C7FC9F6818
# acbuild --debug run -- /bin/sh -c 'echo "deb https://apt.freedom.press trusty main" > /etc/apt/sources.list.d/fpf.list'
# acbuild --debug run -- apt-get update
#acbuild --debug run -- apt-get -y upgrade

# Install curl and securedrop dependencies
acbuild --debug run -- /bin/sh -c 'echo "deb http://security.ubuntu.com/ubuntu trusty-security main" >> /etc/apt/sources.list'
acbuild --debug run -- apt-get update
acbuild --debug run -- apt-get -y upgrade
acbuild --debug run -- apt-get -y install curl python-pip apparmor-utils gnupg2 haveged python python-pip secure-delete sqlite apache2-mpm-worker libapache2-mod-wsgi libapache2-mod-xsendfile redis-server supervisor

# Install acbuild fork of securedrop-app-code
acbuild --debug run -- curl -o securedrop-app-code-acbuild.deb https://linx.li/selif/securedrop-app-code-038-amd64.deb
acbuild --debug run -- dpkg -i securedrop-app-code-acbuild.deb

acbuild --debug set-exec -- /bin/sh -c "chmod 755 / && /usr/sbin/httpd -D FOREGROUND"

acbuild --debug write --overwrite securedrop-app-code-0.3.8-amd64.aci
