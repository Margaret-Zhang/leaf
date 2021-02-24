#!/bin/bash
set -e


BUILD_TARGET=llvm-10.0.1.src


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
tar -xf ${SRC_DIR}/clang-10.0.1.src.tar.xz -C tools          &&
tar -xf ${SRC_DIR}/compiler-rt-10.0.1.src.tar.xz -C projects &&
mv tools/clang-10.0.1.src tools/clang &&
mv projects/compiler-rt-10.0.1.src projects/compiler-rt
mkdir -v build &&
cd       build &&
CC=gcc CXX=g++                                  \
cmake -DCMAKE_INSTALL_PREFIX=/usr               \
      -DLLVM_ENABLE_FFI=ON                      \
      -DCMAKE_BUILD_TYPE=Release                \
      -DLLVM_BUILD_LLVM_DYLIB=ON                \
      -DLLVM_LINK_LLVM_DYLIB=ON                 \
      -DLLVM_ENABLE_RTTI=ON                     \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
      -DLLVM_BUILD_TESTS=ON                     \
      -Wno-dev -G Ninja ..                      &&
ninja -j6
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
cd build
ninja install
}


removeCache(){
#rm -rf ${BUILD_DIR}/${BUILD_TARGET}
echo ""
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
