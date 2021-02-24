#!/bin/bash
set -e


BUILD_TARGET=git-2.28.0


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
./configure --prefix=/usr \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3 &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make perllibdir=/usr/lib/perl5/5.32/site_perl install
tar -xf ${SRC_DIR}/git-manpages-2.28.0.tar.xz \
    -C /usr/share/man --no-same-owner --no-overwrite-dir
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
