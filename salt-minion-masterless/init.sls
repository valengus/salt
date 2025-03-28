include:
- .install

salt-minion-masterless config:

  file.managed:
  - name: /etc/salt/minion
  - source: salt://salt-minion-masterless/minion
  - user: root
  - group: root
  - mode: 644

  service.running:
  - name: salt-minion
  - enable: True
  - require:
    - pkg: salt-minion
  - watch:
    - file: /etc/salt/minion

  schedule.present:
  - name: salt-minion-masterless
  - function: state.apply
  - job_args:
    - salt-minion
  - seconds: 3600
  - splay: 300
  - require:
    - service: salt-minion
  - retry:
      attempts: 5
      interval: 5
      until: True

salt-minion:
  schedule.absent: []
