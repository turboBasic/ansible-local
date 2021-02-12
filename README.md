Ansible-local: Playbooks for local workstation setup
====================================================


Unlock repo
-----------

    git-crypt unlock <(gpg --decrypt local.key.asc)


Apply Ansible playbooks
-----------------------

Playbooks' [README.md](src/README.md) file describes how to apply Ansible playbooks to computers



Reference
---------

### Files in repository root

- [`local.key.asc`](local.key.asc) - [git-crypt](https://github.com/AGWA/git-crypt)'s key for repository files, encrypted with [GnuPG](https://gnupg.org) symmetric encryption
- [`README.md`](README.md) - this file
- [`run-playbook`](run-playbook) - helper script for execution of Ansible playbooks
- [`.editorconfig`](.editorconfig)
- [`.gitignore`](.gitignore) - Git ignore file. NB: Make sure local secrets are not pushed to public repos
- [`.gitattributes`](.gitattributes) - Git source file attributes. NB: also keeps list of files which should be processed by git-crypt
- [`.vscode/settings.json`](.vscode/settings.json) - Shared settings for VS Code editor
