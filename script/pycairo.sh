#!/bin/bash
set -e


BUILD_TARGET=pycairo-1.19.1


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
python3 setup.py build
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
python3 setup.py install --optimize=1   &&
python3 setup.py install_pycairo_header &&
python3 setup.py install_pkgconfig
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
