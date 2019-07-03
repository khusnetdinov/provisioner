# Provisioner
[![Galaxy](https://img.shields.io/badge/galaxy-provisioner-blue.svg?style=flat-square)](https://galaxy.ansible.com/khusnetdinov/provisioner/)

This ansible role helps to use several receipts together. Just wrapper for other roles.

## Files structure

```
  ├── /defaults/                  # Default variables for playbook
  │   └── main.yml                # Variables for playbook
  ├── /meta/                      # Meta
  │   └── main.yml                # Ansible Galaxy meta information
  ├── /roles/                     # Vendor playbooks
  ├── /temp/                      # Temp files
  │── ansible.cfg                 # Ansible configuration file
  │── hosts                       # Inventory file
  │── README.md                   # Project description
  │── requerements.txt            # Dependencies file
  └── playbook.yml                # Playbook file
```

## How it works

#### Dependencies

Provisioner use other ansible receipts witch are specified in `requirements.yml`:

```yaml
  ---

  - src: "https://github.com/Stouts/Stouts.locale"
    name: locale
    version: 1.1.0

  ... other tools ...

```

#### Installation

Run command:

```bash
  $ ansible-galaxy install -r requirements.yml
```

#### Configuration

All variables should be placed in `defaults/main.yml`:

```yaml
  ---
  
  provision_user_name: deploy
  
  ... other variables ...
```

This variables are used in playbook `playbook.yml`.

#### Playbook

Playbook is `playbook.yml` - main file. Plase here all logic.

#### Inventory

Is located in `hosts`.

```ini
  # hosts

  [provision]
  # Set you hosts
  0.0.0.0
```

#### Run provision

```bash
  $ ansible-playbook playbook.yml -i hosts -vvv
```
