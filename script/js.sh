#!/bin/bash
set -e


BUILD_TARGET=js-68.11.0


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/firefox-68.11.0esr.source.tar.xz -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/firefox-68.11.0
export SHELL=/bin/sh
sed '21,+4d' -i js/moz.configure &&
mkdir obj &&
cd    obj &&
CC=gcc CXX=g++ LLVM_OBJDUMP=/bin/false       \
../js/src/configure --prefix=/usr            \
                    --with-intl-api          \
                    --with-system-zlib       \
                    --with-system-icu        \
                    --disable-jemalloc       \
                    --disable-debug-symbols  \
                    --enable-readline        \
                    --enable-unaligned-private-values &&
make
}


installTarget(){
cd ${BUILD_DIR}/firefox-68.11.0
cd obj
make install &&
rm -v /usr/lib/libjs_static.ajs
}


removeCache(){
rm -rf ${BUILD_DIR}/firefox-68.11.0
}


recordFlag(){
if [ ${REINSTALL_FLAG} -eq 0 ]; then
	echo "${BUILD_TARGET}" >> ${INSTALLED_LOG}
fi
}


checkFile
buildTarget
installTarget
removeCache
recordFlag


exit
