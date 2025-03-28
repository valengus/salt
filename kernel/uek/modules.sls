kernel-uek-modules:
  pkg.installed:
  - version: "{{ salt['grains.get']('kernelrelease').rsplit('.', 1)[0] }}"
