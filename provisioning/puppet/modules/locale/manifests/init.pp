#
# Puppet Module - locale
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class locale {

    # Install the latest locales package.
    package {

        'locales':
            ensure  => latest,
    }

    # Generate the en_US.UTF-8 locale unless it is already available.
    exec {

        'generate en_US.UTF-8 locale':
            command => 'locale-gen en_US.UTF-8',
            unless  => "locale -a | grep --quiet '^en_US\\.utf8$'",
            require => 
            [
                Exec['update apt-get source list'],
                Package['locales'],
            ],
    }

    # Add locale.sh file to profile.d directory.
    file {

        '/etc/profile.d/lang.sh':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            source  => 'puppet:///modules/locale/lang.sh',
            require => 
            [
                Exec['generate en_US.UTF-8 locale'],
            ],
    }
}
