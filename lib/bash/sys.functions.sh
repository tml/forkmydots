#!/bin/bash

##
# Set variables to provide information about the running system.
system_info() {
	OS=`uname -s`
	KRELEASE=`uname -r`
}

stat_sh() {
	local file=${1:?}
	local STATARGS=""

	if [ "${KERNEL}" = "NetBSD" ] ;then
		STATARGS="-x"
	fi

	stat ${STATARGS} ${file}
}

get_device() {
	stat_sh ${1:?} | awk '/^Device:/ { print $2 }'
}
