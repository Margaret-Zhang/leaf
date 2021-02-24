#!/bin/bash
set -e


BUILD_TARGET=xorg-apps


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi
}


buildTarget(){
cd ${SRC_DIR}/${BUILD_TARGET}
for package in $(grep -v '^#' ../xorg-apps.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.?z*}
  tar -xf $package
  pushd $packagedir
     case $packagedir in
       luit-[0-9]* )
         sed -i -e "/D_XOPEN/s/5/6/" configure
       ;;
     esac

     ./configure $XORG_CONFIG
     make
     make install
  popd
  rm -rf $packagedir
done
rm -f $XORG_PREFIX/bin/xkeystone
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
