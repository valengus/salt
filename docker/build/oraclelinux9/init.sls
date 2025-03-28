include:
- docker

Dockerfile oraclelinux9:
  file.managed:
    - name: /opt/docker/oraclelinux9/Dockerfile
    - contents: |
        FROM oraclelinux:9
        RUN dnf update -y ; \
        dnf clean all ; \
        rm -rf /var/cache/yum ; \
        rm -rf /var/cache/dnf
        CMD ["/usr/sbin/init"]
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

oraclelinux9:
  docker_image.present:
  - tag: latest
  - build: /opt/docker/oraclelinux9
  - require:
    - Dockerfile oraclelinux9
