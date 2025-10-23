include:
- repo.docker

podman:
  pkg.removed: []

moby-engine:
  pkg.removed: []

containerd:
  pkg.installed:
  - name: containerd.io
  - watch_in: [ 'containerd generate dafault config' ]
  - require:
    - pkgrepo: docker-ce-stable

containerd generate dafault config:
  cmd.wait:
  - name: containerd config default > /etc/containerd/config.toml
  - require:
    - pkg: containerd.io

containerd SystemdCgroup:
  file.replace:
    - name: /etc/containerd/config.toml
    - pattern: 'SystemdCgroup = false'
    - repl: 'SystemdCgroup = true'
    - require:
      - cmd: containerd generate dafault config

containerd service:
  service.running:
  - name: containerd
  - enable: True
  - require:
    - pkg: containerd
  - watch:
    - containerd generate dafault config
    - containerd SystemdCgroup
