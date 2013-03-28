#/bin/bash

#-------------------------------------------------------------------------------
# forkmydots.sh
#
# Author. 
#  Everyone who ever wrote a bash script.
#
# Goal. 
#  - Create an easily-extensible multi-call script to reconfigure and back up the
#    configuration settings in one's home directory on a *nix-like machine.
#  - Make this script compatible with as many shells as possible.
#

#-------------------------------------------------------------------------------
# Orientation and Libary loading.
#

[ -f "/${0}" ] && script_full_path="${0}" \
	|| script_full_path="${PWD}/${0#./}"
script_dir="${script_full_path%/*}"
forkmydots_dir="${script_dir%/*}"

LIB_DIR="${forkmydots_dir}/lib/bash/"
. ${LIB_DIR}/sys.functions.sh
. ${LIB_DIR}/print.functions.sh
. ${LIB_DIR}/dots.functions.sh

system_info

#-------------------------------------------------------------------------------
# Sensible defaults.
#

DOTS_DIR="${forkmydots_dir}/homes/default" 

#-------------------------------------------------------------------------------
# Option parsing.
#

while getopts d:hr:sv OPT; do
	case "$OPT" in
	v)
		echo "`basename $0` version ${VERSION}"
		exit 0
		;;
	r)	
		FORKMYDOTS_HOST="${OPTARG}"
		;;
	s)	
		USE_SYMLINKS=1
		;;
	d)	
		DOTS_DIR="${OPTARG}"
		;;
	h|\?|*)
		print_usageXX standard_usageXX >&2
		exit 1
		;;
	esac
done

# remove the args parsed above
shift `expr $OPTIND - 1`

[ "x$#" != "x1" ] && print_usageXX standard_usageXX >&2

command="${1:?}"

#-------------------------------------------------------------------------------
# Error checking.
#

if [ ! -d "${DOTS_DIR}" ] ;then
	echo "ERROR: ${DOTS_DIR} does not exist!"
	exit -1
fi

if [ ! "${PWD}" = "${HOME}" ] ;then
	echo "ERROR: This script should be run from the current user's home" \
		"directory."
	exit -1
fi

#-------------------------------------------------------------------------------
# Command execution.
#

case ${command} in
	backup)
		backup_dots "${DOTS_DIR}"
		;;
	install)
		link_dots "${DOTS_DIR}"
		;;
	remote-add)
		[ -z "${FORKMYDOTS_HOST}" ] \
			&& print_usageXX standard_usageXX && exit -1
		push_dots "${DOTS_DIR}" "${FORKMYDOTS_HOST}"
		;;
	*)
		print_usageXX standard_usageXX >&2
		;;
esac

#-------------------------------------------------------------------------------
# Cleanup and documentation.
# 

:<<standard_usageXX
 -[s] [-d <dots-dir>] [-r <remote-host>] <command>
  <command> is fairly self-explanatory. Below is a list of commands along with a
  short description of each:
    
    backup	- Backup all the files in the user's home directory which
          	  correspond to those found in <dots-dir>.
    install	- Install files found in <dots-dir> in the user's home
          	  directory. Hard links are used by default if possible,
          	  otherwise symlinks are used. To override the default behavior,
          	  use the '-s' option.

  OPTIONS

  -s <use-symlinks>, 
    The default behavior of the 'install' command is to create hard links to
    dotfiles in the chosen dotfiles repository if possible, symlinks if not.
    This flag can be used to override that default behavior and force the usage
    of symlinks.

  -d <dots-dir>, DEFAULT = ${DOTS_DIR}
    <dots-dir> is a directory containing add-ons for particular machines. For
    example, consider cases where a single repository is being shared between
    two computers or even two different users on the same computer with
    different .asoundrc needs. One might still wish to track these in a git
    repository in case the system is re-installed or some kind of crazy other
    thing happens or even just for posterity's sake. Mmm, sake.

  -d <remote-host>, remote-* commands fail without this option
    <remote-host> is of the form <USER>@<HOST> where <USER> is the username
    whose home directory is to have the given forkmydots-compatible dotfiles
    directory installed and <HOST> is the IP addres or hostname of the target
    machine.

standard_usageXX
