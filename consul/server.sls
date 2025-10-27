{% import_yaml "consul/defaults.yaml" as defaults %}
{%- set consul = salt['pillar.get']('consul', defaults.consul) %}

include:
- consul.install
