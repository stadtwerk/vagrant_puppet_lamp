#
# environment.sh
#
# @copyright Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

# Export LAMP_SERVER_ENVIRONMENT environment variable.
export LAMP_SERVER_ENVIRONMENT=development

# The default path for every shell on the machine.
default_path='/home/vagrant/provisioning'

# Check if the directory exists.
if [ ! -d "$default_path" ]; then
    echo "The default path '${default_path}' does not yet exist."
else
    cd $default_path
fi
