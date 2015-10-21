#
# Puppet Module - Apache
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class apache 
{
    # Install the apache2 package.
    package 
    { 
        'apache2':
            ensure  => latest,
    }
    
    # Start the apache2 service.
    service 
    { 
        'apache2':
            ensure  => running,
            enable  => true,
            require => Package['apache2'],
    }

    # Enable mod_rewrite by creating a symlink in the mods-enabled directoy.
    file 
    { 
        '/etc/apache2/mods-enabled/rewrite.load':
            ensure  => link,
            target  => '/etc/apache2/mods-available/rewrite.load',
            require => Package['apache2'],
            notify  => Service['apache2'],
    }

    # Place the virtual hosts configuration file in "/etc/apache2/sites-available".
    file 
    {
        '/etc/apache2/sites-available/vhosts.conf':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            source  => 'puppet:///modules/apache/vhosts.conf',
            require => Package['apache2'],
            notify  => Service['apache2'],
    }
    
    # Enable the virtual hosts configuration by creating a symlink in the "/etc/apache2/sites-enabled" directoy.
    file 
    { 
        '/etc/apache2/sites-enabled/vhosts.conf':
            ensure  => link,
            target  => '/etc/apache2/sites-available/vhosts.conf',
            require => File['/etc/apache2/sites-available/vhosts.conf'],
            notify  => Service['apache2'],
    }
}
