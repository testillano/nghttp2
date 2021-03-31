#!/bin/bash

#############
# VARIABLES #
#############
FORCE_DEFAULTS=
image_tag__dflt=latest
make_procs__dflt=$(grep processor /proc/cpuinfo -c)
base_tag__dflt=latest # alpine
nghttp2_ver__dflt=1.42.0 # tatsuhiro
boost_ver__dflt=1.67.0 # boost

#############
# FUNCTIONS #
#############
# $1: variable by reference; $2: default value
_read() {
  local -n varname=$1
  local default=$2

  local s_default="<null>"
  [ -n "${default}" ] && s_default="${default}"
  echo "Input '$1' value [${s_default}]:"

  [ -n "${FORCE_DEFAULTS}" ] && varname=${default}

  if [ -n "${varname}" ]
  then
    echo "${varname}"
  else
    read varname
    [ -z "${varname}" ] && varname=${default}
  fi
}

#############
# EXECUTION #
#############
cd $(dirname $0)
[ "$1" = "-f" ] && FORCE_DEFAULTS=yes
echo
echo "=== Build nghttp2 image ==="
echo
echo "For headless mode, prepend/export asked variables:"
echo " $(grep "^_read " build.sh | awk '{ print $2 }' | tr '\n' ' ')"
echo
echo "Provide '-f' to force defaults."
echo
_read image_tag ${image_tag__dflt}
_read make_procs ${make_procs__dflt}
_read base_tag ${base_tag__dflt}
_read nghttp2_ver ${nghttp2_ver__dflt}
_read boost_ver ${boost_ver__dflt}

bargs="--build-arg make_procs=${make_procs}"
bargs+=" --build-arg base_tag=${base_tag}"
bargs+=" --build-arg nghttp2_ver=${nghttp2_ver}"
bargs+=" --build-arg boost_ver=${boost_ver}"

set -x
docker build --rm ${bargs} -t testillano/nghttp2:${image_tag} .
set +x

