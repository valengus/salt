include:
- repo.salt
- python3
- git

salt-master:
  pkg.installed:
  - version: "3007.8-0"
  - require:
    - file: /etc/yum.repos.d/salt.repo

  pip.installed:
  - name: gitpython
  - pip_bin: /usr/bin/salt-pip
