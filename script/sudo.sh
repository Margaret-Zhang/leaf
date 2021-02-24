#!/bin/bash
set -e


BUILD_TARGET=sudo-1.9.2


checkFile(){
if [ `grep -c -x ${BUILD_TARGET} ${INSTALLED_LOG}` != 0 ]; then
	REINSTALL_FLAG=1
fi

tar -xf ${SRC_DIR}/${BUILD_TARGET}.tar.* -C ${BUILD_DIR}
}


buildTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.9.2 \
            --with-passprompt="[sudo] password for %p: " &&
make
}


installTarget(){
cd ${BUILD_DIR}/${BUILD_TARGET}
make install &&
ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0
}


configSudo(){
cat > /etc/sudoers.d/sudo << "EOF"
Defaults secure_path="/usr/bin:/bin:/usr/sbin:/sbin"
%wheel ALL=(ALL) ALL
EOF
cat > /etc/pam.d/sudo << "EOF"
# Begin /etc/pam.d/sudo

# include the default auth settings
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session

# End /etc/pam.d/sudo
EOF
chmod 644 /etc/pam.d/sudo
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
configSudo
removeCache
recordFlag


exit
