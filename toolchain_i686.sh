#!/bin/bash

# Set the installation prefix and target
BASE_DIR=$(pwd)
TOOLCHAIN_DIR="$BASE_DIR/i686"
PREFIX="$TOOLCHAIN_DIR"
TARGET=i686-elf
PATH="$PREFIX/bin:$PATH"

# Versions of the tools
GCC_VERSION=14.1.0
BINUTILS_VERSION=2.42

# Directories for sources and build
SRC_DIR="$HOME/src"
BUILD_DIR="$SRC_DIR/build"
mkdir -p "$PREFIX" "$SRC_DIR" "$BUILD_DIR"

# Function to download and extract a tarball
download_and_extract() {
    local url=$1
    local tarball=$(basename "$url")
    local dirname=${tarball%.tar.*}

    if [ ! -f "$SRC_DIR/$tarball" ]; then
        wget -c -O "$SRC_DIR/$tarball" "$url"
    fi
    if [ ! -d "$SRC_DIR/$dirname" ]; then
        tar -xf "$SRC_DIR/$tarball" -C "$SRC_DIR"
    fi
}

# Fast mirrors
GCC_URL="https://mirrors.kernel.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz"
BINUTILS_URL="https://mirrors.kernel.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz"

# Download GCC and Binutils sources
download_and_extract "$BINUTILS_URL"
download_and_extract "$GCC_URL"

# Build and install Binutils
mkdir -p "$BUILD_DIR/binutils"
cd "$BUILD_DIR/binutils"
"$SRC_DIR/binutils-$BINUTILS_VERSION/configure" \
    --target=$TARGET --prefix=$PREFIX --with-sysroot --disable-nls --disable-werror
make -j$(nproc)
make install

# Build and install GCC (bootstrap)
mkdir -p "$BUILD_DIR/gcc"
cd "$BUILD_DIR/gcc"
"$SRC_DIR/gcc-$GCC_VERSION/configure" \
    --target=$TARGET --prefix=$PREFIX --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc -j$(nproc)
make install-gcc
make all-target-libgcc -j$(nproc)
make install-target-libgcc

echo "Cross-compiler for $TARGET installed in $PREFIX"
"$PREFIX/bin/$TARGET-gcc" --version

