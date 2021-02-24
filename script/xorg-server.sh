#!/bin/bash
set -e


BUILD_TARGET=xorg-server-1.20.8


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
sed -i 's/malloc(pScreen/calloc(1, pScreen/' dix/pixmap.c
./configure $XORG_CONFIG            \
            --enable-glamor         \
            --enable-suid-wrapper   \
            --with-xkb-output=/var/lib/xkb &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make install &&
mkdir -pv /etc/X11/xorg.conf.d
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
