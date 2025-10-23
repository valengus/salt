include:
- grains.reload_grains

{% set k8s_certificate_key = salt['cmd.run']('kubeadm init phase upload-certs --upload-certs') %}

k8s_certificate_key:
  grains.present:
  - value: {{ k8s_certificate_key.splitlines()[-1] }}
  - watch_in: [ reload grains ]
