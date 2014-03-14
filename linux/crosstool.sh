#!/bin/bash
set -e
set -x

mkdir -p sdks


if [ ! -e  $HOME/MacOSX10.6.sdk ]; then
        pushd $HOME
        wget https://github.com/kyleconroy/cccgo/releases/download/vSDK10.6/MacOSX10.6.sdk.zip
        unzip -q MacOSX10.6.sdk.zip
        rm -f MacOSX10.6.sdk.zip
        rm -f __MACOSX
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

function make_toolchain {
if [ ! -e $HOME/x-tools/$1 ]; then
        pushd /mnt/xtool/crosstool-ng
        ./ct-ng $1
        ./ct-ng build
        ./ct-ng distclean
        popd
fi
} 

function pack_toolchain {
if [ ! -e dist/x86_64-unknown-linux-gnu_to_$1.tar.gz ]; then
        pushd $HOME/x-tools
        tar -cvzf $1.tar.gz $1
        popd
        mv $HOME/x-tools/$1.tar.gz dist/x86_64-unknown-linux-gnu_to_$1.tar.gz

fi
} 

# Create the OS X x86_64 toolchain
make_toolchain x86_64-apple-darwin10
pack_toolchain x86_64-apple-darwin10

# Create the OS X i686 toolchain
# make_toolchain i686-apple-darwin10
# pack_toolchain i686-apple-darwin10

# Create the Windows x86-64 toolchain
# make_toolchain x86_64-unknown-mingw32
# pack_toolchain x86_64-unknown-mingw32
