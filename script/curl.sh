#!/bin/bash
set -e


BUILD_TARGET=curl-7.71.1


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
patch -Np1 -i ${SRC_DIR}/curl-7.71.1-security_fixes-1.patch
./configure --prefix=/usr                           \
            --disable-static                        \
            --enable-threaded-resolver              \
            --with-ca-path=/etc/ssl/certs &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make install &&
rm -rf docs/examples/.deps &&
find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&
install -v -d -m755 /usr/share/doc/curl-7.71.1 &&
cp -v -R docs/*     /usr/share/doc/curl-7.71.1
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
