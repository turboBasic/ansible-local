Using encrypted passwords in Ansible playbooks
==============================================

> Ansible 2.4+

### Initialization

```bash
# Create password file for Ansible Vault and make sure it is out of Git
echo 'mySuperPassword' > vault_password  &&  chmod 600 vault_password
echo 'vault_password' >> .gitignore
echo 'Place vault password here and remove ‘.sample’ from file name' > vault_password.sample
git add .gitignore vault_password.sample
```


### Create/Read/Update/Delete passwords in encrypted file

```bash
# Create file ‘passwd.yml‘, edit it and encrypt with the password from ‘vault_password’ file:
ansible-vault --vault-id ./vault_password create passwd.yml

# Decrypt, edit, save and encrypt back:
ansible-vault --vault-id vault_password edit passwd.yml

# Decrypt, edit, save and encrypt back, enter password from keyboard:
ansible-vault --vault-id @prompt edit passwd.yml

# Encrypt variables in already created file
echo "my_sudo_pass: password1" > passwd.yml
echo "mail_password: pssword2" > passwd.yml
ansible-vault --vault-id vault_password encrypt passwd.yml

# Decrypt, edit, save and encrypt back in Ansible <2.4:
# ansible-vault --vault-password-file=vault_password edit passwd.yml
```


### Use encrypted passwords in playbooks


##### playbook.yml
```yaml
- name: Play 1
  hosts: all
  become: yes

  vars_files:
    - passwd.yml

  vars:
    ansible_sudo_pass: "{{ secret_sudo_pass }}"
```

##### passwd.yml (decrypted view)
```yaml
secret_sudo_pass: password1
mail_password: password2
```

##### CLI
```bash
ansible-playbook --vault-id vault_password -i inventory_file playbook.yml
```

