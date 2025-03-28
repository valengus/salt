include:
- git
- repo.salt
- python3

salt-minion-masterless:
  pkg.installed:
  - name: salt-minion
  - require:
    - file: /etc/yum.repos.d/salt.repo

  pip.installed:
  - name: gitpython
  - pip_bin: /usr/bin/salt-pip
