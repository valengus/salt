include:
- firewalld.disabled

iptables:
  pkg.installed:
    - pkgs:
      - iptables-utils
      - iptables-nft-services
  service.running:
  - enable: True

IPTABLES | flush INPUT:
  iptables.flush:
  - table: filter
  - chain: INPUT

IPTABLES | flush FORWARD:
  iptables.flush:
  - table: filter
  - chain: FORWARD

IPTABLES | flush OUTPUT:
  iptables.flush:
  - table: filter
  - chain: OUTPUT

# -A INPUT -i lo -j ACCEPT
IPTABLES | lo accept:
  iptables.insert:
  - position: 1
  - table: filter
  - chain: INPUT
  - jump: ACCEPT
  - in-interface: lo
  - save: True

# -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT
IPTABLES | lo reject:
  iptables.insert:
  - position: 2
  - table: filter
  - chain: INPUT
  - jump: REJECT
  - in-interface: "! lo"
  - destination: 127.0.0.0/8
  - save: True

# -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
IPTABLES | INPUT established & related accept:
  iptables.insert:
  - position: 3
  - table: filter
  - chain: INPUT
  - jump: ACCEPT
  - match: state
  - connstate: ESTABLISHED,RELATED
  - save: True

# -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
IPTABLES | FORWARD established & related accept:
  iptables.insert:
  - position: 1
  - table: filter
  - chain: FORWARD
  - jump: ACCEPT
  - match: state
  - connstate: ESTABLISHED,RELATED
  - save: True

# -A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT
IPTABLES | ssh accept:
  iptables.append:
  - table: filter
  - chain: INPUT
  - jump: ACCEPT
  - match: state
  - comment: "Allow SSH"
  - connstate: NEW
  - dport: 22
  - protocol: tcp
  - save: True

# -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
IPTABLES | icmp accept:
  iptables.append:
  - table: filter
  - chain: INPUT
  - jump: ACCEPT
  - match: icmp --icmp-type 8
  - comment: "Allow ICMP"
  - protocol: icmp
  - save: True

# :INPUT DROP
IPTABLES | INPUT default to drop:
  iptables.set_policy:
  - chain: INPUT
  - policy: DROP
  - save: True

# :FORWARD DROP
IPTABLES | FORWARD default to drop:
  iptables.set_policy:
  - chain: FORWARD
  - policy: DROP
  - save: True

# :OUTPUT ACCEPT
IPTABLES | OUTPUT default to accept:
  iptables.set_policy:
  - chain: OUTPUT
  - policy: ACCEPT
  - save: True
