{% import_yaml "openvpn/defaults.yaml" as defaults %}
{%- set openvpn = salt['pillar.get']('openvpn', defaults.openvpn) %}

{% set public_ip = salt['http.query']('https://api.ipify.org')['body'] %}

print public_ip:
  test.show_notification:
  - text: "{{ public_ip }}"

/etc/openvpn/clients:
  file.directory: []

{% for user in openvpn.users %}

vpn user {{ user.name }}:
  user.present:
  - name: {{ user.name }}
  - shell: /sbin/nologin
  - password: {{ user.password }}
  - hash_password: True

/etc/openvpn/clients/{{ user.name }}.ovpn:
  file.managed:
  - source: salt://openvpn/client.ovpn
  - template: jinja
  - context:
      openvpn: {{ openvpn }}
      user: {{ user }}
      connect_to: {{ openvpn.connect_to | default(public_ip) }}

{% endfor %}
