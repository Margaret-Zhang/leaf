#!/bin/bash
set -e


BUILD_TARGET=lynx2.8.9rel.1


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
./configure --prefix=/usr          \
            --sysconfdir=/etc/lynx \
            --datadir=/usr/share/doc/lynx-2.8.9rel.1 \
            --with-zlib            \
            --with-bzlib           \
            --with-ssl             \
            --with-screen=ncursesw \
            --enable-locale-charset &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make install-full &&
chgrp -v -R root /usr/share/doc/lynx-2.8.9rel.1/lynx_doc
}


configLynx(){
sed -e '/#LOCALE/     a LOCALE_CHARSET:TRUE'     \
    -i /etc/lynx/lynx.cfg
sed -e '/#DEFAULT_ED/ a DEFAULT_EDITOR:vim'      \
    -i /etc/lynx/lynx.cfg
sed -e '/#PERSIST/    a PERSISTENT_COOKIES:TRUE' \
    -i /etc/lynx/lynx.cfg
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
configLynx
removeCache
recordFlag


exit
