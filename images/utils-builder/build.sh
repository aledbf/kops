#!/bin/bash

set -e
set -o pipefail

function build_musl() {
    cd /build

    # Download
    curl -LO http://www.musl-libc.org/releases/musl-${MUSL_VERSION}.tar.gz
    tar zxvf musl-${MUSL_VERSION}.tar.gz
    cd musl-${MUSL_VERSION}

    # Build
    ./configure
    make -j4
    make install
}

function build_ncurses() {
    cd /build

    # Download
    curl -LO ftp://invisible-island.net/ncurses/ncurses-${NCURSES_VERSION}.tar.gz
    tar zxvf ncurses-${NCURSES_VERSION}.tar.gz
    cd ncurses-${NCURSES_VERSION}

    # Build
    CC='/usr/local/musl/bin/musl-gcc -static' CFLAGS='-fPIC' ./configure \
        --disable-shared \
        --enable-static
}

function build_readline() {
    cd /build

    # Download
    curl -LO ftp://ftp.cwru.edu/pub/bash/readline-${READLINE_VERSION}.tar.gz
    tar xzvf readline-${READLINE_VERSION}.tar.gz
    cd readline-${READLINE_VERSION}
    ln -s /build/readline-${READLINE_VERSION} /build/readline
    ln -s /build/readline-${READLINE_VERSION} /usr/local/readline

    # Build
    CC='/usr/local/musl/bin/musl-gcc -static' \
        CFLAGS='-fPIC' \
        ./configure --disable-shared --enable-static
    make -j4
    make install-static
}

function build_openssl() {
    cd /build

    # Download
    curl -LO https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
    tar zxvf openssl-${OPENSSL_VERSION}.tar.gz
    cd openssl-${OPENSSL_VERSION}

    # Configure
    CC='/usr/local/musl/bin/musl-gcc -static' \
        CFLAGS='-fPIC' \
        ./Configure no-shared linux-x86_64

    # Build
    make -j4
    echo "** Finished building OpenSSL"
}

function build_socat() {
    cd /build

    # Download
    curl -LO http://www.dest-unreach.org/socat/download/socat-${SOCAT_VERSION}.tar.gz
    tar xzvf socat-${SOCAT_VERSION}.tar.gz
    cd socat-${SOCAT_VERSION}

    # Build
    # NOTE: `NETDB_INTERNAL` is non-POSIX, and thus not defined by MUSL.
    # We define it this way manually.
    CC='/usr/local/musl/bin/musl-gcc -static' \
        CFLAGS="-fPIC -DWITH_OPENSSL -I/build -I/build/openssl-${OPENSSL_VERSION}/include -I/build/readline -DNETDB_INTERNAL=-1" \
        CPPFLAGS="-DWITH_OPENSSL -I/build -I/build/openssl-${OPENSSL_VERSION}/include -I/build/readline -DNETDB_INTERNAL=-1" \
        LDFLAGS="-L/build/readline -L/build/ncurses-${NCURSES_VERSION}/lib -L/build/openssl-${OPENSSL_VERSION}" \
        ./configure
    make -j4
    strip socat
}

build_musl
build_ncurses
build_readline
build_openssl
build_socat
