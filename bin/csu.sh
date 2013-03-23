#!/bin/bash

# This script is intended to preserve the current user's dotfiles settings when
# using 'sudo su' to obtain root privileges on a system.

BASH_OPTIONS=" --rcfile ${HOME}/.bashrc "

#-------------------------------------------------------------------------------
# Core functionality should always remain the same:
#

sudo ${SUDO_OPTIONS} bash ${BASH_OPTIONS}

