include:
- docker.build.python3

docker image oraclelinux9-kitchen:
  docker_image.present:
  - name: oraclelinux9-kitchen
  - tag: latest
  - sls: salt-minion-masterless.install, docker.build.common.cleanup
  - base: python3
  - saltenv: base
  - require:
    - docker_image: python3
