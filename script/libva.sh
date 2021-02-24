#!/bin/bash
set -e


BUILD_TARGET=libva-2.8.0


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
./configure $XORG_CONFIG &&
make
make install
tar -xvf ${SRC_DIR}/intel-vaapi-driver-2.4.1.tar.bz2 &&
cd intel-vaapi-driver-2.4.1
./configure $XORG_CONFIG &&
make
make install
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}

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
