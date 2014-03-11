# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
$vm_memory ||= "4096"
$vm_cpus ||= "4"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Make box
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  # Sync app folders
  config.vm.synced_folder "./", "/home/vagrant/Course-Coda/"
  # Ports
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.ssh.forward_agent = true
  # Config management
  config.vm.synced_folder "salt/roots/", "/srv/"
  config.vm.provision :salt do |salt|
      salt.minion_config = "salt/minion.conf"
      salt.verbose = true
      salt.run_highstate = false
  end
  # Bootstrap
  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vbguest.auto_update = true
end
