/etc/yum.repos.d/salt.repo:
  file.managed:
    - contents: |
        [salt-repo-3007-sts]
        name=Salt Repo for Salt v3007 STS
        baseurl=https://packages.broadcom.com/artifactory/saltproject-rpm/
        skip_if_unavailable=True
        priority=10
        enabled=1
        enabled_metadata=1
        gpgcheck=1
        exclude=*3006* *3008* *3009* *3010*
        gpgkey=https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public
    - user: root
    - group: root
    - mode: 644
