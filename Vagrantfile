# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

$installSalt= <<-SCRIPT
sudo dnf install -y git python3 python3-pip
export BOOTSTRAP_SALT="https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh"
curl -L $BOOTSTRAP_SALT | sudo sh -s -- stable
sudo salt-pip install gitpython
sudo salt-call --local state.apply default-pkgs
SCRIPT

Vagrant.configure("2") do |config|

  # ===== DEFAULTS =====
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder '.', "/srv/salt", type: "nfs", nfs_version: 4, nfs_udp: false
  config.vm.provision "shell", inline: $installSalt
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver                    = "kvm"
    libvirt.qemu_use_session          = false
    libvirt.cpus                      = 2
    libvirt.memory                    = 2 * 1024
    libvirt.default_prefix            = 'vagrant_'
    libvirt.management_network_name   = 'vagrant-network'
    libvirt.management_network_domain = 'local'
    libvirt.management_network_keep   = true
  end

  # config.vm.define "salt" do |config|
  #   config.vm.box      = "generic/oracle9"
  #   config.vm.hostname = "salt"
  # end

  # config.vm.define "haproxy" do |config|
  #   config.vm.box      = "generic/oracle9"
  #   config.vm.hostname = "haproxy"
  #   config.vm.provider :libvirt do |libvirt|
  #     libvirt.cpus                      = 1
  #     libvirt.memory                    = 2 * 1024
  #   end
  #     config.vm.provision "shell", inline: <<-SHELL
  #       salt-call --local state.apply kubernetes.haproxy
  #     SHELL
  # end

  $k8s_num_instances ||= 1
  (1..$k8s_num_instances).each do |i|
    config.vm.define "k8s-0#{i}" do |config|
      config.vm.hostname = "k8s-0#{i}"
      config.vm.box      = "generic/oracle9"
      config.vm.provision "shell", inline: <<-SHELL
        salt-call --local state.apply kubernetes
      SHELL
      if i == 1
        config.vm.provision "shell", inline: <<-SHELL
          salt-call --local state.apply kubernetes.master-init
        SHELL
      end
    end
  end

  # $consul_num_instances ||= 2
  # (1..$consul_num_instances).each do |i|
  #   config.vm.define "consul-0#{i}" do |config|
  #     config.vm.hostname = "consul-0#{i}"
  #     config.vm.box      = "generic/oracle9"
  #     config.vm.provision "shell", inline: <<-SHELL
  #       salt-call --local state.apply consul.server
  #     SHELL
  #   end
  # end

end
