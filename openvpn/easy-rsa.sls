{% import_yaml "openvpn/defaults.yaml" as defaults %}
{%- set openvpn = salt['pillar.get']('openvpn', defaults.openvpn) %}

include:
- repo.epel

easy-rsa:
  pkg.installed: []

/etc/openvpn:
  file.directory:
    - user: root
    - group: root

"{{ openvpn.easyrsa_dir }}":
  file.directory:
    - user: root
    - group: root

"{{ openvpn.keys_dir }}":
  file.directory:
    - user: root
    - group: root

easy-rsa | create PKI dir:
  cmd.run:
  - name: "{{ openvpn.easyrsa_path }}/easyrsa init-pki"
  - cwd: "{{ openvpn.easyrsa_dir }}"
  - creates: "{{ openvpn.easyrsa_dir }}/pki"
  - require:
    - pkg: easy-rsa
    - file: "{{ openvpn.easyrsa_dir }}"

easy-rsa | generate CA keypair & cert:
  cmd.run:
  - name: "{{ openvpn.easyrsa_path }}/easyrsa build-ca nopass"
  - cwd: "{{ openvpn.easyrsa_dir }}"
  - creates: 
    - "{{ openvpn.easyrsa_dir }}/pki/ca.crt"            # root ca cert
    - "{{ openvpn.easyrsa_dir }}/pki/private/ca.key"    # root ca key
  - env:
    - EASYRSA_BATCH: 'yes'
  - require:
    - cmd: "{{ openvpn.easyrsa_path }}/easyrsa init-pki"

easy-rsa | generate Diffie-Hellman keys:
  cmd.run:
  - name: "{{ openvpn.easyrsa_path }}/easyrsa gen-dh"
  - cwd: "{{ openvpn.easyrsa_dir }}"
  - creates: "{{ openvpn.easyrsa_dir }}/pki/dh.pem"
  - require:
    - cmd: "{{ openvpn.easyrsa_path }}/easyrsa build-ca nopass"

easy-rsa | generate server {{ openvpn.easyrsa_server_name }} key:
  cmd.run:
  - name: "{{ openvpn.easyrsa_path }}/easyrsa build-server-full {{ openvpn.easyrsa_server_name }} nopass"
  - cwd: "{{ openvpn.easyrsa_dir }}"
  - creates: 
    - "{{ openvpn.easyrsa_dir }}/pki/issued/{{ openvpn.easyrsa_server_name }}.crt"
    - "{{ openvpn.easyrsa_dir }}/pki/private/{{ openvpn.easyrsa_server_name }}.key"
  - env:
    - EASYRSA_BATCH: 'yes'
  - require:
    - cmd: "{{ openvpn.easyrsa_path }}/easyrsa build-ca nopass"

"{{ openvpn.keys_dir }}/ca.crt":
  file.symlink:
  - target: "{{ openvpn.easyrsa_dir }}/pki/ca.crt"

"{{ openvpn.keys_dir }}/dh.pem":
  file.symlink:
  - target: "{{ openvpn.easyrsa_dir }}/pki/dh.pem"

"{{ openvpn.keys_dir }}/{{ openvpn.easyrsa_server_name }}.crt":
  file.symlink:
  - target: "{{ openvpn.easyrsa_dir }}/pki/issued/{{ openvpn.easyrsa_server_name }}.crt"

"{{ openvpn.keys_dir }}/{{ openvpn.easyrsa_server_name }}.key":
  file.symlink:
  - target: "{{ openvpn.easyrsa_dir }}/pki/private/{{ openvpn.easyrsa_server_name }}.key"
