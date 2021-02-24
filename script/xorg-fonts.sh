#!/bin/bash
set -e


BUILD_TARGET=xorg-fonts


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi
}


buildTarget(){
cd ${SRC_DIR}/${BUILD_TARGET}
for package in $(grep -v '^#' ../xorg-fonts.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.bz2}
  tar -xf $package
  pushd $packagedir
    ./configure $XORG_CONFIG
    make
    make install
  popd
  rm -rf $packagedir
done
install -v -d -m755 /usr/share/fonts                               &&
ln -svfn $XORG_PREFIX/share/fonts/X11/OTF /usr/share/fonts/X11-OTF &&
ln -svfn $XORG_PREFIX/share/fonts/X11/TTF /usr/share/fonts/X11-TTF
}


installTarget(){
#cd ${BUILD_DIR}/${BUILD_TARGET}
echo ""
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
