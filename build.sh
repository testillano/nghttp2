#!/bin/bash

#############
# VARIABLES #
#############
make_procs__dflt=$(grep processor /proc/cpuinfo -c)
base_tag__dflt=latest # alpine
nghttp2_ver__dflt=1.42.0 # tatsuhiro
boost_ver__dflt=1.67.0 # boost

#############
# FUNCTIONS #
#############
# $1: question; $2: variable by reference; $3: default value
_read() {
  local question=$1
  local -n varname=$2
  local default=$3

  echo "${question} [${default}]:"
  read varname
  [ -z "${varname}" ] && varname=${default}
}

#############
# EXECUTION #
#############
cd $(dirname $0)
echo
echo "-------------------"
echo "Build nghttp2 image"
echo "-------------------"
echo
_read "Input 'make_procs'" make_procs ${make_procs__dflt}
_read "Input alpine 'base_tag'" base_tag ${base_tag__dflt}
_read "Input tatsuhiro 'nghttp2_ver'" nghttp2_ver ${nghttp2_ver__dflt}
_read "Input boost 'boost_ver'" boost_ver ${boost_ver__dflt}

bargs="--build-arg make_procs=${make_procs}"
bargs+=" --build-arg base_tag=${base_tag}"
bargs+=" --build-arg nghttp2_ver=${nghttp2_ver}"
bargs+=" --build-arg boost_ver=${boost_ver}"

set -x
docker build --rm ${bargs} -t testillano/nghttp2 .
set +x

