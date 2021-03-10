#!/bin/sh
# Prepend variables MAKE_PROCS ('make' parallel jobs, maximum available by default) and BUILD_TYPE ([Release]|Debug).
if [ -x ./`basename $0` ]
then
   exec ./`basename $0` $@
else
   BUILD_TYPE=${BUILD_TYPE:-Release}
   MAKE_PROCS=${MAKE_PROCS:-$(grep processor /proc/cpuinfo -c)}

   [ -f CMakeLists.txt ] && cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} $@ .
   make -j${MAKE_PROCS}
fi
exit $?

