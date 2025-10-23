python3:
  pkg.installed: []

python3-pip:
  pkg.installed: []

pip:
  pip.installed:
  - upgrade: True
  - pip_bin: /usr/bin/pip3
  - require:
    - pkg: python3-pip

setuptools:
  pip.installed:
  - pip_bin: /usr/bin/pip3
  - require:
    - pip: pip
