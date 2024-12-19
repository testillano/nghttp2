#!/bin/bash
# Prepend variable DBUILD_XTRA_OPTS, for example: --no-cache

#############
# VARIABLES #
#############
image_tag__dflt=latest
make_procs__dflt=$(grep processor /proc/cpuinfo -c)
base_os__dflt=ubuntu
base_tag__dflt=latest
nghttp2_ver__dflt=1.64.0 # tatsuhiro
nghttp2_asio_ver__dflt=main
boost_ver__dflt=1.84.0 # boost
registry=ghcr.io/testillano

#############
# FUNCTIONS #
#############
# $1: variable by reference
_read() {
  local -n varname=$1

  local default=$(eval echo \$$1__dflt)
  local s_default="<null>"
  [ -n "${default}" ] && s_default="${default}"
  echo "Input '$1' value [${s_default}]:"

  if [ -n "${varname}" ]
  then
    echo "${varname}"
  else
    read -r varname
    [ -z "${varname}" ] && varname=${default}
  fi
}

#############
# EXECUTION #
#############
# shellcheck disable=SC2164
cd "$(dirname "$0")"
echo
echo "=== Build nghttp2 image ==="
echo
echo "For headless mode, prepend/export asked variables:"
echo " $(grep "^_read " build.sh | awk '{ print $2 }' | tr '\n' ' ')"
echo
_read image_tag
_read make_procs
_read base_os
_read base_tag
_read nghttp2_ver
_read nghttp2_asio_ver
_read boost_ver

bargs="--build-arg make_procs=${make_procs}"
bargs+=" --build-arg base_os=${base_os}"
bargs+=" --build-arg base_tag=${base_tag}"
bargs+=" --build-arg nghttp2_ver=${nghttp2_ver}"
bargs+=" --build-arg nghttp2_asio_ver=${nghttp2_asio_ver}"
bargs+=" --build-arg boost_ver=${boost_ver}"

set -x
# shellcheck disable=SC2086
docker build --rm ${DBUILD_XTRA_OPTS} ${bargs} -t ${registry}/nghttp2:"${image_tag}" . || exit 1
set +x

