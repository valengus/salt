salt-master service:

  file.managed:
  - name: /etc/salt/master
  - source: salt://salt-master/master
  - template: jinja
  - user: root
  - group: root
  - mode: 644

  service.running:
  - name: salt-master
  - enable: True
  - watch:
    - file: /etc/salt/master
    - file: /etc/salt/autosign_grains/uuid

  iptables.append:
  - table: filter
  - chain: INPUT
  - jump: ACCEPT
  - comment: "Allow SALT-MASTER"
  - dports: 
    - 4505
    - 4506
  - protocol: tcp
  - save: True

/etc/salt/autosign_grains/uuid:
  file.managed:
  - makedirs: True
  - contents: |
      {{ salt['grains.get']('uuid') }}
