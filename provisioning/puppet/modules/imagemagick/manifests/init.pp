#
# Puppet Module - ImageMagick
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class imagemagick 
{

    # Install ImageMagick package.
    package 
    { 
        'imagemagick':
            ensure  => latest,
    }
}
