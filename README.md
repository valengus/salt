# salt

```bash
curl -L https://bootstrap.saltproject.io/bootstrap-salt.sh | sudo sh -s -- -F stable 3007
sudo dnf config-manager setopt salt-repo-3007-sts.enabled=1
sudo dnf config-manager setopt salt-repo-3006-lts.enabled=0
sudo dnf update salt-minion -y
sudo salt-pip install gitpython

sudo tee /etc/salt/minion << END
master_type: disable
fileserver_backend:
- git
gitfs_update_interval: 300
gitfs_global_lock: false
gitfs_base: main

gitfs_remotes:
- https://github.com/valengus/salt.git

pub_ret: false
mine_enabled: false
file_client: local
return: rawfile_json
END

sudo salt-call --local state.apply salt-minion --state-output=terse
```