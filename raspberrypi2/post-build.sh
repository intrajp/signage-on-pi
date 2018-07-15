#!/bin/sh

#### post script for signage on pi2
## 
## post-build.sh - post script 
## This file contains the contents of signage-on-pi.
##
## Copyright (C) 2018 Shintaro Fujiwara
##
## This library is free software; you can redistribute it and/or
## modify it under the terms of the GNU Lesser General Public
## License as published by the Free Software Foundation; either
## version 2.1 of the License, or (at your option) any later version.
##
## This library is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public
## License along with this library; if not, write to the Free Software
## Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
##  02110-1301 USA
####

#### original lines 
set -u
set -e
#### end original lines 

#### added by 'signage-on-pi' 

PRESENT_DIR="${PWD}/board/raspberrypi2"
SCRIPT_NAME="S99showpng"
DAEMON_NAME="show-png-oneshot-daemon"
STARTUP_SCRIPT="${PRESENT_DIR}/${SCRIPT_NAME}"
. "${PRESENT_DIR}/config.txt"
DIR_P="${TARGET_DIR}/usr/share/${MY_SIGNAGE_DIR}"
if [ -d "${DIR_P}" ]; then
    rm -rf ${DIR_P} 
fi
mkdir "${DIR_P}"
cp -af ../"${PICTURE_ONE_SHOT}" "${TARGET_DIR}/usr/share/${MY_SIGNAGE_DIR}"
cp -f "${STARTUP_SCRIPT}" "${TARGET_DIR}/etc/init.d" 
cat > "${TARGET_DIR}/usr/bin/${DAEMON_NAME}" << EOF
#!/bin/bash
/usr/bin/fbv /usr/share/"${MY_SIGNAGE_DIR}"/"${PICTURE_ONE_SHOT}"
EOF

#### end added by 'signage-on-pi' 

#### original lines 
# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi
#### end original lines 
