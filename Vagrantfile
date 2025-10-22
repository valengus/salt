# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

$installSalt= <<-SCRIPT
sudo dnf install -y git python3 python3-pip
export BOOTSTRAP_SALT="https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh"
curl -L $BOOTSTRAP_SALT | sudo sh -s -- stable
sudo salt-pip install gitpython
sudo salt-call --local state.apply python3
SCRIPT

Vagrant.configure("2") do |config|

  # config.vm.define "salt" do |config|
  #   config.vm.box      = "generic/oracle9"
  #   config.vm.hostname = "k3s"
  #   config.vm.hostname = "salt"
  #   config.vm.provider :libvirt do |libvirt|
  #     libvirt.driver                    = "kvm"
  #     libvirt.qemu_use_session          = false
  #     libvirt.cpus                      = 2
  #     libvirt.memory                    = 4 * 1024
  #     libvirt.default_prefix            = 'vagrant_'
  #     libvirt.management_network_name   = 'vagrant'
  #     libvirt.management_network_domain = 'local'
  #   end
  #   config.vm.synced_folder '.', '/vagrant', disabled: true
  #   config.vm.synced_folder '.', "/srv/salt", type: "nfs", nfs_version: 4, nfs_udp: false
  #   config.vm.provision "shell", inline: $installSalt
  # end

  config.vm.define "k3s" do |config|
    config.vm.box      = "generic/oracle9"
    config.vm.hostname = "k3s"
    config.vm.provider :libvirt do |libvirt|
      libvirt.driver                    = "kvm"
      libvirt.qemu_use_session          = false
      libvirt.cpus                      = 2
      libvirt.memory                    = 4 * 1024
      libvirt.default_prefix            = 'vagrant_'
      libvirt.management_network_name   = 'vagrant'
      libvirt.management_network_domain = 'local'
    end
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder '.', "/srv/salt", type: "nfs", nfs_version: 4, nfs_udp: false
    config.vm.provision "shell", inline: $installSalt
  end

  # config.vm.define "windows" do |config|
  #   config.vm.box      = "valengus/windows-2022-standard"
  #   config.vm.provider :libvirt do |libvirt|
  #     libvirt.driver           = "kvm"
  #     libvirt.qemu_use_session = false
  #     libvirt.cpus             = 2
  #     libvirt.memory           = 4 * 1024
  #     libvirt.management_network_name   = 'vagrant'
  #     libvirt.management_network_domain = 'local'
  #   end
  # end

end
