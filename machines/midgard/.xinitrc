#!/bin/bash -x

image_dir="$HOME/visual/backgrounds"
image="$HOME/visual/backgrounds/current"

# set the bg 

#if [ ! -a $image ] ;then
#	if [ -x $(which xloadimage) ] && [ -d $image_dir ] ;then
#		set -x
#		list_of_images=$(find $image_dir)
#		num_images=$(find $image_dir | wc -l)
#		index="${RANDOM}"
#	
#		#index=$(($index % $num_images + 1))
#		
#		for DTBG in $list_of_images ;do
#			break
#			index=$(($index-1))
#	
#			if [ $index -eq 0 ] ;then
#				break
#			fi
#		done
#	
#		#xloadimage -onroot $DTBG
#	fi
#
#	xsetroot -mod 16 16 -fg "#881111" -bg "#000"
#else
	xloadimage -onroot "$image_dir/current"
#fi

# load resources 

if [ -f .Xresources ] ;then
	/usr/bin/xrdb -merge .Xresources
fi

# start pidgin

#if [ -x $(which pidgin) ] ;then
#pidgin &
#fi

# set up an icon tray

if [ -x $(which trayer) ] ;then
	trayer --edge top --align right --SetDockType true --SetPartialStrut \
		true --expand true --width 10 --transparent true --tint 100 \
		--height 12 &
fi

# run apps

if [ -x $(which xscreensaver) ] ;then
	xscreensaver -no-splash &
fi

exec xmonad
