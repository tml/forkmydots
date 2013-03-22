forkmydots
==========

This is my public dotfiles repository with scripts I hope will be useful for other people.

It is currently very experimental. In an attempt to avoid clobbering anyone
else's home repository with TOO much cruft other than some standard dotfiles, a
directory named "${HOME}/.forkmydots" was created to store scripts and stuff.

This is not really a plug'n'play project that you should expect to work straight
out of the box. Approach it cautiously as you might an alligator with a
toothache. 

Don't like the directory layout? Don't like my .bashrc? (aw c'mon, isn't it
awesome??)

Feel free to make changes and submit pull requests...if I like your changes, I
will merge them and use them everywhere.

Otherwise...*forkmydots*! Make them your own. Eat some broccoli. Write an essay.
Climb a tree. Drink some water. Go for a swim. Okay, enough of that nonsense.

HOWTO 
=====
Put machine-specific rcfiles in a subdirectory of .forkmydots/machine/. Then
run:
  $ ./forkmydots/scripts/config-home.sh .forkmydots/machine/<machine_name>

This script is actually currently a little fragile. For now only use relative
directory names for when specifying the path to the maching-specific rc files.

HUH? 
====
I also included some other scripts in .forkmydots/machin/scripts/. No particular
reason for this, they were just part of the old dotfiles repo before I
reinitialized to get eliminate some personal information from the history.

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

* Create "forkmydots.sh" multi-command script to perform basic management tasks.
* Style this README to make it look nicer.
