include:
- python3
- repo.docker

podman:
  pkg.removed: []

moby-engine:
  pkg.removed: []

docker:
  pkg.installed:
  - pkgs:
    - docker-ce 
    - docker-ce-cli 
    - containerd.io
  - require:
    - pkgrepo: docker-ce-stable
    - pkg: podman

  pip.installed:
  - name: docker
  - require: 
    - pkg: python3-pip
  - pip_bin: /usr/bin/pip3

  group.present:
  - members:
    - {{ pillar['username'] }}

  service.running:
  - name: docker
  - enable: True
  - reload: True
  - watch:
    - group: docker
