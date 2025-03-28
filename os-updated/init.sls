include:
- reboot

{% if salt['grains.get']('os-updated') != True %}

update pkgs:
  pkg.uptodate:
  - refresh : True
  grains.present:
  - name: os-updated
  - value: True
  - watch_in: [ reboot ]

{% endif %}
