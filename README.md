# Provisioner
[![Galaxy](https://img.shields.io/badge/galaxy-provisioner-blue.svg?style=flat-square)](https://galaxy.ansible.com/khusnetdinov/provisioner/)

This is ansible receipt for prepare enviroment on linux (Ubuntu) for run Ruby on Rails application in production. Setting up deploy user, timezone, locales, swapfile. Install PostgreSQL, Redis, Nginx. Create folders for capistrano.

#### Dependencies

Provisioner use other ansible receipts witch are specified in `requirements.yml`:

```yaml
- src: "https://github.com/Stouts/Stouts.locale"
  name: locale
  version: 1.1.0

... other tools ...

- src: "https://github.com/khusnetdinov/provision.ruby"
  name: ruby

```

#### Variables

All variables should be placed in `settings.yml`:

```yaml
# Prepare system
deploy_locales:
  - ru_RU.UTF-8
deploy_timezone: Europe/Moscow
deploy_swapfile_size: 2GB
deploy_user: deploy
deploy_user_home: "/home/{{ deploy_user }}"
deploy_user_group: "{{ deploy_user }}"

# Provision
deploy_packages:                                              # Apt packages
  - library
  - other_library

deploy_project: project                                       # Application name 
deploy_postgres_version: 9.5
deploy_postgres_user: "{{ deploy_user }}"
deploy_postgres_database: "{{ deploy_user }}_production"

# Ruby
deploy_ruby_version: 2.2.2
```

This variables are used in playbook `playbooks/provision.yml`.

#### Usage

Provisioner prepares first system and deploy user and further install all tools under deploy user.

Makefile handles all actions. Theere are two stages `staging`, `production`. Staging enviroment is default.

- Specify `hosts` in `inventories/[enviroment].ini`
- Specify system variables: timezone, locales, deploy user, versions on DBs, server and rubies and other.
- Install all required roles `make install [enviroment]`
- Run provision for enviroment `make provision [enviroment]`
- Set up capistrano receipts.
- Run capistrano deploy
- Be happy
