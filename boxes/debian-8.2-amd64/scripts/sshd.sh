#!/bin/bash -eux

#
# sshd.sh
#
# @copyright  Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

# Prevent DNS resolution to speed up SSH connections.
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config
