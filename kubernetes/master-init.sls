{% import_yaml "kubernetes/defaults.yaml" as defaults %}
{%- set kubernetes = salt['pillar.get']('kubernetes', defaults.kubernetes) %}

include:
- kubernetes

Kubernetes master init:
  cmd.run:
    - name: >
        kubeadm init 
        --token {{ kubernetes.initToken }} 
        --cri-socket unix:///var/run/cri-dockerd.sock 
        --pod-network-cidr={{ kubernetes.podNetworkCidr }} 
        # --control-plane-endpoint "haproxy:6443" --cri-socket unix:///run/containerd/containerd.sock
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

Flannel CNI:
  cmd.run:
    - name: kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
    - unless: kubectl get pods -n kube-flannel 2>/dev/null | grep -q flannel
    - env:
      - KUBECONFIG: "/etc/kubernetes/admin.conf"
    - require:
      - cmd: Kubernetes master init

Kubernetes master untaint:
  cmd.run:
    - name: kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true
    - env:
      - KUBECONFIG: "/etc/kubernetes/admin.conf"
    - require:
      - cmd: Kubernetes master init

# Kubernetes dashboard:
#   cmd.run:
#     - name: kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
#     - unless: kubectl get pods -n kubernetes-dashboard  2>/dev/null | grep -q dashboard
#     - env:
#       - KUBECONFIG: "/etc/kubernetes/admin.conf"
#     - require:
#       - cmd: Kubernetes master init
