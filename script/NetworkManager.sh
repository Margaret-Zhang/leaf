#!/bin/bash
set -e


BUILD_TARGET=NetworkManager-1.26.0


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
sed -e 's/-qt4/-qt5/'              \
    -e 's/moc_location/host_bins/' \
    -i examples/C/qt/meson.build   &&
sed -e 's/Qt/&5/'                  \
    -i meson.build
sed '/initrd/d' -i src/meson.build
grep -rl '^#!.*python$' | xargs sed -i '1s/python/&3/'
mkdir build    &&
cd    build    &&
CXXFLAGS+="-O2 -fPIC"            \
meson --prefix /usr              \
      -Djson_validation=false    \
      -Dlibaudit=no              \
      -Dlibpsl=false             \
      -Dnmtui=true               \
      -Dovs=false                \
      -Dppp=false                \
      -Dselinux=false            \
      -Dqt=false                 \
      -Dudev_dir=/lib/udev       \
      -Dsession_tracking=systemd \
      -Dmodem_manager=false      \
      -Dsystemdsystemunitdir=/lib/systemd/system \
      .. &&
ninja
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
cd build
ninja install &&
mv -v /usr/share/doc/NetworkManager{,-1.26.0}
}


configNM(){
systemctl disable NetworkManager-wait-online
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
configNM
removeCache
recordFlag


exit
