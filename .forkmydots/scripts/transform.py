#!/usr/bin/env python

import optparse

__version__ = "0.0.1"

def reverse_str(s):
    tmp = list(s)
    tmp.reverse()
    return ''.join(tmp)

def print_reversed_str(s):
    print (reverse_str(s))

def main():
    option_parser       = optparse.OptionParser(
            version = "Pidgin Text Transformer, version {0}".format(
                __version__),
            usage   = "%prog [options] <cmd>",
            #author  = "Wayne Warren"
            )

    (options, args) = option_parser.parse_args()

#    if len(args) > 2 or len(args) < 2:
#        option_parser.error("Incorrect number of arguments.")

    if args[0] == "reverse":
        print_reversed_str(' '.join(args[1:]))
    else:
        print_reversed_str(' '.join(args[0:]))

    return 0

if __name__ == "__main__":
    main()
