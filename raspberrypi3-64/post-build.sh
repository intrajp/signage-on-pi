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

PINKRABBIT_CONFIG="pinkrabbit.cfg"
PINKRABBIT_PICTURE_DIR="../PINKRABBIT_PICTURES"
ORIGINAL_PICTURE_DIR="../PICTURES_ORIGINAL"
PRESENT_DIR="${PWD}/board/raspberrypi3-64"
SCRIPT_NAME="S99showpng"
SCRIPT_NAME2="S99Z"
DAEMON_NAME="show-png-oneshot-daemon"
STARTUP_SCRIPT="${PRESENT_DIR}/${SCRIPT_NAME}"
STARTUP_SCRIPT2="${PRESENT_DIR}/${SCRIPT_NAME2}"
. "${PRESENT_DIR}/${PINKRABBIT_CONFIG}"
DIR_P="${TARGET_DIR}/usr/share/${MY_SIGNAGE_DIR}"
if [ -d "${DIR_P}" ]; then
    rm -rf ${DIR_P} 
fi
mkdir "${DIR_P}"
if [ -d "${PINKRABBIT_PICTURE_DIR}" ]; then
    rm -rf "${PINKRABBIT_PICTURE_DIR}" 
fi
mkdir "${PINKRABBIT_PICTURE_DIR}"

cp -af "${PRESENT_DIR}/${PINKRABBIT_CONFIG}" "${TARGET_DIR}/etc" 

string=$(find "${ORIGINAL_PICTURE_DIR}" | grep -e "${PICTURE_ONE_SHOT}-[0-9]*.png" | sort) 
string2=$(echo ${string} | tr " " "," )
# for debug
#echo "${string2}"
IFS="," read -r -a arr <<< "${string2}"
# for debug
#echo "arr:${#arr[@]}"
for element in "${arr[@]}"
do
    pic_name=$(echo "${element}" | awk -F"/" '{ print $NF }')
    convert "${element}" -resize ${SIZE} "${PINKRABBIT_PICTURE_DIR}/${pic_name}" 
    re=$?
    if [ $re -ne 0 ]; then
        echo "Ooops! ImageMagick failed!"
        exit 1
    fi
done
cp -af $(find ${PINKRABBIT_PICTURE_DIR} | grep -e "${PICTURE_ONE_SHOT}-[0-9]*.png" | sort) "${TARGET_DIR}/usr/share/${MY_SIGNAGE_DIR}" 
cp -f "${STARTUP_SCRIPT}" "${TARGET_DIR}/etc/init.d" 
cp -f "${STARTUP_SCRIPT2}" "${TARGET_DIR}/etc/init.d" 
cat > "${TARGET_DIR}/usr/bin/${DAEMON_NAME}" << EOF
#!/bin/bash
. /etc/${PINKRABBIT_CONFIG}
EOF
cat >> "${TARGET_DIR}/usr/bin/${DAEMON_NAME}" << "EOF"
string=$(find /usr/share/${MY_SIGNAGE_DIR} -type f -name "${PICTURE_ONE_SHOT}-[0-9]*.png" | sort)
string2=$(echo ${string} | tr " " "," )
IFS="," read -r -a arr <<< "${string2}"
if [ "${LOOP}" -eq 1 ]; then
    while :
    do
        /usr/bin/fbv --delay 100 --noclear --noinfo "${arr[@]}"
EOF
cat >> "${TARGET_DIR}/usr/bin/${DAEMON_NAME}" << EOF
        sleep ${SLEEP_SEC}
EOF
cat >> "${TARGET_DIR}/usr/bin/${DAEMON_NAME}" << "EOF"
    done
else
    /usr/bin/fbv --delay 100 --noclear --noinfo "${arr[@]}"
EOF
cat >> "${TARGET_DIR}/usr/bin/${DAEMON_NAME}" << EOF
    sleep ${SLEEP_SEC}
fi
EOF
chmod +x "${TARGET_DIR}/usr/bin/${DAEMON_NAME}"
chmod -x "${TARGET_DIR}/etc/init.d/S99showpng"
#### end added by 'signage-on-pi' 

#### original lines 
# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi
#### end original lines 
