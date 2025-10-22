{% import_yaml "k3s/defaults.yaml" as defaults %}
{%- set k3s = salt['pillar.get']('k3s', defaults.k3s) %}

/var/lib/rancher/k3s/agent/images:
  file.directory:
    - makedirs: True
    - mode: 0755

/usr/local/bin/k3s:
  file.managed:
    - source: "{{ k3s.download_path }}/{{ k3s.version }}/k3s"
    - source_hash: "{{ k3s.download_path }}/{{ k3s.version }}/sha256sum-amd64.txt"
    - user: root
    - group: root
    - mode: 0755

/var/lib/rancher/k3s/agent/images/k3s-airgap-images-amd64.tar.zst:
  file.managed:
    - source: "{{ k3s.download_path }}/{{ k3s.version }}/k3s-airgap-images-amd64.tar.zst"
    - source_hash: "{{ k3s.download_path }}/{{ k3s.version }}/sha256sum-amd64.txt"
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: /var/lib/rancher/k3s/agent/images

/tmp/k3s_install.sh:
  file.managed:
    - source: "https://get.k3s.io"
    - skip_verify: True
    - user: root
    - group: root
    - mode: 0755
