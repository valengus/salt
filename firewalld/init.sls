firewalld:
  pkg.installed:
  - pkgs:
    - firewalld
  
  service.running:
  - enable: True
  - reload: True
