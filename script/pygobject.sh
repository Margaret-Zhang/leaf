#!/bin/bash
set -e


BUILD_TARGET=pygobject-3.36.1


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
mkdir python2                             &&
pushd python2                             &&
  meson --prefix=/usr -Dpython=python2 .. &&
  ninja                                   &&
popd
mkdir python3                             &&
pushd python3                             &&
  meson --prefix=/usr -Dpython=python3 .. &&
  ninja                                   &&
popd
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
ninja -C python2 install
ninja -C python3 install
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
