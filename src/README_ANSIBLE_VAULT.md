Using encrypted passwords in Ansible playbooks
==============================================

> Ansible 2.4+

Initialize Ansible Vault
------------------------

### Option 1. Create local password file for Ansible Vault and make sure it is excluded by Git

```bash
vaultFile='secrets/vault_password'

echo "$(basename $vaultFile)" >> .gitignore
echo 'mySuperPassword' > "$vaultFile"
chmod 600 "$vaultFile"

git add --  .gitignore
git commit --message ':wrench: Ignore Ansible vault password file'
```


### Option 2. Encrypt password file for Ansible Vault with `git-crypt` and check into Git

Initialize repo with git-crypt and add your encryption key(s) with git-crypt.

```bash
vaultFile='secrets/vault_password.key'

echo 'mySuperPassword' > "$vaultFile"
echo '*.key  filter=git-crypt diff=git-crypt' >> .gitattributes

git add -- .gitattributes \
           "$vaultFile"
git commit --message ':lock: Add encrypted Ansible vault password file'
```


Manage encrypted secrets using Ansible Vault password file
----------------------------------------------------------

### Create file `passwd.yml`, edit it and encrypt with the password from `vault_password` file

    ansible-vault --vault-id vault_password create passwd.yml

### Decrypt previously encrypted file `passwd.yml`, edit, save and encrypt back

    ansible-vault --vault-id vault_password edit passwd.yml

### Decrypt previously encrypted file passwd.yml, edit, save and encrypt back, enter password from keyboard

    ansible-vault --vault-id @prompt edit passwd.yml

### Encrypt variables in existing file `passwd.yml`

```bash
echo 'my_sudo_pass: password1' > passwd.yml
echo 'mail_password: pssword2' > passwd.yml
ansible-vault --vault-id vault_password encrypt passwd.yml
```

### View encrypted file

    ansible-vault view vars/servers.yml \
        --vault-id secrets/vault_password.key


Use encrypted passwords in playbooks
------------------------------------

### playbook.yml

```yaml
- name: Play 1
  hosts: all
  become: yes

  vars_files:
    - passwd.yml

  vars:
    ansible_sudo_pass: "{{ secret_sudo_pass }}"
```


### passwd.yml *(decrypted view)*

```yaml
secret_sudo_pass: password1
mail_password: password2
```


### CLI

    ansible-playbook --vault-id vault_password -i inventory_file playbook.yml
