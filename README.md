# forkmydots
This is a basic shell script based dotfiles manager that includes example
dotfiles used by the author.

The primary goal is to make the scripts compatible with the largest
number of shells and to leave it at that--shell scripts only. No Ruby. No
Python. As few external dependencies as possible. 

The architecture of projects like this (mine certainly is not the first) lends
itself particularly well to forking; don't like the default dotfiles?
**forkmydots** by creating your own subdirectiroy of **homes/**. You can still
merge changes from upstream when changes are made to the basic scripts.
                          
See the **Layout** **HOWTO** section for more information.

## Features
* Back up your existing dotfiles before clobbering them with the install script.
* Architecture lends itself well to forking using organizational strategy that
  minimizes the risk of name collisions.

## Getting Started
```sh
$ git clone git@github.com:waynr/forkmydots.git
$ ./forkmydots/bin/forkmydots.sh backup
$ ./forkmydots/bin/forkmydots.sh install
```

This will set you up with the dotfiles included with the project by default.

## HOWTO 
Below are some example applications of the commands offered by the
**forkmydots.sh** script.

### Install dotfiles into the current user's home directory.
```sh
# Install dotfiles from forkmydots/homes/default, which is the default dotfiles
# collection installed with this repository.
$ ./forkmydots/bin/forkmydots.sh -d forkmydots/homes/<dotsname> install 

# Install dotfiles from forkmydots/homes/<dotsname>
$ ./forkmydots/bin/forkmydots.sh -d forkmydots/homes/<dotsname> install 

# Install dotfiles from arbitrary directory. All regular files in this directory
# will be prepended with a period and linked to the user's home directory.
# Except for files that end with ".swp". 
$ ./forkmydots/bin/forkmydots.sh -d <path/do/dir> install

```

### Backup
```sh
# Find the names of all files in <path/to/dir> relative to that directory, then
# create backups of the files with those same names in
# forkmydots/backups/<date>/<time>.
$ ./forkmydots/bin/forkmydots.sh -d <path/do/dir> backup
```

## Layout
 - **bin/** This directory is added to PATH in **homes/default/bashrc**.
 - **backups/** This is where backups are stored when running `forkmydots.sh
   backup`. This directory does not exist until the backup command is run. See
   the **HOWTO** section for more information on how backups work.
 - **lib/** This directory stores different sets of libraries used to 
   separate shell functions in to logical categories.
 - **homes/** and **machines/** There is nothing special about these
   directories. However, they are handy for separating data from functional
   components in the system. **homes/** is intended to store to store different
   groups of dotfiles; this project comes with **default** which is actaully the
   machine-indifferent portion of the author's dotfiles repository.
   Subdirectories of **machines/** are intended to represent dotfiles that are
   expected to be different on different computers.
 - **scripts/** These are small projects the original author used to keep in his
   dotfiles repository before refactoring it into this project. They will
   probably be removed eventually.

## TODO 
* Create script that makes the process of "infecting" another user account with
  this repo a little smoother. This might look something like:
```sh
# Perform initial checkouts in the remote repository; should back up existing
# files using git stash before doing this.
$ forkmydots.sh checkout user@host  
# Add the new repository as a remote for the current repository.
$ forkmydots.sh add-remote user@host  
# Optionally push the local user's ssh public key to that remote repository.
$ forkmydots.sh push-key user@host  
```
* Refine the backup behavior so that backups for a given dotfiles directory are
  stored in a subdirectory of that dotfile directory.
