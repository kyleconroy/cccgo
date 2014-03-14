cccgo
=====

Cross-compile CGO

    export PATH="$PATH:/mnt/crosstool-ng/.build/x86_64-apple-darwin10/buildtools/bin/"

symlink the linker to ld in the path

CC=x86_64-build_unknown-linux-gnu-gcc GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 go build -x -work -ldflags="-extld=x86_64-build_unknown-linux-gnu-gcc"

CC=x86_64-build_unknown-linux-gnu-gcc GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 /usr/local/go/pkg/tool/linux_amd64/6l -v -o cgoecho -L $WORK -extld=x86_64-build_unknown-linux-gnu-gcc $WORK/_/mnt/crosstool-ng/cgoecho.a

Current error:
host link: '' -m64 -gdwarf-2 -Wl,-no_pie,-pagezero_size,4000000 -o cgoecho output/000000.o output/000001.o output/go.o -lpthread

CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 CGO_ENABLED=1 go build -x -work -o windows.exe -ldflags="-extld=$CC"

-c call graph didn't help
-n symbol table didn't help
