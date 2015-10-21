#
# Puppet Module - MySQL
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class mysql {

    # Configuration.
    $mysql_root_user = 'root'
    $mysql_root_password = 'root'

    # Install the mysql-server package.
    package {

        'mysql-server':
            ensure  => latest,
    }

    # Ensure the mysql service is running.
    service {

        'mysql':
            enable  => true,
            ensure  => running,
            require => Package['mysql-server'],
    }
    
    #
    # Configurate the default my.cnf file.
    #
    #     augtool print /files/etc/mysql/my.cnf
    #
    augeas {

        'my.cnf':
            context => '/files/etc/mysql/my.cnf',
            changes => 
            [
                "set target[.='mysqld']/bind-address 0.0.0.0",
            ],
            require => 
            [
                Package['mysql-server'],
            ],
            notify  => Service['mysql'],
    }

    # Set the MySQL root user password.
    exec {

        'set mysql root password':
            
            command => "mysqladmin --user=\"${mysql_root_user}\" password \"${mysql_root_password}\"",
            unless  => "mysqladmin --user=\"${mysql_root_user}\" --password=\"${mysql_root_password}\" status",
            require =>
            [
                Package['mysql-server'],
                Service['mysql'],
            ],
    }
    
    # Grant the MySQL root user all privileges from all locations.
    exec {

        'grant root all privileges':
            command => "mysql --user=\"${mysql_root_user}\" \
                              --password=\"${mysql_root_password}\" \
                              --execute=\"GRANT ALL PRIVILEGES ON *.* TO \'${mysql_root_user}\'@\'%\' IDENTIFIED BY \'${mysql_root_password}\'\"",
            unless  => "mysql --user=\"${mysql_root_user}\" \
                              --password=\"${mysql_root_password}\" \
                              --execute=\"SHOW GRANTS FOR \'${mysql_root_user}\'@\'%\'\"",
            require => Exec['set mysql root password'],
    }
}
