#!/bin/bash

set_var() {
	local var_name=${1:?}
	local var_value=${2:?}
	local filename=${3:?}

	sed -i -e \
		"s|^${var_name}=.*|${var_name}=\"${var_value}\"|" \
		"${filename}"
}

get_dot_files() {
	local find_path="${1:?}"
	find_path=${find_path%/}

	find ${find_path} \
		-mindepth 1 \
		-type f \
		! -name "*.swp" \
		! -path "${find_path}/backups*" \
		-printf "%P "
}

backup_dots() {
	local file_list=`get_dot_files ${1:?}`
	local date=`date +%Y-%m-%d`
	local time=`date +%H%M%S`
	local backup_dir="${DOTS_DIR}/backups/${date}_${time}/"
	local dot_file=""
	local file_dir=""

	set -x
	for file in ${file_list} ;do
		dot_file=".${file}"
		file_dir="${file%/*}"
		if [ ! -h "${dot_file}" ] ;then
			mkdir -p ${backup_dir} 
			[ ! "${file}" = "${file_dir}" ] \
				&& mkdir -p ${backup_dir}/${file_dir}
			cp "${dot_file}" "${backup_dir}/${file}" 
		fi
	done
	set +x
}


link_dots() {
	local dot_dir="${1:?}"
	local file_list=`get_dot_files ${dot_dir:?}`
	local dot_dir_dev=`get_device ${dot_dir}`
	local home_dir_dev=`get_device ./`
	local LNARGS="-Pf"
	local file_dir=""

	if [ ! "${dot_dir_dev}" = "${home_dir_dev}" ] \
		|| [ ! "${USE_SYMLINKS}x" = "x" ] ;then
		LNARGS="-sf"
	fi

	for file in ${file_list} ;do
		set_var "FORKMYDOTS_DIR" "${forkmydots_dir}" "${dot_dir}/${file}"
		file_dir="${file%/*}"
		[ ! "${file}" = "${file_dir}" ] \
			&& mkdir -p ".${file_dir}"
		ln ${LNARGS} "${dot_dir}/${file}" ".${file}"
	done 
}


