#!/bin/bash
set -e


BUILD_TARGET=xorg-libs


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi
}


buildTarget(){
cd ${SRC_DIR}/${BUILD_TARGET}
for package in $(grep -v '^#' ../xorg-libs.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.bz2}
  tar -xf $package
  pushd $packagedir
  docdir="--docdir=$XORG_PREFIX/share/doc/$packagedir"
  case $packagedir in
    libICE* )
      ./configure $XORG_CONFIG $docdir ICE_LIBS=-lpthread
    ;;

    libXfont2-[0-9]* )
      ./configure $XORG_CONFIG $docdir --disable-devel-docs
    ;;

    libXt-[0-9]* )
      ./configure $XORG_CONFIG $docdir \
                  --with-appdefaultdir=/etc/X11/app-defaults
    ;;

    * )
      ./configure $XORG_CONFIG $docdir
    ;;
	esac
	make
	make install
	popd
	rm -rf $packagedir
	/sbin/ldconfig
done
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
