{% import_yaml "kubernetes/defaults.yaml" as defaults %}
{%- set kubernetes = salt['pillar.get']('kubernetes', defaults.kubernetes) %}

include:
- kubernetes

Kubernetes master init:
  cmd.run:
    - name: >
        kubeadm init
        --token {{ kubernetes.init_token }}
        --pod-network-cidr={{ kubernetes.pod_network_cidr }}
        {% if kubernetes.container_runtime  == 'docker' %}--cri-socket unix:///var/run/cri-dockerd.sock{% elif kubernetes.container_runtime  == 'containerd' %}--cri-socket unix:///run/containerd/containerd.sock{% endif %}
        {% if kubernetes.control_plane_endpoint %}--control-plane-endpoint "{{ kubernetes.control_plane_endpoint }}"{% endif %}
    - creates: /etc/kubernetes/admin.conf

Kubernetes config dir:
  file.directory:
    - name: /root/.kube
    - user: root
    - group: root
    - mode: 755

Kubernetes config:
  file.copy:
    - name: /root/.kube/config
    - source: /etc/kubernetes/admin.conf
    - user: root
    - group: root
    - mode: 600
    - require:
      - cmd: Kubernetes master init
      - file: /root/.kube

Calico:
  cmd.run:
  - name: kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
  - unless: kubectl get pods -n kube-system | grep -q calico
  - env:
    - KUBECONFIG: "/etc/kubernetes/admin.conf"
  - require:
    - cmd: Kubernetes master init

# Flannel CNI:
#   cmd.run:
#     - name: kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
#     - unless: kubectl get pods -n kube-flannel | grep -q flannel
#     - env:
#       - KUBECONFIG: "/etc/kubernetes/admin.conf"
#     - require:
#       - cmd: Kubernetes master init

Kubernetes master untaint:
  cmd.run:
    - name: kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true
    - env:
      - KUBECONFIG: "/etc/kubernetes/admin.conf"
    - require:
      - cmd: Kubernetes master init
