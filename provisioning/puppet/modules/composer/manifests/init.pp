#
# Puppet Module - Composer
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class composer {
    
    # The composer version to install.
    $version = "1.0.0-alpha10"

    # Make sure the /home/vagrant/tmp directory exists.
    file {

        '/home/vagrant/tmp':
            ensure => directory,
            owner  => 'vagrant',
            group  => 'vagrant',
            mode   => '0777',
    }

    # Download a specific composer version.
    exec {

        'download composer':
            command => "curl -sS https://getcomposer.org/installer | \
                        php -- --install-dir=/home/vagrant/tmp --filename=composer-${version}.phar --version=${version}",
            require => 
            [
                Package['curl'],
                Package['php5'],
                Package['apache2'],
            ],
            creates => "/home/vagrant/tmp/composer-${version}.phar",
    }

    # Remove existing composer unless it already is the specified version.
    exec {

        'remove /usr/local/bin/composer':
            command => 'rm --force /usr/local/bin/composer',
            unless  => "bash -c \"if [ -f /usr/local/bin/composer ]; \
                            then /usr/local/bin/composer --version | grep --quiet ${version}; \
                            else exit 1; \
                        fi\"",
            require => Exec['download composer'],
    }
    
    # Move the composer executable to /usr/local/bin.
    exec {

        'move composer to /usr/local/bin':
            command => "mv /home/vagrant/tmp/composer-${version}.phar /usr/local/bin/composer",
            require => Exec['remove /usr/local/bin/composer'],
            creates => "/usr/local/bin/composer",
    }
}
