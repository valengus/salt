include:
- selinux.policycoreutils

haproxy:
  pkg.installed:
    - name: haproxy

  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - contents: |
        global
            log         127.0.0.1 local2

            chroot      /var/lib/haproxy
            pidfile     /var/run/haproxy.pid
            maxconn     4000
            user        haproxy
            group       haproxy
            daemon

            # turn on stats unix socket
            stats socket /var/lib/haproxy/stats

            # utilize system-wide crypto-policies
            ssl-default-bind-ciphers PROFILE=SYSTEM
            ssl-default-server-ciphers PROFILE=SYSTEM

        defaults
            mode                    http
            log                     global
            option                  httplog
            option                  dontlognull
            option http-server-close
            option forwardfor       except 127.0.0.0/8
            option                  redispatch
            retries                 3
            timeout http-request    10s
            timeout queue           1m
            timeout connect         10s
            timeout client          1m
            timeout server          1m
            timeout http-keep-alive 10s
            timeout check           10s
            maxconn                 3000
    
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - pkg: haproxy

  selinux.boolean:
    - name: haproxy_connect_any
    - value: True
    - persist: True

  service.running:
    - name: haproxy
    - enable: True
    - watch:
      - file: /etc/haproxy/haproxy.cfg
    - require: 
      - selinux: haproxy_connect_any
