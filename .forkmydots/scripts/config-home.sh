#/bin/bash

#-------------------------------------------------------------------------------
# Dynamically create symlinks appropriate to current machine. This is
# particularly useful for configuration files like window manager configuration
# or asoundrc which will usually vary from one machine to another.
#
# Of course, it doesn't have to be specific to one machine or another. Each
# "machine_dir" could actually just be different flavors for different
# uses/users.
#

script_dir=${0%/*}
FORKMYDOTS_DIR="${script_dir}/../"
LIB_DIR="${FORKMYDOTS_DIR}/lib/bash/"

. ${LIB_DIR}/print.functions.sh

while getopts hv OPT; do
	case "$OPT" in
	v)
		echo "`basename $0` version ${VERSION}"
		exit 0
		;;
	h|\?|*)
		print_usageXX standard_usageXX >&2
		exit 1
		;;
	esac
done

# remove the switches parsed above
shift `expr $OPTIND - 1`

machine_dir="${1}"

#-------------------------------------------------------------------------------
# Error checking.
#

if [ ! -d "${machine_dir}" ] ;then
	echo "ERROR: ${machine_dir} does not exist!"
	exit -1
fi

if [ ! "${PWD}" = "${HOME}" ] ;then
	echo "ERROR: This script should be run from the current user's home" \
		"directory."
	exit -1
fi

function link_dots() {
	specified_dir=${1:?}

	#---------------------------------------
	# Obtain list of files using names that are relatively correct for the current
	# user's home directory.
	#

	file_list=`find "${specified_dir}" -mindepth 1 -type f -printf "%P "`

	#---------------------------------------
	# Remove and backup current files, then create symlink to new file.
	#
	backup_dir="${FORKMYDOTS_DIR}/backups"
	backup_dir_date="${backup_dir}/`date --rfc-3339=date`"
	backup_dir_time="${backup_dir_date}/`date --rfc-3339=seconds | \
		awk '{print $2}'`"

	mkdir -p ${backup_dir_time}

	for file in ${file_list} ;do
		[ ! -h "${file}" ] && cp "${file}" "${backup_dir_time}/${file}"
		ln -sf "${PWD}/${specified_dir}/${file}" "${file}"
	done 
}

link_dots "${machine_dir}"

#-------------------------------------------------------------------------------
# Cleanup and documentation.
# As far as I know, 'rmdir' only removes empty directories.

rmdir ${backup_dir_time} 2>&1 > /dev/null
rmdir ${backup_dir_date} 2>&1 > /dev/null
 
:<<standard_usageXX
 <machine-dir>
  machine-dir is a directory containing add-ons for particular machines. For
  example, consider cases where a single repository is being shared between two
  computers or even two different users on the same computer with very different
  .asoundrc needs. One might still wish to track these in a git repository in
  case the system is re-installed or some kind of crazy other thing happens or
  even just for posterity's sake. Mmm, sake.
standard_usageXX
