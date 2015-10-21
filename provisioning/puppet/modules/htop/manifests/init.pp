#
# Puppet Module - htop
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class htop {

    # Install the latest htop package.
    package {

        'htop':
            ensure  => latest,
    }
    
    # Create '/home/vagrant/.config/htop/' directory.
    file {

        [
            '/home/vagrant/.config/',
            '/home/vagrant/.config/htop',
        ]:
            ensure  => directory,
            owner   => 'vagrant',
            group   => 'vagrant',
            mode    => '0755',
    }
   
    # Replace the original htop configuration file.
    file {

        '/home/vagrant/.config/htop/htoprc':
            ensure  => present,
            owner   => 'vagrant',
            group   => 'vagrant',
            mode    => '0644',
            source  => 'puppet:///modules/htop/htoprc',
            require => 
            [
                Package['htop'],
                File['/home/vagrant/.config/htop/'],
            ],
    }
}
