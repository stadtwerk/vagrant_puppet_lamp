#
# Puppet Module - bootstrap
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class bootstrap {

    # Update Advanced Packaging Tool (APT) source list only if the last update was over an hour ago.
    exec {
        'update apt-get source list':
            command => 'apt-get update || exit 0',
            onlyif  => '[ $(expr $(date +%s) - $(stat -c %Y /var/cache/apt/pkgcache.bin)) -ge 3600 ]',
    }
}
