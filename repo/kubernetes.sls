{% import_yaml "kubernetes/defaults.yaml" as defaults %}
{%- set kubernetes = salt['pillar.get']('kubernetes', defaults.kubernetes) %}

kubernetes:
  pkgrepo.managed:
  - name: kubernetes
  - humanname: Kubernetes Repository
  - baseurl: https://pkgs.k8s.io/core:/stable:/v{{ kubernetes.version }}/rpm/
  - enabled: 1
  - gpgcheck: 1
  - gpgkey: https://pkgs.k8s.io/core:/stable:/v{{ kubernetes.version }}/rpm/repodata/repomd.xml.key
