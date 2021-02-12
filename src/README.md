Ansible: provision local PC
===========================


Unlock repo
-----------

See [README.md](../README.md) in repository root


Apply roles
-----------

Using `ansible-playbook` utility, assuming `src/` as current working directory:

1.     ansible-playbook -vv playbook-site.yml
2.     ansible-playbook --tags env playbook-site.yml
3.     ansible-playbook --tags "profile.all, env.all" \
                        playbook-site.yml
4.     ansible-playbook --inventory inventory \
                        --vault-id  secrets/vault_password.key \
                        playbook-local-machine.yml
5.     ANSIBLE_CONFIG=./ansible.cfg ansible-playbook playbook-local-machine.yml


Using `run-playbook` helper, assuming repository root as current working directory:

1.     ./run-playbook playbook-local-machine \
                      playbook-site
