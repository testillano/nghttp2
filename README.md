# nghttp2 docker image

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Documentation](https://codedocs.xyz/testillano/coffee.svg)](https://codedocs.xyz/testillano/nghttp2/index.html)
[![Ask Me Anything !](https://img.shields.io/badge/Ask%20me-anything-1abc9c.svg)](https://github.com/testillano)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/testillano/nghttp2/graphs/commit-activity)
[![Build docker image and publish to Docker Hub](https://github.com/testillano/nghttp2/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/testillano/nghttp2/actions/workflows/docker-publish.yml)

This project hosts the stuff to build the `nghttp2` docker image useful to build projects & libraries based on @tatsuhiro-t nghttp2-asio library (https://github.com/nghttp2/nghttp2).

## Project image

This image is already available at `docker hub` for every repository `tag`, and also for master as `latest`:

```bash
$ docker pull testillano/nghttp2:<tag>
```

You could also build it using the script `./build.sh` located at project root.

## Usage

To run compilation over this image, just run with `docker`. The `entrypoint` (check it at `./deps/build.sh`) will fall back from `cmake` (looking for `CMakeLists.txt` file at project root, i.e. mounted on working directory `/code` to generate makefiles) to `make`, in order to build your source code. There are two available environment variables used by the builder script of this image: `BUILD_TYPE` (for `cmake`) and `MAKE_PROCS` (for `make`):

```bash
$ envs="-e MAKE_PROCS=$(grep processor /proc/cpuinfo -c) -e BUILD_TYPE=Release"
$ docker run --rm -it -u $(id -u):$(id -g) ${envs} -v ${PWD}:/code -w /code \
         testillano/nghttp2:<tag>
```

