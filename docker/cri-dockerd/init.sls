include:
- systemd.daemon-reload

cri-dockerd binary:
  archive.extracted:
    - name: /usr/bin/
    - source: https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.20/cri-dockerd-0.3.20.amd64.tgz
    - skip_verify: True
    - options: --strip-components=1
    - enforce_toplevel: False
    - if_missing: /usr/bin/cri-dockerd


/usr/lib/systemd/system/cri-docker.socket:
  file.managed:
    - contents: |
        [Unit]
        Description=CRI Docker Socket for the API
        PartOf=cri-docker.service

        [Socket]
        ListenStream=%t/cri-dockerd.sock
        SocketMode=0660
        SocketUser=root
        SocketGroup=docker

        [Install]
        WantedBy=sockets.target

    - makedirs: true
    - watch_in: [ systemctl daemon-reload ]
    - require: [ cri-dockerd binary ]

/usr/lib/systemd/system/cri-docker.service:
  file.managed:
    - contents: |
        [Unit]
        Description=CRI Interface for Docker Application Container Engine
        Documentation=https://docs.mirantis.com
        After=network-online.target firewalld.service docker.service
        Wants=network-online.target
        Requires=cri-docker.socket

        [Service]
        Type=notify
        ExecStart=/usr/bin/cri-dockerd --container-runtime-endpoint fd://
        ExecReload=/bin/kill -s HUP $MAINPID
        TimeoutSec=0
        RestartSec=2
        Restart=always
        StartLimitBurst=3
        StartLimitInterval=60s
        LimitNOFILE=infinity
        LimitNPROC=infinity
        LimitCORE=infinity
        TasksMax=infinity
        Delegate=yes
        KillMode=process

        [Install]
        WantedBy=multi-user.target

    - makedirs: true
    - watch_in: [ systemctl daemon-reload ]
    - require: [ cri-dockerd binary ]


cri-docker socket:
  service.running:
  - name: cri-docker.socket
  - enable: True
  - require:
    - file: /usr/lib/systemd/system/cri-docker.socket
    - cmd: systemctl daemon-reload

cri-docker service:
  service.running:
  - name: cri-docker.service
  - enable: true
  - require:
    - file: /usr/lib/systemd/system/cri-docker.service
    - cmd: systemctl daemon-reload
    - service: cri-docker.socket
