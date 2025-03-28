{% import_yaml "salt-minion/defaults.yaml" as defaults %}
{%- set saltminion = salt['pillar.get']('saltminion', defaults.saltminion) %}

include:
- repo.salt
- python3

/etc/salt/minion.d/autosign_grains.conf:
  file.managed:
    - contents: |
        autosign_grains:
        - uuid

salt-minion:
  pkg.installed:
  - name: salt-minion
  - version: {{ saltminion.version }}
  - require:
    - file: /etc/yum.repos.d/salt.repo

  file.managed:
  - name: /etc/salt/minion
  - source: salt://salt-minion/minion
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - context:
      saltminion: {{ saltminion }}

  service.running:
  - name: salt-minion
  - enable: True
  - require:
    - pkg: salt-minion
  - require:
    - file: /etc/salt/minion.d/autosign_grains.conf
  - watch:
    - file: /etc/salt/minion

  schedule.present:
  - function: state.apply
  - job_args:
    - salt-master.minion
  - seconds: 3600
  - splay: 300
  - retry:
      attempts: 5
      interval: 5
      until: True

salt-minion-masterless:
  schedule.absent: []
