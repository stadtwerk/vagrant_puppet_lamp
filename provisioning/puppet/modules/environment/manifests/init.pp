#
# Puppet Module - environment
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class environment {

    # Add environment.sh file to profile.d directory.
    file {

        '/etc/profile.d/environment.sh':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            source  => 'puppet:///modules/environment/environment.sh',
    }
}
