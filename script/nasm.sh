#!/bin/bash
set -e


BUILD_TARGET=nasm-2.15.03


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
tar -xf ${SRC_DIR}/nasm-2.15.03-xdoc.tar.xz --strip-components=1
./configure --prefix=/usr &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make install
install -m755 -d         /usr/share/doc/nasm-2.15.03/html  &&
cp -v doc/html/*.html    /usr/share/doc/nasm-2.15.03/html  &&
cp -v doc/*.{txt,ps,pdf} /usr/share/doc/nasm-2.15.03
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
