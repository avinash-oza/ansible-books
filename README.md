# ansible-books

Ansible playbooks for general tasks around provisioning


- Install `uv`
- `uv venv`
- `source .venv/bin/activate`
- `uv pip install ansible ansible-core ansible-lint passlib`
- `ansible-galaxy collection install community.docker ansible.posix`

Setup diff of vault files

- `git config --global diff.ansible-vault.textconv "ansible-vault view"`

Update ip in inventory for multipass

- `sed -i 's/ansible_host=[0-9.]\+/ansible_host=10.204.56.110/g' inventory/testing/hosts`
