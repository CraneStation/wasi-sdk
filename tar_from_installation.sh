#!/usr/bin/env bash
set -ex
OUTDIR=$PWD/dist
VERSION=`./version.sh`
INDIR=/opt/wasi-sdk

if [ -n "$1" ]; then
    OUTDIR=$1
fi

if [ -n "$2" ]; then
    VERSION="$2"
fi

if [ -n "$3" ]; then
    INDIR="$3"
fi

PKGDIR=build/wasi-sdk-$VERSION

case "$(uname -s)" in
    Linux*)     MACHINE=linux;;
    Darwin*)    MACHINE=macos;;
    CYGWIN*)    MACHINE=cygwin;;
    MINGW*)     MACHINE=mingw;;
    *)          MACHINE="UNKNOWN"
esac

rm -rf $PKGDIR
cp -R $INDIR $PKGDIR
cd build
tar czf $OUTDIR/wasi-sdk-$VERSION\-$MACHINE.tar.gz wasi-sdk-$VERSION

# As well as the full SDK package, also create archives of libclang_rt.builtins
# and the sysroot. These are made available for users who have an existing clang
# installation.
tar czf $OUTDIR/libclang_rt.builtins-wasm32-wasi-$VERSION.tar.gz -C compiler-rt lib/wasi
tar czf $OUTDIR/wasi-sysroot-$VERSION.tar.gz -C wasi-sdk-$VERSION/share wasi-sysroot
