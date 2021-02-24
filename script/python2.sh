#!/bin/bash
set -e


BUILD_TARGET=Python-2.7.18


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes \
            --enable-unicode=ucs4 &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make install &&
chmod -v 755 /usr/lib/libpython2.7.so.1.0
install -v -dm755 /usr/share/doc/python-2.7.18 &&
tar --strip-components=1                     \
    --no-same-owner                          \
    --directory /usr/share/doc/python-2.7.18 \
    -xvf ${SRC_DIR}/python-2.7.18-docs-html.tar.bz2 &&
find /usr/share/doc/python-2.7.18 -type d -exec chmod 0755 {} \; &&
find /usr/share/doc/python-2.7.18 -type f -exec chmod 0644 {} \;
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
