kernel-uek-modules-extra:
  pkg.installed:
  - version: "{{ salt['grains.get']('kernelrelease').rsplit('.', 1)[0] }}"
