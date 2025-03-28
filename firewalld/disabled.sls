firewalld masked:
  service.masked:
  - name: firewalld

firewalld stop:
  service.dead:
  - name: firewalld
  - enable: False
