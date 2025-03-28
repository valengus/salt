# Salt

```bash
sudo dnf install -y git python3 python3-pip

export BOOTSTRAP_SALT="https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh"

curl -L $BOOTSTRAP_SALT | sudo sh -s -- -x python3 \
  -FPDj '{ \
    "master_type": "disable", \
    "fileserver_backend": [ "git" ], \
    "gitfs_update_interval": 300, \
    "gitfs_global_lock": false, \
    "gitfs_base": "main", \
    "gitfs_remotes": [ "https://github.com/valengus/salt.git" ], \
    "pub_ret": false, \
    "mine_enabled": false, \
    "file_client": "local", \
    "return": "rawfile_json" \
  }' stable

sudo salt-pip install gitpython

# Salt call
sudo salt-call --local state.apply salt-minion-masterless
sudo salt-call --local state.apply docker pillar='{ "docker": { "users": [ "vagrant" ] } }'

# Salt grains
sudo salt-call --local grains.items
```
### Test Salt states
```bash
salt-call --local state.apply kitchen-salt
cd /srv/salt 
kitchen test
```