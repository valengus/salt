virtualbox:
  pkgrepo.managed:
    - humanname: "Fedora $releasever - $basearch - VirtualBox"
    - baseurl: http://download.virtualbox.org/virtualbox/rpm/fedora/{{ salt['grains.get']('osrelease') }}/$basearch
    - gpgcheck: 1
    - gpgkey: https://www.virtualbox.org/download/oracle_vbox.asc
