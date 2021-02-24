#!/bin/bash
set -e


BUILD_TARGET=Linux-PAM-1.4.0


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
tar -xf ${SRC_DIR}/Linux-PAM-1.4.0-docs.tar.xz --strip-components=1
sed -e 's/dummy elinks/dummy lynx/'                                     \
    -e 's/-no-numbering -no-references/-force-html -nonumbers -stdin/' \
    -i configure
./configure --prefix=/usr                    \
            --sysconfdir=/etc                \
            --libdir=/usr/lib                \
            --enable-securedir=/lib/security \
            --docdir=/usr/share/doc/Linux-PAM-1.4.0 &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
if [ $REINSTALL_FLAG -eq 0 ]; then
install -v -m755 -d /etc/pam.d &&
cat > /etc/pam.d/other << "EOF"
auth     required       pam_deny.so
account  required       pam_deny.so
password required       pam_deny.so
session  required       pam_deny.so
EOF
rm -fv /etc/pam.d/other
fi

make install &&
chmod -v 4755 /sbin/unix_chkpwd &&

for file in pam pam_misc pamc
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
done
}


configLinuxPAM(){
if [ $REINSTALL_FLAG -eq 0 ]; then
install -vdm755 /etc/pam.d &&
cat > /etc/pam.d/system-account << "EOF" &&
# Begin /etc/pam.d/system-account

account   required    pam_unix.so

# End /etc/pam.d/system-account
EOF

cat > /etc/pam.d/system-auth << "EOF" &&
# Begin /etc/pam.d/system-auth

auth      required    pam_unix.so

# End /etc/pam.d/system-auth
EOF

cat > /etc/pam.d/system-session << "EOF"
# Begin /etc/pam.d/system-session

session   required    pam_unix.so

# End /etc/pam.d/system-session
EOF
cat > /etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password

# use sha512 hash for encryption, use shadow, and try to use any previously
# defined authentication token (chosen password) set by any prior module
password  required    pam_unix.so       sha512 shadow try_first_pass

# End /etc/pam.d/system-password
EOF

cat > /etc/pam.d/other << "EOF"
# Begin /etc/pam.d/other

auth        required        pam_warn.so
auth        required        pam_deny.so
account     required        pam_warn.so
account     required        pam_deny.so
password    required        pam_warn.so
password    required        pam_deny.so
session     required        pam_warn.so
session     required        pam_deny.so

# End /etc/pam.d/other
EOF
fi
}


removeCache(){
rm -rf ${BUILD_DIR}/${BUILD_TARGET}
}


recordFlag(){
if [ ${REINSTALL_FLAG} -eq 0 ]; then
	echo "${BUILD_TARGET}" >> ${INSTALLED_LOG}
fi
}


printImportant(){
echo "Now reinstall the Shadow-4.8.1 and Systemd-246 packages."
}


checkFile
buildTarget
installTarget
configLinuxPAM
removeCache
recordFlag
printImportant


exit
