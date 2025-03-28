{% import_yaml "openvpn/defaults.yaml" as defaults %}
{%- set openvpn = salt['pillar.get']('openvpn', defaults.openvpn) %}

{% set default_network_interface = salt['cmd.shell']("ip route | grep default | awk '{print $5}'") %}

net.ipv4.ip_forward:
  sysctl.present:
  - value: 1

"{{ openvpn.log_directory }}":
  file.directory: []

openvpn:
  pkg.installed: []

  file.managed:
  - name: /etc/openvpn/server/server.conf
  - source: salt://openvpn/server.conf
  - template: jinja
  - user: root
  - group: openvpn
  - mode: 640
  - context:
      openvpn: {{ openvpn }}

  service.running:
  - name: openvpn-server@server
  - enable: True
  - watch:
    - file: /etc/openvpn/server/server.conf

IPTABLES | OPENVPN accept:
  iptables.append:
  - table: filter
  - chain: INPUT
  - jump: ACCEPT
  - comment: "Allow OPENVPN"
  - dport: {{ openvpn.port }}
  - protocol: {{ openvpn.proto }}
  - save: True

IPTABLES | Allow forward from tun+:
  iptables.append:
  - table: filter
  - chain: FORWARD
  - jump: ACCEPT
  - comment: "Allow FORWARD from tun+"
  - in-interface: "tun+"
  - save: True

IPTABLES | NAT over {{ openvpn.nat_to | default(default_network_interface) }}:
  iptables.append:
  - table: nat
  - chain: POSTROUTING
  - jump: MASQUERADE
  - out-interface: {{ openvpn.nat_to | default(default_network_interface) }}
