#!/bin/sh -ex

mkdir -p /dist

rm -f /utils.tar.gz
rm -rf /utils

mkdir -p /utils
cp /build/socat-*/socat /utils/socat
(sha1sum /utils/socat | cut -d' ' -f1) > /utils/socat.sha1

tar cvfz /utils.tar.gz /utils

cp /utils.tar.gz /dist/utils.tar.gz
(sha1sum /dist/utils.tar.gz | cut -d' ' -f1) > /dist/utils.tar.gz.sha1
