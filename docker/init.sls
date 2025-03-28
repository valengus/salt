{% import_yaml "docker/defaults.yaml" as defaults %}
{%- set docker = salt['pillar.get']('docker', defaults.docker) %}

include:
- python3
- repo.docker

podman:
  pkg.removed: []

moby-engine:
  pkg.removed: []

docker:
  group.present:
  - addusers:
{% for user in docker.users %}
    - {{ user }}
{% endfor %}

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
  - pip_bin: /usr/bin/salt-pip

  service.running:
  - name: docker
  - enable: True
  - reload: True
  - watch:
    - group: docker
