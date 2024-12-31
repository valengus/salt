hashicorp:
  pkgrepo.managed:
  - humanname: Hashicorp Stable - $basearch
  - baseurl: https://rpm.releases.hashicorp.com/fedora/$releasever/$basearch/stable
  - gpgcheck: 1
  - gpgkey: https://rpm.releases.hashicorp.com/gpg
