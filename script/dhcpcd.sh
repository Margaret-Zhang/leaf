#!/bin/bash
set -e


BUILD_TARGET=dhcpcd-9.1.4


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
if [ $REINSTALL_FLAG -eq 0 ]; then
install  -v -m700 -d /var/lib/dhcpcd &&
groupadd -g 52 dhcpcd        &&
useradd  -c 'dhcpcd PrivSep' \
         -d /var/lib/dhcpcd  \
         -g dhcpcd           \
         -s /bin/false     \
         -u 52 dhcpcd &&
chown    -v dhcpcd:dhcpcd /var/lib/dhcpcd 
fi

./configure --libexecdir=/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd  \
            --privsepuser=dhcpcd     &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make install
cd ${BUILD_DIR}/blfs-systemd-units-20200828
make install-dhcpcd
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
