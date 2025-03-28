{% if grains['os'] == 'OEL' %}

oracle-epel-release-el{{ salt['grains.get']('osmajorrelease') }}:
  pkg.installed: []

{% endif %}
