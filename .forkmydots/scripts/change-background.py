#!/usr/bin/env python
#
# change-background.py
#
# A script to change to a random background image
#  Originally written to use gconf to accomplish this end, it now uses
#  xloadimage -onroot which is slightly less presumptuous about how the user's
#  system is set up initially (considering that xloadimage is a much smaller set
#  of dependencies than gconf).
#
#(c) 2012, Wayne Warren <steven.w.warren@gmail.com>
#(c) 2004, Davyd Madeley <davyd@madeley.id.au>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2, or(at your option)
#   any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software Foundation,
#   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#

import sys
import os
import random
import mimetypes

home = os.getenv("HOME")

backgrounds = home + "/visual/backgrounds/"
bg_ln_name = os.path.join( backgrounds , "current" )

def get_files_recursively(rootdir):
    """Recursively get a list of files from a folder."""
    fileList = []

    for root, subFolders, files in os.walk(rootdir):
        for file in files:
            fileList.append(os.path.join(root,file))

    return fileList

# TODO check for the presense of xloadimage, exit gracefully if missing

# Get the files from the backgrounds folder.
dir_items = get_files_recursively(backgrounds)

# Check if the background items are actually images. Approved files are
# put in 'items'.
items = []
for item in dir_items:
    mimetype = mimetypes.guess_type(item)[0]
    if mimetype and mimetype.split('/')[0] == "image":
        items.append(item)

# Get a random background item from the file list.
item = random.randint(0, len(items) - 1)

# Get the current background.
if ~ os.path.exists(bg_ln_name):
	current_bg = os.readlink(bg_ln_name)
else:
	os.unlink(bg_ln_name)
	current_bg = items[0]

# Make sure the random background item isn't the same as the background
# currently being used.
while(items[item] == current_bg):
    item = random.randint(0, len(items) - 1)

dirpath = home

if os.path.exists(bg_ln_name):
	os.unlink(bg_ln_name)

os.symlink(items[item], bg_ln_name)

# Finally, set the new background.
if os.path.exists(bg_ln_name):
	os.system("$(which xloadimage) -onroot -display :0 " + bg_ln_name)
sys.exit()
