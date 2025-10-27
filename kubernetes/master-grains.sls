{% import_yaml "kubernetes/defaults.yaml" as defaults %}
{%- set kubernetes = salt['pillar.get']('kubernetes', defaults.kubernetes) %}

include:
- grains.reload_grains

{% set k8s_certificate_key = salt['cmd.run']('kubeadm init phase upload-certs --upload-certs') %}
{% set k8s_token = salt['cmd.run']('kubeadm token create --ttl 2h') %}
{% set k8s_ca_cert_hash = salt['cmd.run']("openssl x509 -in /etc/kubernetes/pki/ca.crt -pubkey -noout | openssl pkey -pubin -outform DER | openssl dgst -sha256 | awk '{print $2}'", python_shell=True) %}

k8s_token:
  grains.present:
  - value: {{ k8s_token }}
  - watch_in: [ reload grains ]

k8s_certificate_key:
  grains.present:
  - value: {{ k8s_certificate_key.splitlines()[-1] }}
  - watch_in: [ reload grains ]

k8s_ca_cert_hash:
  grains.present:
  - value: {{ k8s_ca_cert_hash }}
  - watch_in: [ reload grains ]
