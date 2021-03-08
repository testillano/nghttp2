#!/bin/sh
if [ -x ./`basename $0` ]
then
   exec ./`basename $0` $@
else
   build_type=${build_type:-Release}
   make_procs=${make_procs:-$(grep processor /proc/cpuinfo -c)}

   [ -f CMakeLists.txt ] && cmake -DCMAKE_BUILD_TYPE=${build_type} $@ .
   make -j${make_procs}
fi
exit $?

