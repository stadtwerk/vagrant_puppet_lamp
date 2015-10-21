Debian 8.2 Base Box
===================

A guide on how to prepare an Debian 8.2 for the usage with Vagrant.

### Install Packer

Download and install the latest version from:

* [Packer](http://www.packer.io/downloads.html)

Make sure the directory you installed Packer to is on the `PATH` variable.

### Build debian-8.2-amd64-virtualbox.box

Fire up your console at `./debian-8.2-amd64` and execute

    packer build debian-8.2-amd64-virtualbox.json

License
-----------
This project is licensed under the [Creative Commons - Attribution-NonCommercial-ShareAlike 4.0 International](http://creativecommons.org/licenses/by-nc-sa/4.0/).
 