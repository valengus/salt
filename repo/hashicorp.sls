hashicorp:
  pkgrepo.managed:
  - name: hashicorp
  - humanname: Hashicorp Stable - $basearch
  - gpgcheck: 1
  - baseurl: https://rpm.releases.hashicorp.com/RHEL/$releasever/$basearch/stable
  - gpgkey: https://rpm.releases.hashicorp.com/gpg
