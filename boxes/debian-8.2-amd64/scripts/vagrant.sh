#!/bin/bash -eux

#
# vagrant.sh
#
# Configures the machine to be accessible by Vagrant.
#
# @see https://docs.vagrantup.com/v2/boxes/base.html
#
# @copyright  Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

# Install the common NFS package for Vagrant.
apt-get -y install nfs-common

# Create a system group 'admin' and assign the 'vagrant' user (created by preseed.cfg) to it.
groupadd --system admin
usermod --append --groups admin vagrant

# Set up sudo to allow no-password sudo for the 'admin' group.
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# Add the insecure vagrant SSH key from GitHub.
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
