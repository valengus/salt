{% import_yaml "kubernetes/defaults.yaml" as defaults %}
{%- set kubernetes = salt['pillar.get']('kubernetes', defaults.kubernetes) %}

include:
- swap.disabled
- firewalld.disabled
- selinux.disabled
{% if kubernetes.container_runtime  == 'docker' %}
- docker
- docker.cri-dockerd
{% elif kubernetes.container_runtime  == 'containerd' %}
- containerd
{% endif %}
- .prereq
- .install
