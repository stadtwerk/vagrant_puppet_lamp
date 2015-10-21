Vagrant Puppet LAMP
==========

A LAMP stack provisioned by Puppet.

Installation
------------

### Install Git, Vagrant and VirtualBox

Download and install the following versions from:

* [Git 2.6.2](http://git-scm.com/)
* [Vagrant 1.7.4](http://www.vagrantup.com/downloads.html)
* [VirtualBox 5.0.8](http://download.virtualbox.org/virtualbox/5.0.8/) 

**Hint:** Newer versions might work, but this setup is confirmed to be stable across all platforms.

### Install vagrant-cachier (optional)

The vagrant-cachier plugin caches common packages which reduces the provisioning time for similar VM instances. Run the following from your console to install it:

    vagrant plugin install vagrant-cachier

### Add DNS entry to your hosts file

Add the following DNS entry to the `hosts` file of your local machine:

    10.0.0.42 local.application-a.de
    10.0.0.42 local.application-b.de

### Clone the repository

Clone this repository to a nice place on your machine via: 

    git clone git@github.com:stadtwerk/vagrant_puppet_lamp.git

Start up
--------

### Start up the machine

Fire up your console at the location you cloned the repository to and create the `lamp-server` machine with:

    vagrant up

### Access the applications

When Vagrant is ready you can access the applications at:

* http://local.application-a.de
* http://local.application-b.de

Development
--------

### Machine

The configuration of the `lamp-server` machine happens within the [`./provisioning`](provisioning/) directory. That directory is automatically synchronized from the host machine to the `/home/vagrant/provisioning` directory on the guest machine. The machine is provisioned in two steps:

**1. Bootstrap**

The [`./provisioning/bootsrap.bash`](provisioning/bootsrap.bash) prepares the `lamp-server` machine to be provisioned with Puppet. It is executed once on the initial machine start up. It can be called manually with: 

    sudo bash bootstrap.bash 

**2. Puppet**

The [`./provisioning/puppet_apply.bash`](provisioning/puppet_apply.bash) applies the [`lamp.pp`](provisioning/puppet/manifests/lamp.pp) Puppet manifest. It is executed on every machine start up. It can be called manually with:

    sudo bash puppet_apply.bash

### Application

All application development happens within the [`./application`](application/) directory. That directory is automatically synchronized from the host machine to the `/var/www/application` directory on the guest machine.

### Database

You can access MySQL at `10.0.0.42:3306` with the user name and password `root`.

Shut down
---------
There are three ways to stop the running `lamp-server` machine:

* Suspend with `vagrant suspend`
* Shutdown with `vagrant halt`
* Delete the virtual machine with `vagrant destroy`


License
-----------
This project is licensed under the [Creative Commons - Attribution-NonCommercial-ShareAlike 4.0 International](http://creativecommons.org/licenses/by-nc-sa/4.0/).
