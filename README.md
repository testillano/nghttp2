# nghttp2_build docker image

This project hosts the stuff to build the `nghttp2_build` docker image useful to build projects & libraries base on @tatsuhiro-t nghttp2-asio library (https://github.com/nghttp2/nghttp2).

## Build the image

     > tag=$(git describe --long)
     > make_procs=$(grep processor /proc/cpuinfo -c)
     > docker build --rm --build-arg make_procs=${make_procs} -t testillano/nghttp2_build:${tag} .

## Download from docker hub

This image is already available at docker hub for every repository tag, and also for master as `latest`:

     > docker pull testillano/nghttp2_build

