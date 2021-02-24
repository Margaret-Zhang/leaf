#!/bin/bash
set -e


BUILD_TARGET=xorgproto-2020.1


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX -Dlegacy=true .. &&
ninja
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
cd build
ninja install &&

install -vdm 755 $XORG_PREFIX/share/doc/xorgproto-2020.1 &&
install -vm 644 ../[^m]*.txt ../PM_spec $XORG_PREFIX/share/doc/xorgproto-2020.1
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
