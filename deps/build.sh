#!/bin/sh
# Prepend variables MAKE_PROCS ('make' parallel jobs, maximum available by default) and BUILD_TYPE ([Release]|Debug).
# Command-line arguments:
# * Having cmake system:
#   $1: extra cmake arguments; $2-$@: extra make arguments
# * Not having cmake system:
#   $@: extra make arguments

if [ -x ./`basename $0` ]
then
   exec ./`basename $0` $@
else
   BUILD_TYPE=${BUILD_TYPE:-Release}
   MAKE_PROCS=${MAKE_PROCS:-$(grep processor /proc/cpuinfo -c)}

   [ -f CMakeLists.txt ] && cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} $1 . && shift
   make -j${MAKE_PROCS} $@
fi
exit $?

