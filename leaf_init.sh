#!/bin/bash
set -e

mkdir -pv /var/leaf/{log,cache,script}
touch /var/leaf/log/available

cat > /etc/profile.d/leaf.sh << "EOF"
SRC_DIR='/mnt/pkg/blfs-10.0'
BUILD_DIR='/var/leaf/cache'
INSTALLED_LOG='/var/leaf/log/available'
REINSTALL_FLAG=0
MAKEFLAGS='-j9'
export SRC_DIR BUILD_DIR INSTALLED_LOG REINSTALL_FLAG MAKEFLAGS
EOF

echo "Run 'source /etc/profile' to update configurations."

