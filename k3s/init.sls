{% import_yaml "k3s/defaults.yaml" as defaults %}
{%- set k3s = salt['pillar.get']('k3s', defaults.k3s) %}

include:
- firewalld.disabled
- selinux.disabled
- docker
- .prereq
- .download

Init k3s master:
  cmd.run:
  - name: /tmp/k3s_install.sh --docker --disable=traefik,servicelb
  - env:
    - INSTALL_K3S_VERSION: "{{ k3s.version }}"
    - INSTALL_K3S_SKIP_DOWNLOAD: "true"
    - K3S_TOKEN: "{{ k3s.token }}"
    - K3S_KUBECONFIG_MODE: "644"
  - unless: systemctl is-active k3s
  - creates: /etc/rancher/k3s/k3s.yaml
