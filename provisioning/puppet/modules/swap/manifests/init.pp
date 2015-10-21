#
# Puppet Module - Swap
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class swap {

    # Configuration.
    $swap_file = '/swapfilea'
    
    # Create swap file.
    exec {

        'create swap file':
            command => "dd if=/dev/zero of=\"${swap_file}\" bs=1G count=2",
            creates => "${swap_file}",
    }

    # Modify swap file.
    file {

        "${swap_file}":
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0600' ,
            require => Exec['create swap file'],
    }
    
    # Enable swap file.
    exec {

        'enable swap file':
            command => "mkswap \"${swap_file}\" && swapon \"${swap_file}\"",
            unless  => "swapon -s | grep --quiet \"${swap_file}\"",
            require => File["${swap_file}"],
    }

    # Persist swap file.
    exec {
        'make swap file permanent':
            command => "echo \"${swap_file}   none    swap    sw    0   0\" >> /etc/fstab",
            unless  => "cat /etc/fstab | grep --quiet \"${swap_file}\"",
            require => Exec['enable swap file'],
    }
    
    # Optimize Swappiness.
    exec {
       
        'optimize swappiness':
            command => 'sysctl vm.swappiness=10',
            unless  => 'sh -c "if [ $(sysctl --values vm.swappiness) -eq 10 ]; then exit 0; else exit 1; fi"',
            require => Exec['enable swap file'],
    }
    
    # Optimize cache pressure.           
    exec {
       
        'optimize vfs_cache_pressure':
            command => 'sysctl vm.vfs_cache_pressure=50',
            unless  => 'sh -c "if [ $(sysctl --values vm.vfs_cache_pressure) -eq 50 ]; then exit 0; else exit 1; fi"',
            require => Exec['enable swap file'],
    }

    # Persist Swap settings.
    augeas {
        'optimize swap settings permanently':
            context => '/files/etc/sysctl.conf',
            changes => 
            [
                'set vm.swappiness 10',
                'set vm.vfs_cache_pressure 50',
            ],
            require => Exec['make swap file permanent'],
    }
}
