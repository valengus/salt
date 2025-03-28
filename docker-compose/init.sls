{% import_yaml "docker-compose/defaults.yaml" as defaults %}
{%- set dockercompose = salt['pillar.get']('dockercompose', defaults.dockercompose) %}

include:
- docker

docker-compose:
  pkg.removed: []

/usr/local/bin/docker-compose:
  file.managed:
    - source: https://github.com/docker/compose/releases/download/v{{ dockercompose.version }}/docker-compose-linux-x86_64
    - source_hash: https://github.com/docker/compose/releases/download/v{{ dockercompose.version }}/checksums.txt
    - user: root
    - group: docker
    - mode: 0555
