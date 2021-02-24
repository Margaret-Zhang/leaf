#!/bin/bash
set -e


BUILD_TARGET=libnl-3.5.0


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make install
mkdir -vp /usr/share/doc/libnl-3.5.0 &&
tar -xf ${SRC_DIR}/libnl-doc-3.5.0.tar.gz --strip-components=1 --no-same-owner \
    -C  /usr/share/doc/libnl-3.5.0
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
