## Define variables
VAGRANTFILE_API_VERSION = 2
VM_BOX_NAME = "basic-base"

# Specify the minimum Vagrant version
Vagrant.require_version ">= 1.4.2"

## Check for the required plugins
unless Vagrant.has_plugin?("vagrant-list")
	raise "Vagrant-list plugin is not installed!"
end
unless Vagrant.has_plugin?("vagrant-vbguest")
	raise "Vagrant-vbguest plugin is not installed!"
end

## Configure the vagrant virtual machine
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	# Define the "buildpack" VM and set it as the primary machine
	config.vm.define "buildpack", primary: true do |buildpack|
		# Define the base box to use.
		buildpack.vm.box = VM_BOX_NAME

		# Share an additional folder to the guest VM.
		#buildpack.vm.synced_folder "./data", "/vagrant_data"

		# Enable provisioning with a shell script.
		#buildpack.vm.provision "shell", path: "data/buildpack_install.sh"

		# Configure network
		#buildpack.vm.network "private_network", ip: "192.168.50.1"
		#buildpack.vm.network "forwarded_port", guest: 8000, host: 8088  # Web server
	end

	#### Set common VM settings ####
	## vagrant-vbguest plugin configuration ##
	# The VBoxGuestAdditions.iso path should be auto-detected.
	# However, if this fails then it can be specified by:
	#config.vbguest.iso_path = "#{ENV['HOME']}/Downloads/VBoxGuestAdditions.iso"
	# or
	#config.vbguest.iso_path = "http://company.server/VirtualBox/%{version}/VBoxGuestAdditions.iso"

	# Set auto_update to false if you do NOT want to check the correct 
	# additions version when booting this machine.
	config.vbguest.auto_update = true

	# Do NOT download the iso file from a webserver.
	config.vbguest.no_remote = true

	config.vm.provider "virtualbox" do |vb|
		# Set memory to 512MB to match Heroku limits.
		vb.customize [
			"modifyvm", :id, 
			"--memory", "512",
			"--cpus", "2"
		]
	end
end