include:
- kernel
- repo.rpmfusion

VirtualBox:
  pkg.installed:
  - require: 
    - pkg: kernel-devel

akmod-VirtualBox:
  pkg.installed:
  - require: 
    - pkg: VirtualBox

vboxusers:
  group.present:
  - system: True
  - addusers:
    - {{ pillar['username'] }}
  - require: 
    - pkg: VirtualBox

{% set vboxdrv_is_loaded = salt['kmod.is_loaded']('vboxdrv') %}

{% if vboxdrv_is_loaded != True %}
'akmods --kernels $(uname -r)':
  cmd.run:
    - require: 
      - pkg: akmod-VirtualBox
      - pkg: kernel-devel
{% endif %}
