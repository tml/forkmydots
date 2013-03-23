#!/bin/bash

# Load resources

wm="xmonad"

xrdb -merge .Xresources

# Set up an icon tray

trayer --edge top --align right --SetDockType true --SetPartialStrut true \
       --expand true --width 10 --transparent true --tint 0x191970 \
       --height 12 &

xloadimage -onroot lush-summer_louisville_kentucky.jpg 

xscreensaver -no-splash &

exec xmonad

