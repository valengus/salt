include:
- haproxy
- iptables

{% set kube_api_servers = [
    {'name': 'k8s-01', 'host': 'k8s-01.local'},
] %}
{% set api_port = 6443 %}

IPTABLES | Allow haproxy frontend kubernetes-api:
  iptables.append:
  - table: filter
  - chain: INPUT
  - jump: ACCEPT
  - comment: "Allow haproxy frontend kubernetes-api"
  - dport: "{{ api_port }}"
  - protocol: tcp
  - save: True

haproxy-k8s-api-config:
  file.managed:
    - name: /etc/haproxy/conf.d/k8s-api.cfg
    - contents: |
        frontend kubernetes-api-frontend
            bind *:{{ api_port }}
            mode tcp
            option tcplog
            default_backend kubernetes-api-backend

        backend kubernetes-api-backend
            mode tcp
            balance roundrobin
            option tcp-check
        {% for srv in kube_api_servers %}
            server {{ srv.name }} {{ srv.host }}:{{ api_port }} check
        {% endfor %}

    - user: root
    - group: root
    - mode: '0644'
    - require:
      - pkg: haproxy
    - watch_in: 
      - service: haproxy
