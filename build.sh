#!/bin/bash

#############
# VARIABLES #
#############
make_procs__dflt=$(grep processor /proc/cpuinfo -c)
base_ver__dflt=latest # alpine

#############
# EXECUTION #
#############
cd $(dirname $0)
echo
echo "---------------------"
echo "Build 'builder image'"
echo "---------------------"
echo
echo "Input 'make_procs' [${make_procs__dflt}]:"
read make_procs
[ -z "${make_procs}" ] && make_procs=${make_procs__dflt}

echo "Input alpine 'base_ver' [${base_ver__dflt}]:"
read base_ver
[ -z "${base_ver}" ] && base_ver=${base_ver__dflt}

bargs="--build-arg make_procs=${make_procs} --build-arg base_ver=${base_ver}"
docker build --rm ${bargs} -t testillano/nghttp2 .

