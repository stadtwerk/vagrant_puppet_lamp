#!/bin/bash -eux

#
# cleanup.sh
#
# @copyright  Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

# Remove unnecessary packages and clean up.
apt-get -y autoremove
apt-get -y clean
