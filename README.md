# nghttp2_build docker image

This project hosts the stuff to build the `nghttp2_build` docker image useful to build projects & libraries based on @tatsuhiro-t nghttp2-asio library (https://github.com/nghttp2/nghttp2).

## Build the image

     > tag=$(git tag | grep -E '^[0-9.]+$' | tail -n -1)
     > img=testillano/nghttp2_build:${tag}
     > make_procs=$(grep processor /proc/cpuinfo -c)
     > docker build --rm --build-arg make_procs=${make_procs} -t ${img} .

## Or download from docker hub

This image is already available at docker hub for every repository tag, and also for master as `latest`:

     > docker pull testillano/nghttp2_build

## Usage

To run compilation over this image, just run with `docker`. The entry point will search for `CMakeLists.txt` file at project root (i.e. mounted on working directory `/code`) to generate `makefiles` and then, build the sources with `make`. There are two available environment variables: `BUILD_TYPE` (for `cmake`) and `MAKE_PROCS` (for `make`):

     > docker run --rm -it -u $(id -u):$(id -g) -e BUILD_TYPE=Debug -e MAKE_PROCS=4 -v ${PWD}:/code -w /code ${img}

You can check the builder script at `./deps/build.sh`.
