#!/bin/bash
set -e


BUILD_TARGET=unzip60


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
patch -Np1 -i ${SRC_DIR}/unzip-6.0-consolidated_fixes-1.patch
make -f unix/Makefile generic
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make prefix=/usr MANDIR=/usr/share/man/man1 \
 -f unix/Makefile install
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
