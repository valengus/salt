include:
- docker.build.oraclelinux9

docker image python3:
  docker_image.present:
  - name: python3
  - tag: latest
  - sls: python3, docker.build.common.cleanup
  - base: oraclelinux9
  - saltenv: base
  - require:
    - docker_image: oraclelinux9
