overlay:
  kmod.present:
  - persist: True

br_netfilter:
  kmod.present:
  - persist: True

net.bridge.bridge-nf-call-ip6tables:
  sysctl.present:
  - value: 1

net.bridge.bridge-nf-call-iptables:
  sysctl.present:
  - value: 1

net.ipv4.ip_forward:
  sysctl.present:
  - value: 1
