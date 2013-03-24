# forkmydots
This is a basic shell script based dotfiles manager that includes example
dotfiles used by the author.

The primary goal is to make the scripts compatible with the largest
number of shells and to leave it at that--shell scripts only. No Ruby. No
Python. As few external dependencies as possible. 

The architecture of projects like this (this is certainly not the first) lends
itself particularly well to forking; don't like the default dotfiles?
**forkmydots** by creating your own subdirectiroy of **homes/**. This way you 
can still easily merge changes from upstream when changes are made to the basic
scripts.
                          
See the **Layout** or **HOWTO** section for more information.

## Features
* Back up your existing dotfiles before clobbering them with the install script.
* Architecture lends itself well to forking using organizational strategy that
  minimizes the risk of merge conflicts.
* Use hard links to dotfiles in the **forkmydots** project directory, but only
  IF this directory is located on the same filesystem as your home directory;
  otherwise use symlinks. Either way, this allows you to modify your dotfiles in
  place and track changes in the git repository at the same time.
* Well-documented and easily extensible management script.
* Install script currently replaces "^FORKMYDOTS\_DIR=.\*$" in any dotfile with
  the absolute location of the **forkmydots** project using sed. Actually, maybe
  this is a bug...? But the principle of modifying dotfiles before installing
  them could be useful. Like orange tapioca.

### Planned
* Easily push repo to account on a remote system and run install commands
  remotely so your dots are ready and waiting on that remote system next time
  you log in.

Got any other ideas? **forkmydots**, implement them, and let me know :)

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
$ ./forkmydots/bin/forkmydots.sh install 

# Install dotfiles from forkmydots/homes/<dotsname>
$ ./forkmydots/bin/forkmydots.sh -d forkmydots/homes/<dotsname> install 

# Install dotfiles from a backup located in forkmydots/homes/<dotsname>
$ ./forkmydots/bin/forkmydots.sh -d forkmydots/homes/<dotsname>/backups/2013-03-24_090055 install 

# Install dotfiles from arbitrary directory. All regular files in this directory
# will be prepended with a period and linked to the user's home directory.
# Except for files that end with ".swp". 
$ ./forkmydots/bin/forkmydots.sh -d <path/do/dir> install

```

### Backup
Running a backup creates a new "dotfiles" directory which contains dotfiles
backed up in a form that can be installed using the **forkmydots.sh** script. It
only backs up files from the user's home directory which match the dotfiles in
the dotfiles directory specified on the command line with the "-d" option.

```sh
# Find the names of all files in <path/to/dir> relative to that directory, then
# create backups of the files with those same names in
# <path/to/dir>/backups/YYYY-mm-dd_HHMMSS/.
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
