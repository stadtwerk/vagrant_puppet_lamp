#!/usr/bin/env bash

#
# bootstrap.bash
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#



#
# TIME ZONE
#

time_zone="Europe/Berlin"

if [ "$(cat /etc/timezone)" != "$time_zone" ]; then

    echo "Setting time zone and local time to ${time_zone}..."
    echo $time_zone > /etc/timezone
    cp /usr/share/zoneinfo/$time_zone /etc/localtime

fi


#
# PACKAGE LIST
#

# If the last package list update was over an hour ago or this is the first run on the machine.
if [ "$(expr $(date +%s) - $(stat -c %Y /var/cache/apt/pkgcache.bin))" -ge 3600 ] || \
   [ ! -f '/home/vagrant/.bootstrap_shell_provisioning_successful' ] ; then

    echo 'Updating the package list...'
    apt-get update -qq
 
    # If APT failed to update the package list.
    if [ $? -gt 0 ] ; then

        echo 'Failed to get some package lists, will try again on the next run...'
        touch --date '2 hours ago' /var/cache/apt/pkgcache.bin
        
    fi

else

    echo 'Updated package list not an hour ago, moving on...'

fi


#
# PACKAGES
#

packages=(

    'apt-transport-https'
    'puppet'
);

for package in "${packages[@]}"; do

    if [[ "$(apt-cache policy "${package}" | grep --quiet 'Installed:')" ]] ; then
        
        echo "Package ${package} is already installed, moving on..."
    
    else
        
        echo "Installing the latest ${package} package..."
        apt-get install -qq --yes "${package}"
    
    fi
    
done


#
# TOUCH SUCCESS FILE
#

echo 'Touching success file...'
touch '/home/vagrant/.bootstrap_shell_provisioning_successful'
