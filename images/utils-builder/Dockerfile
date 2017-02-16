FROM debian:jessie

ENV MUSL_VERSION      1.1.16
ENV SOCAT_VERSION     1.7.3.2
ENV NCURSES_VERSION   6.0
ENV READLINE_VERSION  7.0
ENV OPENSSL_VERSION   1.0.2k

RUN apt-get update \
  && apt-get upgrade --yes \
  && apt-get install --yes \
    automake \
    build-essential \
    curl \
    git  \
    pkg-config \
    linux-libc-dev \
  && apt-get clean

COPY extract.sh /extract.sh
COPY build.sh /build/build.sh

RUN /build/build.sh
