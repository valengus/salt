firewalld:
  pkg.installed:
  - pkgs:
    - firewalld

  service.running:
  - enable: True
  - reload: True

firewalld allow ssh:
  firewalld.service:
  - name: public
  - ports: ["22/tcp"]
