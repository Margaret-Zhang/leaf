#!/bin/bash
set -e


BUILD_TARGET=icu-67.1


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/icu4c-67_1-src.tgz -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/icu
cd source                                    &&
./configure --prefix=/usr                    &&
make
}


installTarget(){
cd ${BUILD_DIR}/icu
cd source
make install
}


removeCache(){
rm -rf ${BUILD_DIR}/icu
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
