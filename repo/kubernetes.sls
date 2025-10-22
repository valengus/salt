kubernetes:
  pkgrepo.managed:
  - name: kubernetes
  - humanname: Kubernetes Repository
  - baseurl: https://pkgs.k8s.io/core:/stable:/v1.34/rpm/
  - enabled: 1
  - gpgcheck: 1
  - gpgkey: https://pkgs.k8s.io/core:/stable:/v1.34/rpm/repodata/repomd.xml.key
