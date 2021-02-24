#!/bin/bash
set -e


BUILD_TARGET=mesa-20.1.5


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
patch -Np1 -i ${SRC_DIR}/mesa-20.1.5-add_xdemos-1.patch
GALLIUM_DRV="i915,iris,nouveau,r600,radeonsi,svga,swrast,virgl"
DRI_DRIVERS="i965,nouveau"
mkdir build &&
cd    build &&
meson --prefix=$XORG_PREFIX          \
      -Dbuildtype=release            \
      -Ddri-drivers=$DRI_DRIVERS     \
      -Dgallium-drivers=$GALLIUM_DRV \
      -Dgallium-nine=false           \
      -Dglx=dri                      \
      -Dosmesa=gallium               \
      -Dvalgrind=false               \
      -Dlibunwind=false              \
      ..                             &&
unset GALLIUM_DRV DRI_DRIVERS &&
ninja
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
cd build
ninja install
install -v -dm755 /usr/share/doc/mesa-20.1.5 &&
cp -rfv ../docs/* /usr/share/doc/mesa-20.1.5
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
