Ansible: provision local PC
===========================


Unlock repo
-----------

See [README.md](../README.md) in repository root


Apply roles
-----------

1. `ansible-playbook site.yml -vv`
2. `ansible-playbook site.yml --tags env`
3. `ansible-playbook site.yml --tags "profile.all, env.all"`
