include:
- repo.kubernetes

kubelet:
  pkg.installed:
  - require:
    - pkgrepo: kubernetes

  service.enabled:
  - name: kubelet
  - require:
    - pkg: kubelet

kubeadm:
  pkg.installed:
  - require:
    - pkgrepo: kubernetes

kubectl:
  pkg.installed:
  - require:
    - pkgrepo: kubernetes
