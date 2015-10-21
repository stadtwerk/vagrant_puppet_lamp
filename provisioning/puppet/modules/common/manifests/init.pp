#
# Puppet Module - common
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class common {

    # Install the latest common packages.
    package { 
        [
            'git',
            'ssh',
            'zip',
            'curl',
            'nano',
            'rsync',
            'unzip',
            'multitail',
            'augeas-tools',
            'software-properties-common',
        ]:
            ensure  => latest,
    }
}
