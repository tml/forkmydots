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
	find "${1:?}" \
		-mindepth 1 \
		-type f \
		! -name "*.swp" \
		-printf "%P "
}

backup_dots() {
	local backup_dir="${forkmydots_dir}/backups"
	local date=`date --rfc-3339=date`
	local time=`date --rfc-3339=seconds | \
		awk '{print $2}'`
	backup_dir="${backup_dir}/${date}/${time}/"
	mkdir -p ${backup_dir}

	local file_list=`get_dot_files ${1:?}`
	for file in ${file_list} ;do
		local dot_file=".${file}"
		[ ! -h "${dot_file}" ] && cp "${dot_file}" "${backup_dir}/${file}"
	done
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


