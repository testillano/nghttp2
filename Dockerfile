FROM alpine:latest
MAINTAINER testillano & jgomezselles

LABEL testillano.nghttp2_build.description="Image for building C++ nghttp2 & boost sources"

WORKDIR /code/build

ARG make_procs=4
ENV make_procs=${make_procs}
ARG build_type=
ENV build_type=${build_type}

ARG nghttp2_ver=1.42.0
ARG boost_ver=1.67.0

RUN apk add build-base cmake wget tar linux-headers openssl-dev libev-dev openssl-libs-static

# boost
RUN set -x && \
    wget https://dl.bintray.com/boostorg/release/${boost_ver}/source/boost_$(echo ${boost_ver} | tr '.' '_')_rc2.tar.gz && tar xvf boost* && cd boost*/ && \
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
COPY deps/build.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/build.sh

ENTRYPOINT ["build.sh"]
CMD []
