#!/bin/bash
set -e


BUILD_TARGET=libxml2-py2


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/libxml2-2.9.10.tar.gz -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/libxml2-2.9.10
cd python             &&
python2 setup.py build
}


installTarget(){
cd ${BUILD_DIR}/libxml2-2.9.10
cd python
python2 setup.py install --optimize=1
}


removeCache(){
rm -rf ${BUILD_DIR}/libxml2-2.9.10
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
