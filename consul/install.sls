{% import_yaml "consul/defaults.yaml" as defaults %}
{%- set consul = salt['pillar.get']('consul', defaults.consul) %}

consul:
  user.present:
  - fullname: Consul service user
  - shell: /bin/false
  - home: {{ consul.data_dir }}
  - createhome: True

  group.present:
  - addusers:
    - consul
  - require: 
    - user: consul

/opt/consul_{{ consul.version }}_{{ consul.platform }}:
  file.directory:
  - user: consul
  - group: consul
  - mode: 0750
  - makedirs: True

  archive.extracted:
  - source: https://releases.hashicorp.com/consul/{{ consul.version }}/consul_{{ consul.version }}_{{ consul.platform }}.zip
  - source_hash: https://releases.hashicorp.com/consul/{{ consul.version }}/consul_{{ consul.version }}_SHA256SUMS
  - enforce_toplevel: False
  - if_missing: /opt/consul_{{ consul.version }}_{{ consul.platform }}/consul

/usr/bin/consul:
  file.symlink:
  - target: /opt/consul_{{ consul.version }}_{{ consul.platform }}/consul
  - force: True
  - require:
    - archive: /opt/consul_{{ consul.version }}_{{ consul.platform }}

{{ consul.etc_dir }}:
  file.directory:
  - user: consul
  - group: consul
  - mode: 0755
  - makedirs: True

{{ consul.data_dir }}:
  file.directory:
  - user: consul
  - group: consul
  - mode: 0755
  - makedirs: True

{{ consul.log_dir }}:
  file.directory:
  - user: consul
  - group: consul
  - mode: 0755
  - makedirs: True
