# forkmydots
This is my public dotfiles repository with scripts I hope will be useful for
other people. My primary goal is to make the scripts compatible with the largest
number of shells and to leave it at that--shell scripts only. No Ruby. No
Python. As few external dependencies as possible.

I also believe that the architecture of this project lends itself particularly
well to forking; don't like my dotfiles? **forkmydots** by creating your own
subdirectiroy of **homes/**. See the **Layout** **HOWTO** section for more
information.

## Layout
 - **bin/** This directory is added to PATH in **homes/default/bashrc**.
 - **backups/** This is where backups are stored when running `forkmydots.sh
   backup`. This directory does not exist until the backup command is run.See
   the **HOWTO** section below for more information on how backups work.
 - **lib/** This directory stores different sets of libraries that I use to
   separate shell functions in to logical categories. Probably not absolutely
   necessary, but it's an organizational habit that I am finding useful in my
   work life.
 - **homes/** and **machines/** There is nothing special about these
   directories. However, they are handy for separating data from functional
   components in the system. I envision sub directories of **homes/** being used
   to store different groups of dotfiles; this project comes with **default**
   which is actaully the machine-indifferent portion of my personal dotfiles
   repository. Subdirectories of **machines/** represent sets of dotfiles that I
   use for different computers on which I run my preferred window manager.
 - **scripts/** These are small projects that I used to keep in my dotfiles
   repository before refactoring it into this project. I will probably find
   another repo for these eventually, but for now here they are.

## HOWTO 
Put machine-specific rcfiles in a subdirectory of forkmydots/machines/. Then
run:

```sh
$ ./forkmydots/bin/forkmydots.sh install .forkmydots/machine/<machine_name>
```
## TODO 
* Create script that makes the process of "infecting" another user account with
  this repo a little smoother. This might look something like:

```sh
# Perform initial checkouts in the remote repository; should back up existing
# files using git stash before doing this.
$ remotedots.sh checkout user@host  
# Add the new repository as a remote for the current repository.
$ remotedots.sh add-remote user@host  
# Optionally push the local user's ssh public key to that remote repository.
$ remotedots.sh push-key user@host  
```
