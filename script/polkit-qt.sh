#!/bin/bash
set -e


BUILD_TARGET=polkit-qt-1-0.113.0


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
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -Wno-dev .. &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
cd build
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
