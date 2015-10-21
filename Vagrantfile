#
# Vagrantfile
#
# @copyright  Copyright (c) 2015 stadt.werk GmbH (http://stadtwerk.org)
# @license   http://creativecommons.org/licenses/by-nc-sa/4.0/
#

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |configuration|

    #
    # Shared Configuration
    #
    
    # Fix error message 'stdin: is not a tty' 
    # See: https://github.com/mitchellh/vagrant/issues/1673#issuecomment-28288042
    configuration.ssh.shell = 'bash -c "BASH_ENV=/etc/profile exec bash"'

    # If the 'vagrant-cachier' plugin is installed.
    if Vagrant.has_plugin?('vagrant-cachier')

        # Set cache scope to machine level since we could have multiple machines.
        configuration.cache.scope = :machine
        
        # Make sure that the 'npm' cache bucket is NOT enabled.
        configuration.cache.auto_detect = false
        configuration.cache.enable :apt
        configuration.cache.enable :gem

    end

    # Disable default shared folder.
    configuration.vm.synced_folder '.', '/vagrant', :disabled => true

    # VirtualBox configuration.
    configuration.vm.provider 'virtualbox' do |virtualbox|
        
        # Enable symlinks in shared folders ('v-root' is the default share name).
        # Hint: You need to run Vagrant from a commandline with administrator rights for symlink support on a Windows host machine. 
        virtualbox.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root', '1']

        # Use the host's DNS API to resolve network names instead of the VirtualBox's NAT engine.
        # @see http://askubuntu.com/questions/238040/how-do-i-fix-name-service-for-vagrant-client 
        # @see https://www.virtualbox.org/manual/ch09.html#nat-adv-dns
        virtualbox.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']

    end
    
    #
    # LAMP Server
    #
    configuration.vm.define 'lamp-server', primary: true do |lamp|
        
        # Output system details and memory allocation information on 'up'.
        if (['up'].include? ARGV[0])
            $stdout.puts 'Detected ' + get_host_os.to_s + ' OS with ' + physical_processor_count.to_s  + ' CPUs and ' + physical_memory_count.to_s + ' MB RAM.'
            $stdout.puts 'Allocating ' + get_available_host_memory('lamp').to_s + ' MB RAM to \'lamp-server\'.'
        end
        
        # The name of the base box.
        lamp.vm.box = 'debian-8.2-amd64'
        
        # The url from where the base box will be fetched.
        lamp.vm.box_url = [
            './boxes/debian-8.2-amd64/debian-8.2-amd64-virtualbox.box',
            'http://software.stadtwerk.org/vagrant/box/debian-8.2-amd64-virtualbox.box'
        ]
        
        # The hostname of the virtual machine.
        lamp.vm.hostname = 'lamp-server.local'

        # Create a private network with a static IP.
        lamp.vm.network 'private_network', ip: '10.0.0.42'

        # Synchronize folders between the host and the vagrant machine.
        lamp.vm.synced_folder './provisioning', '/home/vagrant/provisioning'
        lamp.vm.synced_folder './application', '/var/www/application'

        # Execute the bootstrap script on provisioning.
        lamp.vm.provision :shell, :inline => 'bash /home/vagrant/provisioning/bootstrap.bash', keep_color: true
        
        # Apply the puppet manifest on every machine startup as the 'vagrant' user.
        lamp.vm.provision :shell, :inline => 'bash /home/vagrant/provisioning/puppet_apply.bash', keep_color: true, run: 'always'

        # VirtualBox configuration.
        lamp.vm.provider 'virtualbox' do |virtualbox|

            # Name and headless.
            virtualbox.name = 'lamp-server'
            virtualbox.gui = false

            # See http://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm for further options. 
            virtualbox.customize [
                'modifyvm', :id, 
                '--cpus', physical_processor_count, 
                '--memory', get_available_host_memory('lamp'),
                '--cpuexecutioncap', 100
            ]
        end
    end
end

# Get the hosts OS.
def get_host_os
    os = case RbConfig::CONFIG['host_os']
        when /mswin|mingw/
            'Windows'
        when /darwin|mac os/
            'Mac OS X'
        when /linux/
            'Linux'
        else 
            'unknown'
        end
end
                    
# Count physical processors of the host machine.
def physical_processor_count

    # Use different count methods based on the OS.    
    count = case get_host_os

        when 'Windows'
            
            require 'win32ole'
            result_set = WIN32OLE.connect("winmgmts://").ExecQuery("select NumberOfCores from Win32_Processor")
            result_set.to_enum.collect(&:NumberOfCores).reduce(:+)

        when 'Mac OS X'

            IO.popen("/usr/sbin/sysctl -n hw.physicalcpu").read.to_i
   
        when 'Linux'
            
            cores = {}  # unique physical ID / core ID combinations
            phy = 0
            IO.read("/proc/cpuinfo").scan(/^physical id.*|^core id.*/) do |ln|
                if ln.start_with?("physical")
                    phy = ln[/\d+/]
                elsif ln.start_with?("core")
                    cid = phy + ":" + ln[/\d+/]
                    cores[cid] = true if not cores[cid]
                end
            end
            cores.count

        end

    # Fallback to one processor if the count result is false.
    count < 1 ? 1 : count

end

# Count physical memory of the host machine.
def physical_memory_count

    # Use different count methods based on the OS.    
    count = case get_host_os

        when 'Windows'
        
             require 'win32ole'
             capacity = WIN32OLE.connect("winmgmts://").ExecQuery("select Capacity from Win32_PhysicalMemory")
             capacity.to_enum.collect(&:Capacity).map{|string| string.to_i}.inject(:+) / 1024 / 1024

        when 'Mac OS X'
            
            `sysctl -n hw.memsize`.to_i / 1024 / 1024
            
        when 'Linux'
            
            `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024
    end
    
end

# Get the maximum available host memory for a specific machine.
def get_available_host_memory(machine)
    
    # Get total host machine memory.
    total_memory = physical_memory_count

    # Map the available host memory.
    case

        when total_memory >= 4096

            memory = { lamp: 2048 }

        when total_memory >= 3072
                         
            memory = { lamp: 1024 } 
    
        else

            memory = { lamp: 512 }

    end
    
    # Return the maximum memory for the requested machine.
    memory[machine.to_sym]

end
