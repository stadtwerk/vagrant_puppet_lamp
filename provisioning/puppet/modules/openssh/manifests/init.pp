#
# Puppet Module - OpenSSH
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class openssh
{
    # Install the latest openssh-server packages.
    package 
    { 
        'openssh-server':
            ensure  => latest,
    }
    
    # Ensure the SSH service is running.
    service 
    { 
        'ssh':
            enable  => true,
            ensure  => running,
            require => Package['openssh-server'],
    }
    
    #
    # Configure the SSH service.
    #
    # @see http://www.openssh.com/cgi-bin/man.cgi?query=sshd_config
    #
    augeas {
        'configure sshd_config':
            context => '/files/etc/ssh/sshd_config',
            changes => 
            [
                'set PermitRootLogin yes',
                'set PasswordAuthentication no',
                'set UsePAM no',
                'set LoginGraceTime 30',
                'set ClientAliveInterval 30',
                'set ClientAliveCountMax 3',
                'set MaxSessions 128',
                'rm AcceptEnv',
            ], 
            require => Package['openssh-server'],
            notify  => Service['ssh'],
    }
}
