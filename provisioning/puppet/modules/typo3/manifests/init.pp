#
# Puppet Module - TYPO3
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class typo3 
{

    # The TYPO3 version to install.
    $version = "6.2.12"
    
    # Prepare the directories for the install_typo3.bash script.
    file
    {
        [
            '/var/www/application/typo3/',
            '/var/www/application/typo3_src/',
        ]:
            ensure => directory,
            owner  => 'www-data',
            group  => 'www-data',
            mode   => 2775,
    }

    # Download TYPO3 package.
    exec 
    {
        "download typo3 ${version}":
            command => "wget --quiet \
                             --output-document=/var/www/application/vendor/typo3-${version}.tar.gz \
                             https://github.com/TYPO3/TYPO3.CMS/archive/${version}.tar.gz",
            creates => "/var/www/application/vendor/typo3-${version}.tar.gz",
    }
}
