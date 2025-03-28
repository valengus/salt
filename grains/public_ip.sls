include:
- .reload_grains

{% set public_ip = salt['http.query']('https://api.ipify.org') %}

public_ip:
  grains.present:
  - value: {{ public_ip.body }}
  - watch_in: [ reload grains ]
