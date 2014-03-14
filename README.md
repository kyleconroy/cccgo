cccgo
=====


# Junk

Cross-compile CGO

    export PATH="$PATH:/home/ubuntu/x-tools/x86_64-apple-darwin10/bin/:/usr/local/go/bin/"

symlink the linker to ld in the path

CC=x86_64-apple-darwin10-clang CGO_CFLAGS="-I/home/ubuntu/MacOSX10.6.sdk/usr/include/ -I." CGO_LDFLAGS="-L/home/ubuntu/MacOSX10.6.sdk/usr/lib/ -L/home/ubuntu/x-tools/x86_64-apple-darwin10/lib/gcc/x86_64-apple-darwin10/4.2.1/" GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 go build -x -work -ldflags="-extld=x86_64-apple-darwin10-clang"

mkdir -p output

Current error:
host link: '' -m64 -gdwarf-2 -Wl,-no_pie,-pagezero_size,4000000 -o cgoecho output/000000.o output/000001.o output/go.o -lpthread

CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 CGO_ENABLED=1 go build -x -work -o windows.exe -ldflags="-extld=$CC"

-c call graph didn't help
-n symbol table didn't help

/usr/bin/ld: unrecognized option '-pagezero_size'
/usr/bin/ld: use the --help option for usage information

"/home/ubuntu/x-tools/x86_64-apple-darwin10/bin/x86_64-apple-darwin10-ld" -dynamic -arch x86_64 -macosx_version_min 10.6.0 
  -syslibroot /home/ubuntu/x-tools/x86_64-apple-darwin10/x86_64-apple-darwin10/sysroot 
  -o /tmp/go-build611660756/runtime/cgo/_obj/_cgo_.o -lcrt1.10.6.o 
  -L/home/ubuntu/MacOSX10.6.sdk/usr/lib/
  -L/home/ubuntu/x-tools/x86_64-apple-darwin10/x86_64-apple-darwin10/sysroot/usr/lib/gcc/i686-apple-darwin10/4.2.1/x86_64
  -L/home/ubuntu/x-tools/x86_64-apple-darwin10/x86_64-apple-darwin10/sysroot/usr/lib/gcc/i686-apple-darwin10/4.2.1/x86_64
  -L/home/ubuntu/x-tools/x86_64-apple-darwin10/x86_64-apple-darwin10/sysroot/usr/lib/i686-apple-darwin10/4.2.1
  -L/home/ubuntu/x-tools/x86_64-apple-darwin10/x86_64-apple-darwin10/sysroot/usr/lib/gcc/i686-apple-darwin10/4.2.1
  -L/home/ubuntu/x-tools/x86_64-apple-darwin10/x86_64-apple-darwin10/sysroot/usr/lib/gcc/i686-apple-darwin10/4.2.1
  -L/home/ubuntu/x-tools/x86_64-apple-darwin10/x86_64-apple-darwin10/sysroot/usr/lib/gcc/i686-apple-darwin10/4.2.1/../../../i686-apple-darwin10/4.2.1 
  -L/home/ubuntu/x-tools/x86_64-apple-darwin10/x86_64-apple-darwin10/sysroot/usr/lib/gcc/i686-apple-darwin10/4.2.1/../../.. 
  /tmp/go-build611660756/runtime/cgo/_obj/_cgo_main.o /tmp/go-build611660756/runtime/cgo/_obj/_cgo_export.o /tmp/go-build611660756/runtime/cgo/_obj/cgo.cgo2.o /tmp/go-build611660756/runtime/cgo/_obj/gcc_darwin_amd64.o /tmp/go-build611660756/runtime/cgo/_obj/gcc_setenv.o /tmp/go-build611660756/runtime/cgo/_obj/gcc_util.o /tmp/go-build611660756/runtime/cgo/_obj/gcc_amd64.o -lpthread -lSystem -lgcc


# goxc

# xtool


```
linux/
  build.sh
  build-crosstool.sh
  dist/
```

xtool is a set of scripts for automating the entire process of building
toolchains for cross-compilation. These scripts are a small wrapper around
[diorecty's crosttol-ng](https://github.com/diorcety/crosstool-ng).

## Linux

These scripts have been tested and run on Ubuntu 12.04 on EC2. There are a few
paths that need to be changed to work on Linux outside of EC2.

    cd linux
    sudo ./build.sh
