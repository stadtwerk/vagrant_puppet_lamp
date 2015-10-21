#!/bin/bash -eux

#
# virtualbox.sh
#
# Install the VirtualBox Guest Additions.
#
# @see https://docs.vagrantup.com/v2/boxes/base.html
#
# @copyright  Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

# Install D-Bus package, otherwise VirtualBox would not start automatically after compile.
apt-get -y install --no-install-recommends libdbus-1-3

# Install dkms for dynamic compiles.
apt-get -y install dkms

# Install the latest VirtualBox guest additions.
VERSION=$(cat /home/vagrant/.vbox_version)
mount -o loop /home/vagrant/VBoxGuestAdditions_$VERSION.iso /mnt
yes|sh /mnt/VBoxLinuxAdditions.run
umount /mnt

# Remove all VirtualBox images.
rm /home/vagrant/*.iso
