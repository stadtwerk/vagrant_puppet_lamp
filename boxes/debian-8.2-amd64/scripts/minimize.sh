#!/bin/bash -eux

#
# minimize.sh
#
# @copyright  Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

# Zero out the free space to save space in the final image.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync
