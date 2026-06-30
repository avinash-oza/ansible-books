# ansible-books

Ansible playbooks for general tasks around provisioning


- Install `uv`
- `uv tool install ansible-core`
- `uv tool install ansible-lint`
- `ansible-galaxy collection install community.docker`

Setup diff of vault files

- `git config --global diff.ansible-vault.textconv "ansible-vault view"`

Update ip in inventory for multipass

- `sed -i 's/ansible_host=[0-9.]\+/ansible_host=10.204.56.110/g' inventory/testing/hosts`
