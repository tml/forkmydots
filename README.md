forkmydots
==========

This is my public dotfiles repository with scripts I hope will be useful for other people.

It is currently very experimental. In an attempt to avoid clobbering anyone
else's home repository with TOO much cruft other than some standard dotfiles, a
directory named "${HOME}/.forkmydots" was created to store all scripts.

This is not really a plug'n'play project that you should expect to work straight
out of the box. Instead, approach it cautiously as you might an alligator with a
toothache. At times things might seem a little janky, and that is to be
expected; in that case...fork it! Make it your own. Be cool.

TODO 
====
* Create script that makes the process of "infecting" another user account with
  this repo a little smoother. This might look something like:

  $ remotedots.sh init user@host  
    * Install the current git repository in the remote user's home directory 

  $ remotedots.sh checkout user@host  
    * Perform initial checkouts in the remote repository; should back up
      existing files using git stash before doing this.

  $ remotedots.sh add-remote user@host  
    * Add the new repository as a remote for the current repository.

  $ remotedots.sh push-key user@host  
    * Optionally push the local user's ssh public key to that remote repository.

