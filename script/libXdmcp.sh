#!/bin/bash
set -e


BUILD_TARGET=libXdmcp-1.1.3


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
./configure $XORG_CONFIG --docdir=/usr/share/doc/libXdmcp-1.1.3 &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make install
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
