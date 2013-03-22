#!/bin/bash

# Load resources

wm="xmonad"

xrdb -merge .Xresources

# Set up an icon tray

if [ -f `which trayer` ] ;then
	trayer --edge top --align right --SetDockType true --SetPartialStrut true \
		--expand true --width 10 --transparent true --tint 0x000000 \
		--height 17 &
fi

test=`which xloadimage`
if [ '${test}x' == 'x' ] ;then
	xloadimage -onroot "${HOME}/visual/backgrounds/current"
fi

test=`which xscreensaver`
if [ '${test}x' == 'x' ] ;then
	xscreensaver -no-splash &
fi

exec xmonad

