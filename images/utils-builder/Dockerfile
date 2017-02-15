FROM debian:jessie

RUN echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list
RUN echo "deb-src http://ftp.us.debian.org/debian/ jessie main" >> /etc/apt/sources.list

RUN apt-get update

RUN apt-get install --yes dpkg-dev
RUN apt-get build-dep --yes socat

RUN mkdir /socat

# Note that this approach does _not_ include libssl, but we don't need it for kubernetes anyway
RUN cd /socat; \
    CFLAGS=-static LDFLAGS=-static CPPFLAGS=-static CFLAGS_APPEND=-static \
    LDFLAGS_APPEND=-static CPPFLAGS_APPEND=-static \
    apt-get source --build socat

COPY extract.sh /extract.sh
