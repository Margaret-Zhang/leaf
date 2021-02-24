#!/bin/bash
set -e


BUILD_TARGET=libvdpau-va-gl-0.4.0


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
mkdir build &&
cd    build &&
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$XORG_PREFIX .. &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
cd build
make install
echo "export VDPAU_DRIVER=va_gl" >> /etc/profile.d/xorg.sh
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
