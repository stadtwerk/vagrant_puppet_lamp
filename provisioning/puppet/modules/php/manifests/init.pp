#
# Puppet Module - PHP
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class php 
{

    # Add Personal Package Archive (PPA) for PHP5 to APT source list.
    exec 
    { 
        'add php repository and update sources':
            command => 'add-apt-repository ppa:ondrej/php5-5.6 --yes && apt-get update',
            unless  => 'apt-cache policy | grep --quiet http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu/',           
    }

    # Install PHP5 packages.
    package 
    {
        [
            'php5', 
            'php5-cli', 
            'php5-mysql',
            'php5-dev',
            'php5-mcrypt',
            'php5-gd',
            'php5-curl',
            'libapache2-mod-php5',
         ]:
            ensure  => latest,
            require => Exec['add php repository and update sources'],
    }
    
    # Configurate the default php.ini file.
    augeas 
    {
        'php.ini':
            context => '/files/etc/php5/apache2/php.ini',
            changes => 
            [
                'set PHP/max_execution_time 300',
                'set PHP/post_max_size 512M',
                'set PHP/upload_max_filesize 512M',
                'set PHP/max_execution_time 300',
                'set PHP/max_input_time 300',
                'set PHP/memory_limit 1024M',
            ],
            require => 
            [
                Package['apache2'],
                Package['php5'],
            ],
            notify  => Service['apache2'],
    }
}
