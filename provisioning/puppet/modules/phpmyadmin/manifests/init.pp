#
# Puppet Module - phpMyAdmin
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class phpmyadmin {

    # Install the phpMyAdmin package.
    package {

        'phpmyadmin':
            ensure  => present,
            require => 
            [
                Package['apache2'],
                Package['mysql-server'],
                Package['php5'],
            ],
    }

    # Copy the phpmyadmin configuration file into the apache2 conf-available directory.
    exec {

        'copy phpmyadmin.conf to /etc/apache/conf-available':
            command => 'cp "/etc/phpmyadmin/apache.conf" "/etc/apache2/conf-available/phpmyadmin.conf"',
            creates => '/etc/apache2/conf-available/phpmyadmin.conf',
            require => 
            [
                Package['apache2'],
                Package['phpmyadmin'],
            ],
    }

    # Enable the phpmyadmin configuration.
    file {

        '/etc/apache2/conf-enabled/phpmyadmin.conf':
            ensure  => link,
            target  => '/etc/apache2/conf-available/phpmyadmin.conf',
            notify  => Service['apache2'],
            require => Exec['copy phpmyadmin.conf to /etc/apache/conf-available'],
    }

    # Replace the phpmyadmin database configuration file at "/etc/phpmyadmin/config-db.php".
    file {

        '/etc/phpmyadmin/config-db.php':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0640',
            source  => 'puppet:///modules/phpmyadmin/config-db.php',
            require => Package['phpmyadmin'],
    }
}
