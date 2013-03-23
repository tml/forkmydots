#!/bin/bash

backup_dots() {
	#---------------------------------------
	# Remove and backup current files, then create symlink to new file.
	#
	mkdir -p ${backup_dir_time}

	date=`date --rfc-3339=date`
	time=`date --rfc-3339=seconds | \
		awk '{print $s}'`
	backup_dir="${FORKMYDOTS_DIR}/backups"
	#[ ! -h "${file}" ] && cp "${file}" "${backup_dir_time}/${file}"
}

link_dots() {
	specified_dir=${1:?}

	#---------------------------------------
	# Obtain list of files using names that are relatively correct for the current
	# user's home directory.
	#

	file_list=`find "${specified_dir}" -mindepth 1 -type f -printf "%P "`

	for file in ${file_list} ;do
		ln -sf "${PWD}/${specified_dir}/${file}" ".${file}"
	done 
}


