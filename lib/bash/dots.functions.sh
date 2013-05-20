#!/bin/bash

. ${LIB_DIR}/git.functions.sh

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

push_dots() {
	local dot_dir="${1:?}"
	local host="${2:?}"

	local remote_reldir="${forkmydots_dir##*/}"
	local new_remote="${host}:${remote_reldir}"

	local origin=`git_http_origin ${forkmydots_dir}`
	local sshcmd=''
	read -r -d '' sshcmd <<-HEREDOC
git clone --recursive forkmydots.bundle ${remote_reldir}
./${remote_reldir}/bin/forkmydots.sh -d \${HOME}/${remote_reldir}/homes/default backup  
./${remote_reldir}/bin/forkmydots.sh -d \${HOME}/${remote_reldir}/homes/default install
pushd ${remote_reldir}
git remote set-url origin "${origin}"
git fetch origin
git checkout -b master origin/master
popd
HEREDOC
	pushd ${forkmydots_dir}
	git bundle create forkmydots.bundle HEAD
	scp -r forkmydots.bundle "${host}:"
	ssh ${host} "${sshcmd}"
	git remote rm "${host%*@}-${host#@*}"
	git remote add "${host%*@}-${host#@*}" ${new_remote}
	rm -f forkmydots.bundle
	popd
}

remote_clone_dots() {
	local dot_dir="${1:?}"
	local host="${2:?}"

	local remote_reldir="${forkmydots_dir##*/}"
	local new_remote="${host}:${remote_reldir}"

	local origin=`git_http_origin ${forkmydots_dir}`
	local sshcmd=''
	read -r -d '' sshcmd <<-HEREDOC
git clone --recursive "${origin}" ${remote_reldir}
./${remote_reldir}/bin/forkmydots.sh -d \${HOME}/${remote_reldir}/homes/default backup  
./${remote_reldir}/bin/forkmydots.sh -d \${HOME}/${remote_reldir}/homes/default install
HEREDOC

	pushd ${forkmydots_dir}
	ssh ${host} "${sshcmd}"
	git remote rm "${host%*@}-${host#@*}"
	git remote add "${host%*@}-${host#@*}" ${new_remote}
	popd
}
