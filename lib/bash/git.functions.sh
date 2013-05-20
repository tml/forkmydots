#!/bin/bash

## Get origin of specified repository.
#
git_origin() {
	local working_tree_dir="${1:?}"
	pushd ${working_tree_dir} 2>&1 > /dev/null
	local origin=`git remote -v \
		| awk '/^origin/ {print $2}' \
		| uniq` 
	echo ${origin}
	popd 2>&1 > /dev/null
}

## Fill out GITORIGIN_* variables for use elsewhere.
#
#  Kind of assumes that the server is set up such that these components of the
#  git repo path are synchronized between the different protocols. It is
#  possible that the git://, ssh://, and http:// paths will differ from one
#  another on the same server, in that case this effort is kind of hopeless.
#  Let's just assume the sysadmin set it up correctly for now.
#
git_split_remote() {
	local working_tree_dir="${1:?}"
	local origin=`git_origin ${working_tree_dir}`

	echo "${origin}" | grep -E "^http://" \
		&& local host=${origin##http://} \
		&& GITORIGIN_USER="" \
		&& GITORIGIN_HOSTNAME=${host%%/*} \
		&& GITORIGIN_HOSTPATH=${host##*/} \
		&& return 0 

	echo "${origin}" | grep -E "^[[:alnum:]]*\@.*" \
		&&  local host=${origin##*@} \
		&& GITORIGIN_USER=${origin%%@*} \
		&& GITORIGIN_HOSTNAME=${host%%:*} \
		&& GITORIGIN_HOSTPATH=${host##*:} \
		&& return 0 

	echo "${origin}" | grep -E "^git://" \
		&& local host=${origin##git://} \
		&& GITORIGIN_USER="" \
		&& GITORIGIN_HOSTNAME=${host%%/*} \
		&& GITORIGIN_HOSTPATH=${host##*/} \
		&& return 0 

	return 1
}

## Echo http:// origin of specified repository.
#
git_http_origin() {
	local working_tree_dir="${1:?}"
	git_split_remote ${working_tree_dir} 2>&1 > /dev/null
	echo -n "http://${GITORIGIN_HOSTNAME}/${GITORIGIN_HOSTPATH}"
}

## Echo ssh:// origin of specified repository.
#
git_ssh_origin() {
	local working_tree_dir="${1:?}"
	git_split_remote ${working_tree_dir} 2>&1 > /dev/null
	echo -n "${GITORIGIN_USER}@${GITORIGIN_HOSTNAME}:${GITORIGIN_HOSTPATH}"
}

## Echo git:// origin of specified repository.
#
git_git_origin() {
	local working_tree_dir="${1:?}"
	git_split_remote ${working_tree_dir} 2>&1 > /dev/null
	echo -n "git://${GITORIGIN_HOSTNAME}/${GITORIGIN_HOSTPATH}"
}
