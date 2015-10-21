#
# Puppet Module - Swap
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
# @author    Finn Kumkar <kumkar@stadtwerk.org>
#

class swap
{
    exec 
    {
        'create swapfile':
            command => 'fallocate --length 4G /swapfile',
            creates => '/swapfile',
    }

    file 
    {
        '/swapfile':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => 600 ,
            require => Exec['create swapfile'],
    }
    
    exec 
    {
        'enable swapfile':
            command => 'mkswap /swapfile && \
                        swapon /swapfile',
            
            unless  => "swapon -s | grep --quiet '/swapfile'",
            require => File['/swapfile'],
    }
    
    exec
    {
        'optimize swappiness':
            command => 'sysctl vm.swappiness=10',
            unless  => 'sh -c "if [ $(sysctl --values vm.swappiness) -eq 10 ]; then exit 0; else exit 1; fi"',
            require => Exec['enable swapfile'],
    }
    
    exec
    {
        'optimize vfs_cache_pressure':
            command => 'sysctl vm.vfs_cache_pressure=50',
            unless  => 'sh -c "if [ $(sysctl --values vm.vfs_cache_pressure) -eq 50 ]; then exit 0; else exit 1; fi"',
            require => Exec['enable swapfile'],
    }

    exec 
    {
        'make swapfile permanent':
            command => 'echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab',
            unless  => "cat /etc/fstab | grep --quiet '/swapfile'",
            require => Exec['enable swapfile'],
    }

    augeas 
    {
        'optimize swap settings permanently':
            context => '/files/etc/sysctl.conf',
            changes => 
            [
                'set vm.swappiness 10',
                'set vm.vfs_cache_pressure 50',
            ],
            require => Exec['make swapfile permanent'],
    }
}