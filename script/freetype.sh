#!/bin/bash
set -e


BUILD_TARGET=freetype-2.10.2


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
tar -xf ${SRC_DIR}/freetype-doc-2.10.2.tar.xz --strip-components=2 -C docs
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&
./configure --prefix=/usr --enable-freetype-config --disable-static &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make install
install -v -m755 -d /usr/share/doc/freetype-2.10.2 &&
cp -v -R docs/*     /usr/share/doc/freetype-2.10.2 &&
rm -v /usr/share/doc/freetype-2.10.2/freetype-config.1
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
