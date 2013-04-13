#!/bin/bash

## Get origin of specified repository.
#
git_origin() {
	local working_tree_dir="${1:?}"
	pushd ${working_tree_dir} 2&>1 > /dev/null
	local origin=`git remote -v \
		| awk '/^origin/ {print $2}' \
		| uniq` 
	echo ${origin}
	popd 2&>1 > /dev/null
}
