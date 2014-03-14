#!/bin/bash
set -e
set -x

# FIXME Add support for custom USER
export PATH="$PATH:/usr/local/go/bin:/usr/local/gopath/bin"
export GOPATH="/usr/local/gopath"

mkdir -p GOPATH

# Update the apt-get sources
if [ ! -e /var/lib/apt/periodic/update-success-stamp ]; then
        apt-get -y update
        apt-get -y autoclean
        touch /var/lib/apt/periodic/update-success-stamp
fi

apt-get -y install \
        libc6-dev libc6-dev-i386 curl make mercurial git unzip \
        autoconf gperf bison flex texinfo gawk libtool libncurses5-dev g++ \
        gcc-arm-linux-gnueabihf gcc-mingw32 gcc-mingw-w64

# cross tools
if [ ! -e /usr/local/go ]; then
        pushd /usr/local
        hg clone -u release https://code.google.com/p/go
        popd
fi

# FIXME: This patch actually doesn't work
if [ ! -e /usr/local/go/.patched ]; then
        pushd /usr/local/go
        curl https://gist.github.com/steeve/6905542/raw/cross_compile_goos.patch | patch -p1
        touch .patched
fi

if [ ! -e /usr/local/go/bin/go ]; then
        pushd /usr/local/go/src
        bash all.bash
        popd
fi

go get github.com/mitchellh/gox

# This takes quite some time
if [ ! -e /usr/local/go/pkg/tool/plan9_386 ]; then
        gox -build-toolchain
fi

if [ ! -e /etc/profile.d/go.sh ]; then
        echo 'export PATH="$PATH::/usr/local/go/bin/"' > /etc/profile.d/go.sh
fi

if [ ! -e /etc/profile.d/xtool.sh ]; then
        echo 'export PATH="$PATH:/home/ubuntu/x-tools/x86_64-apple-darwin10/bin/"' > /etc/profile.d/xtool.sh
fi

mkdir -p /mnt/xtool
chown ubuntu:ubuntu /mnt/xtool

su -c /home/ubuntu/build-crosstool-ng.sh -s /bin/sh ubuntu
