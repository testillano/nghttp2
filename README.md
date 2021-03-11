# nghttp2_build docker image

This project hosts the stuff to build the `nghttp2_build` docker image useful to build projects & libraries based on @tatsuhiro-t nghttp2-asio library (https://github.com/nghttp2/nghttp2).

## Builder image

This image is already available at `docker hub` for every repository `tag`, and also for master as `latest`. Anyway, to create it, just type the following:

```bash
$ make_procs=$(grep processor /proc/cpuinfo -c)
$ docker build --rm --build-arg make_procs=${make_procs} -t testillano/nghttp2_build .
```

## Usage

To run compilation over this image, just run with `docker`. The `entrypoint` will search for `CMakeLists.txt` file at project root (i.e. mounted on working directory `/code`) to generate `makefiles` and then, builds the source code with `make`. There are two available environment variables: `BUILD_TYPE` (for `cmake`) and `MAKE_PROCS` (for `make`):

```bash
$ envs="-e MAKE_PROCS=$(grep processor /proc/cpuinfo -c) -e BUILD_TYPE=Release"
$ docker run --rm -it -u $(id -u):$(id -g) ${envs} -v ${PWD}:/code -w /code \
         testillano/nghttp2_build
```

You can check the builder script at `./deps/build.sh`, which is the docker image `entrypoint`.

