#!/bin/bash

function print_usageXX() {
	echo -n "Usage: $0"
	sed --silent -e "/:<<$1$/,/^$1$/p" $0 | \
		sed -e "/$1/d"
	exit 1
}
