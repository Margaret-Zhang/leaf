#!/bin/bash
set -e


BUILD_TARGET=graphviz-2.44.1


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac &&
autoreconf                            &&
./configure --prefix=/usr PS2PDF=true &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make install
ln -v -s /usr/share/graphviz/doc /usr/share/doc/graphviz-2.44.1
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
