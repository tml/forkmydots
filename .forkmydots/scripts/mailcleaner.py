#!/usr/bin/python
# vim:ts=4:sw=4:softtabstop=4:smarttab:expandtab

## @package Clean up Maildir directory by removing duplicage messages.
#

import re
import os
import os.path as path

import optparse

__version__ = "0.1"

def is_dup(messages, filename):

    if path.isdir(filename):
        return False

    with open(filename, 'r') as f:
        text = f.read()

    match = re.search("message-id:(.+)", text.lower())

    if not match:
        print("Hmm, this email does not have a Message-ID: {0}".format(
            filename ))
        return False

    message_id = match.group(1)

    if messages.has_key(message_id):
        messages[message_id].append(filename)
        return True
    else:
        messages[message_id] = [filename]
        return False

def find_dups(messages, dirname, names):
    for message in names:
        filename = path.join(dirname, message)
        is_dup(messages, filename):

def remove_dups(messages):
    for message_id, filenames in messages.items():
        if len(filenames) > 1:
            filenames = filenames[1:]
            for filename in filenames:
                os.unlink(filename)

def main():
    option_parser       = optparse.OptionParser(
            version = "MailCleaner, version {0}".format(
                __version__),
            usage   = "%prog [options] <Maildir>",
            )

    (options, args) = option_parser.parse_args()

    if len(args) > 1 or len(args) < 1:
        option_parser.error("Incorrect number of arguments.")

    maildir_path = path.abspath(args[0])

    if not path.exists(maildir_path):
        raise OSError #"Path does not exist."

    unique_messages = dict()

    path.walk(maildir_path, remove_dups, unique_messages)

    remove_dups(unique_messages)

if __name__ == "__main__":
    main()

