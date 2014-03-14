#!/bin/bash
set -e
set -x

mkdir -p sdks

if [ ! -e  $HOME/MacOSX10.6.sdk ]; then
        pushd $HOME
        wget https://github.com/kyleconroy/cccgo/releases/download/vSDK10.6/MacOSX10.6.sdk.zip
        unzip -q MacOSX10.6.sdk.zip
        rm -f MacOSX10.6.sdk.zip
        popd
fi

if [ ! -e /mnt/xtool/crosstool-ng ]; then
        pushd /mnt/xtool
        git clone https://github.com/diorcety/crosstool-ng
        popd
fi

if [ ! -e /mnt/xtool/crosstool-ng/ct-ng ]; then
        pushd /mnt/xtool/crosstool-ng
        ./bootstrap
        ./configure --enable-local
        make
        popd
fi

# Create the OS X 64bit toolchain
if [ ! -e $HOME/x-tools/x86_64-apple-darwin10 ]; then
        pushd /mnt/xtool/crosstool-ng
        ./ct-ng x86_64-apple-darwin10
        ./ct-ng build
        ./ct-ng distclean
        popd
fi

# FIXME Creae a tarball
if [ ! -e dist/host_linux_64_target_darwin_64.tar.gz ]; then
        pushd $HOME/x-tools
        tar -cvzf x86_64-apple-darwin10.tar.gz x86_64-apple-darwin10.tar.gz
        popd
        mv $HOME/x-tools/x86_64-apple-darwin10.tar.gz dist/host_linux_64_target_darwin_64.tar.gz
fi
