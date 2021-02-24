#!/bin/bash
set -e


BUILD_TARGET=lmdb-0.9.24


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/lmdb-LMDB_0.9.24.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/lmdb-LMDB_0.9.24
cd libraries/liblmdb &&
make                 &&
sed -i 's| liblmdb.a||' Makefile
}


installTarget(){
cd ${BUILD_DIR}/lmdb-LMDB_0.9.24
cd libraries/liblmdb
make prefix=/usr install
}


removeCache(){
rm -rf ${BUILD_DIR}/lmdb-LMDB_0.9.24
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
