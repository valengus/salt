# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

$installSalt= <<-SCRIPT
curl -L https://bootstrap.saltproject.io/bootstrap-salt.sh | sudo sh -s -- -F stable 3007
dnf config-manager setopt salt-repo-3007-sts.enabled=1
dnf config-manager setopt salt-repo-3006-lts.enabled=0
dnf update salt-minion -y
salt-call --local state.apply virtualbox pillar='{"username": "vagrant"}'
SCRIPT

Vagrant.configure("2") do |config|

  config.vm.define "fedora" do |config|
    config.vm.box      = "fedora/41-cloud-base"
    config.vm.hostname = "fedora"
    config.vm.provider :libvirt do |libvirt|
      libvirt.driver           = "kvm"
      libvirt.qemu_use_session = false
      libvirt.cpus             = 4
      libvirt.memory           = 8 * 1024
    end
    config.vm.synced_folder ".", "/srv/salt", type: "nfs", nfs_version: 4, nfs_udp: false
    config.vm.provision "shell", inline: $installSalt
  end

end
