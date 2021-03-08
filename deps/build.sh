#!/bin/sh
if [ -x ./`basename $0` ]
then
   exec ./`basename $0` $@
else
   variant=${VARIANT:-Release}
   make_procs=${MAKE_PROCS:-$(grep processor /proc/cpuinfo -c)}

   [ -f CMakeLists.txt ] && cmake -DCMAKE_BUILD_TYPE=${variant} $@ .
   make -j${make_procs}
fi
exit $?

