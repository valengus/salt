libvirt:
  module.run:
  - pkg.install:
    - name: '@virtualization'

  pkg.installed:
  - pkgs:
    - qemu-kvm 
    - libvirt 
    - virt-win-reg
    - virt-install
    - libvirt-devel
    - libvirt-daemon-kvm 

  group.present:
  - system: True
  - addusers:
    - {{ pillar['username'] }}

  service.running:
  - name: libvirtd
  - enable: True
  - reload: True
  - watch:
    - group: libvirt
