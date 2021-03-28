# nghttp2 docker image

This project hosts the stuff to build the `nghttp2` docker image useful to build projects & libraries based on @tatsuhiro-t nghttp2-asio library (https://github.com/nghttp2/nghttp2).

## Builder image

This image is already available at `docker hub` for every repository `tag`, and also for master as `latest`:

```bash
$ docker pull testillano/nghttp2:<tag>
```

Anyway, you could type something like this to build the image:

```bash
ARG nghttp2_ver=1.42.0
ARG boost_ver=1.67.0

$ bargs="--build-arg make_procs=$(grep processor /proc/cpuinfo -c)"
$ bargs+=" --build-arg base_tag=<x.y.z>" # put the desired alpine tag here
$ bargs+=" --build-arg nghttp2_ver=<x.y.z>" # put the desired nghttp2 version here
$ bargs+=" --build-arg boost_ver=<x.y.z>" # put the desired boost version here
$ docker build --rm ${bargs} -t testillano/nghttp2:<tag> .
```

Or better use the automation script `./build.sh` located at project root.

## Usage

To run compilation over this image, just run with `docker`. The `entrypoint` will fallback from `cmake` (looking for `CMakeLists.txt` file at project root, i.e. mounted on working directory `/code` to generate makefiles) to `make`, in order to build your source code. There are two available environment variables used by the builder script of this image: `BUILD_TYPE` (for `cmake`) and `MAKE_PROCS` (for `make`):

```bash
$ envs="-e MAKE_PROCS=$(grep processor /proc/cpuinfo -c) -e BUILD_TYPE=Release"
$ docker run --rm -it -u $(id -u):$(id -g) ${envs} -v ${PWD}:/code -w /code \
         testillano/nghttp2:<tag>
```

You can check the builder script at `./deps/build.sh`, which is the docker image `entrypoint` script.

