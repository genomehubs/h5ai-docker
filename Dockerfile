FROM ubuntu:focal
MAINTAINER Richard Challis/GeneomHubs contact@genomehubs.org

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    git \
    php7.4-cgi \
    unzip \
    wget

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y build-dep lighttpd

RUN useradd lighttpd && mkdir -p /lighttpd/conf && chown -R lighttpd:lighttpd /lighttpd

RUN mkdir -p /var/www/html && chown -R lighttpd:lighttpd /var/www/html

RUN mkdir -p /conf && chown -R lighttpd:lighttpd /conf

EXPOSE 8080

USER lighttpd

WORKDIR /tmp

RUN wget -c https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.64.tar.gz -O - | tar xz

WORKDIR /tmp/lighttpd-1.4.64

RUN ./configure --prefix=/lighttpd --without-pcre2 \
    && make \
    && make install

#RUN lighty-enable-mod fastcgi && \
#    lighty-enable-mod fastcgi-php

COPY lighttpd.conf /lighttpd/conf/

RUN mkdir -p /lighttpd/uploads && mkdir -p /lighttpd/log && mkdir -p /lighttpd/run && mkdir -p /lighttpd/cache

ARG VERSION=0.30.0

WORKDIR /tmp

RUN wget https://release.larsjung.de/h5ai/h5ai-$VERSION.zip && \
    unzip h5ai-$VERSION.zip -d /var/www/html/ && \
    sed -i "s;\"hidden\": \[;\"hidden\": \[\"cgi-bin\",\"^/img\",\"^/utils\",;" /var/www/html/_h5ai/private/conf/options.json

COPY startup.sh /lighttpd/

RUN mkdir -p /var/www/html/utils

WORKDIR /var/www/html/utils

ARG CACHEBUSTER=15a7f5e23

RUN git clone https://github.com/rjchallis/assembly-stats && \
    git clone https://github.com/rjchallis/codon-usage

CMD /lighttpd/startup.sh
