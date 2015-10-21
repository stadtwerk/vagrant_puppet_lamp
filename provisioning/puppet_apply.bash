#!/usr/bin/env bash

#
# puppet_apply.bash
#
# The Puppet apply command executed without any failures when its exit
# code equals either 0 or 2. This script checks for that exit codes
# and exits with code 0 on success and a non-zero exit code on failure. 
#
# If Puppet runs without the detailed-exitcodes flag it will by design
# exit with 0 even in the event of a failed transaction.
#
# @see http://docs.puppetlabs.com/references/3.3.1/man/apply.html
# @see https://tickets.puppetlabs.com/browse/PUP-2754
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

# Text colors.
color_red='\e[0;31m'
color_reset='\e[0m'

# Run Puppet apply with the detailed exit codes flag.
puppet apply --detailed-exitcodes \
             --verbose \
             --parser future \
             --modulepath='/home/vagrant/provisioning/puppet/modules' \
             '/home/vagrant/provisioning/puppet/manifests/lamp.pp'

# Get the exit code of the puppet apply command.
exit_code=$?

# If the exit code states that there were no transaction failures.
if [ $exit_code -eq 0 ] || [ $exit_code -eq 2 ]; then
    
    # Exit with 0.
    exit 0
    
else
    
    # Output a error message.
    echo -e "${color_red}ERROR: Puppet apply failed - exiting with status code ${exit_code}${color_reset}"
    
    # Exit with a non-zero code to invalidate the Docker Cache.
    exit ${exit_code}
fi
