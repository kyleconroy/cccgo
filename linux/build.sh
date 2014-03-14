#!/bin/bash
set -e
set -x

# FIXME: Add support for custom path, not just /mnt
# FIXME: Add support for custom user, not just ubuntu

# Update the apt-get sources
if [ ! -e /var/lib/apt/periodic/update-success-stamp ]; then
        apt-get -y update
        apt-get -y autoclean
        touch /var/lib/apt/periodic/update-success-stamp
fi

# Install the needed dependencies
apt-get -y install \
        libc6-dev libc6-dev-i386 curl make mercurial git unzip \
        autoconf gperf bison flex texinfo gawk libtool libncurses5-dev g++

mkdir -p /mnt/xtool
chown ubuntu:ubuntu /mnt/xtool

su -c ./crosstool.sh -s /bin/sh ubuntu
