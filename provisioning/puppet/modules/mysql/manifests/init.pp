#
# Puppet Module - MySQL
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

class mysql
{
    # Configuration.
    $mysql_root_password = 'root'
    $mysql_typo3_database = 'typo3'
 
    # Install the mysql-server package.
    package 
    { 
        'mysql-server':
            ensure  => latest,
    }

    # Ensure the mysql service is running.
    service 
    { 
        'mysql':
            enable  => true,
            ensure  => running,
            require => Package['mysql-server'],
    }

    # Set the MySQL root user password.
    exec 
    { 
        'set mysql root password':
            unless  => "mysqladmin -uroot -p$mysql_root_password status",
            command => "mysqladmin -uroot password $mysql_root_password",
            require => 
            [
                Package['mysql-server'],
                Service['mysql'],
            ],
    }
    
    # Grant the MySQL root user all privileges from all locations.
    exec 
    { 
        'grant root all privileges':
            command => "mysql -uroot -p$mysql_root_password --execute=\"GRANT ALL PRIVILEGES ON *.* TO \'root\'@\'%\' IDENTIFIED BY \'$mysql_root_password\'\"",
            unless  => "mysql -uroot -p$mysql_root_password --execute=\"SHOW GRANTS FOR \'root\'@\'%\'\"",
            require => Exec['set mysql root password'],
    }
    
    # Create the default typo3 database onlyif the database does not already exist.
    exec
    {
        'create default typo3 database':
            command => "mysql -uroot -p$mysql_root_password --execute=\"CREATE DATABASE $mysql_typo3_database CHARACTER SET utf8 COLLATE utf8_unicode_ci\"",
            unless  => "mysql -uroot -p$mysql_root_password --execute=\"USE $mysql_typo3_database\"",
            require => Exec['set mysql root password'],
    }

}
