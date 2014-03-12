#!/bin/bash
set -e
set -x

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
        autoconf gperf bison flex texinfo gawk libtool libncurses5-dev \
        gcc-arm-linux-gnueabihf gcc-mingw32 gcc-mingw-w64

# cross tools

if [ ! -e /usr/local/go ]; then
        pushd /usr/local
        hg clone -u release https://code.google.com/p/go
        popd
fi

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

# FIXME: Move this to GitHub
if [ ! -e  $HOME/MacOSX10.6.sdk ]; then
        pushd $HOME
        wget http://jamesgeorge.org/uploads/MacOSX10.6.sdk.zip 
        unzip -q MacOSX10.6.sdk.zip
        rm -f MacOSX10.6.sdk.zip
        popd
fi

if [ ! -e $HOME/crosstool-ng ]; then
        pushd $HOME
        git clone https://github.com/diorcety/crosstool-ng
        popd
fi

if [ ! -e crosstool-ng/ct-ng ]; then
        pushd $HOME/crosstool-ng
        ./bootstrap
        ./configure --enable-local
        make
        popd
fi

# Create the OS X toolchain
pushd $HOME/crosstool-ng
./ct-ng x86_64-apple-darwin10
./ct-ng build
popd
