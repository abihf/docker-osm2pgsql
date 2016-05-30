FROM alpine
MAINTAINER Abi Hafshin <abi@hafs.in>

COPY updater-loop.sh /usr/local/bin/updater-loop.sh

ENV LANG en_US.utf8
ENV UPDATE_DIR /update

VOLUME /update


RUN apk -X http://nl.alpinelinux.org/alpine/edge/testing/ -U add \
        curl libpq expat geos proj4 bzip2 zlib boost boost-system boost-filesystem boost-iostreams \
        make cmake g++ python expat-dev geos-dev proj4-dev bzip2-dev zlib-dev boost-dev postgresql-dev && \
    wget -O osm2pgsql-0.90.0.tar.gz https://github.com/openstreetmap/osm2pgsql/archive/0.90.0.tar.gz && \
    tar xzf osm2pgsql-0.90.0.tar.gz && \
    mkdir build && cd build && \
    cmake ../osm2pgsql-0.90.0 && make && make install && \
    apk del make cmake g++ python expat-dev geos-dev proj4-dev bzip2-dev zlib-dev boost-dev postgresql-dev && \
    chmod +x /usr/local/bin/updater-loop.sh && \
    mkdir -p $UPDATE_DIR && \
    rm -rf /osm2pgsql-0.90.0 /osm2pgsql-0.90.0.tar.gz /build /var/cache/apk/*

CMD ["/usr/local/bin/updater-loop.sh"]
