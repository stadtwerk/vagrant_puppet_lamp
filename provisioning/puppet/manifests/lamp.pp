#
# lamp.pp
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

# Set default path for all exec calls.
Exec {
    path => ['/bin', '/usr/bin', '/sbin', '/usr/sbin']
}

# Define the first stage.
stage {
    
    # The first stage runs before the second stage.
    'first': before => Stage['second'],
}

# Define the second stage.
stage {

    # The second stage runs before the main stage.
    'second': before => Stage['main'],
}

# Run the first stage.
class {
    [
        'bootstrap',
        'locale',
        'swap',
    ]:
        stage => 'first',
}

# Run the second stage.
class {
    [
        'environment',
        'common',
        'htop',
        'openssh',
    ]:
        stage => 'second',
}

# Run the main stage.
class {
    [
        'apache',
        'php',
        'mysql',
        'composer',
        'imagemagick',
        'phpmyadmin',
    ]:
        stage => 'main',
}
