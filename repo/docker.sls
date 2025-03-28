docker-ce-stable:
  pkgrepo.managed:
  - name: docker-ce-stable
  - humanname: Docker CE Stable - $basearch
  - gpgcheck: 1
  - baseurl: https://download.docker.com/linux/centos/$releasever/$basearch/stable
  - gpgkey: https://download.docker.com/linux/centos/gpg
