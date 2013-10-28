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
  #ruby/rvm
  config.vm.provision :shell, :path => "install-rvm.sh",  :args => "stable"
  config.vm.provision :shell, :path => "install-ruby.sh", :args => "1.9.3"
  # Sync app folders
  config.vm.synced_folder "./", "/home/vagrant/Northwestern-CTECS/"
  # Ports
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.ssh.forward_agent = true
  # Config management
  config.vm.synced_folder "salt/roots/", "/srv/"
  config.vm.provision :salt do |salt|
      salt.minion_config = "salt/minion.conf"
      salt.verbose = true
      salt.run_highstate = true
  end
  # Bootstrap
  config.vm.provision :shell, :path => "bootstrap.sh"
  $script = <<SCRIPT
chmod u+x /vagrant/bootstrap-user.sh
sudo -u vagrant /vagrant/bootstrap-user.sh
SCRIPT
  config.vm.provision :shell, :inline => $script
end
