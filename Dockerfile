ARG base_os=ubuntu
ARG base_tag=latest
FROM ${base_os}:${base_tag}
MAINTAINER testillano

ARG base_os=ubuntu

LABEL testillano.nghttp2.description="Docker image to build libraries & projects based in Tatsuhiro nghttp2-asio library"
LABEL testillano.nghttp2.base-os="${base_os}"

WORKDIR /code/build

ARG make_procs=4
ARG nghttp2_ver=1.64.0
ARG nghttp2_asio_ver=main # no releases for https://github.com/nghttp2/nghttp2-asio (stops at e877868), so we download main.zip
ARG boost_ver=1.84.0

RUN if [ "${base_os}" = "alpine" ] ; then apk update && apk add build-base cmake zip wget tar linux-headers openssl-dev libev-dev openssl-libs-static && rm -rf /var/cache/apk/* ; elif [ "${base_os}" = "ubuntu" ] ; then apt-get update && apt-get install -y wget zip make cmake g++ bzip2 patch libssl-dev && apt-get clean ; fi

COPY deps/patches/ /patches

# boost
# wget https://sourceforge.net/projects/boost/files/boost/${boost_ver}/boost_$(echo ${boost_ver} | tr '.' '_').tar.gz && tar xvf boost* && cd boost*/ && \
RUN set -x && \
    wget https://boostorg.jfrog.io/artifactory/main/release/${boost_ver}/source/boost_$(echo ${boost_ver} | tr '.' '_').tar.gz && tar xvf boost* && cd boost*/ && \
    ./bootstrap.sh && ./b2 -j${make_procs} install && \
    cd .. && rm -rf * && \
    set +x

# nghttp2
RUN set -x && \
    wget https://github.com/nghttp2/nghttp2/releases/download/v${nghttp2_ver}/nghttp2-${nghttp2_ver}.tar.bz2 && tar xf nghttp2* && cd nghttp2*/ && \
    for patch in $(ls /patches/nghttp2/${nghttp2_ver}/*.patch 2>/dev/null); do patch -p1 < ${patch}; done && \
    ./configure --disable-shared --enable-python-bindings=no && make -j${make_procs} install && \
    cd .. && rm -rf * && \
    set +x

RUN if [ "${base_os}" = "alpine" ] ; then apk update && apk add libtool pkgconf autoconf automake && rm -rf /var/cache/apk/* ; elif [ "${base_os}" = "ubuntu" ] ; then apt-get update && apt-get install -y libtool pkg-config autoconf automake && apt-get clean ; fi

# nghttp2-asio
RUN set -x && \
    wget https://github.com/nghttp2/nghttp2-asio/archive/refs/heads/${nghttp2_asio_ver}.zip && unzip ${nghttp2_asio_ver}.zip && cd nghttp2-asio-${nghttp2_asio_ver} && \
    for patch in $(ls /patches/nghttp2-asio/${nghttp2_asio_ver}/*.patch 2>/dev/null); do patch -p1 < ${patch}; done && \
    autoreconf -i && automake && autoconf && ./configure --enable-shared=false && make -j${make_procs} install && \
    cd .. && rm -rf * && \
    set +x

# Build script
COPY deps/build.sh /var
RUN chmod a+x /var/build.sh

ENTRYPOINT ["/var/build.sh"]
CMD []
