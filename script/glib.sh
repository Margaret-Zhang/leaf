#!/bin/bash
set -e


BUILD_TARGET=glib-2.64.4


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
patch -Np1 -i ${SRC_DIR}/glib-2.64.4-skip_warnings-1.patch
mkdir build &&
cd    build &&
meson --prefix=/usr      \
      -Dman=true         \
      -Dselinux=disabled \
      ..                 &&
ninja
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
cd build
ninja install &&
mkdir -p /usr/share/doc/glib-2.64.4 &&
cp -r ../docs/reference/{NEWS,gio,glib,gobject} /usr/share/doc/glib-2.64.4
}


removeCache(){
rm -rf ${BUILD_DIR}/${BUILD_TARGET}
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
