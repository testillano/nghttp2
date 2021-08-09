ARG base_tag=latest
FROM alpine:${base_tag}
MAINTAINER testillano & jgomezselles

LABEL testillano.nghttp2.description="Docker image to build libraries & projects based in Tatsuhiro nghttp2-asio library"

WORKDIR /code/build

ARG make_procs=4
ARG nghttp2_ver=1.42.0
ARG boost_ver=1.72.0

RUN apk add build-base cmake wget tar linux-headers openssl-dev libev-dev openssl-libs-static

# boost
RUN set -x && \
    wget https://sourceforge.net/projects/boost/files/boost/${boost_ver}/boost_$(echo ${boost_ver} | tr '.' '_').tar.gz && tar xvf boost* && cd boost*/ && \
    ./bootstrap.sh && ./b2 -j${make_procs} install && \
    cd .. && rm -rf * && \
    set +x

# nghttp2
RUN set -x && \
    wget https://github.com/nghttp2/nghttp2/releases/download/v${nghttp2_ver}/nghttp2-${nghttp2_ver}.tar.bz2 && tar xf nghttp2* && cd nghttp2*/ && \
    ./configure --enable-asio-lib --disable-shared && make -j${make_procs} install && \
    cd .. && rm -rf * && \
    set +x

# Build script
COPY deps/build.sh /var
RUN chmod a+x /var/build.sh

ENTRYPOINT ["/var/build.sh"]
CMD []
