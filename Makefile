export DISPLAY_SKIPPED_HOSTS := 0
export ANSIBLE_NOCOWS := 1

INVENTORIES = staging production

INVENTORY := staging
ANSIBLE_OPTIONS :=
USER := deploy
DOMAIN := change.me
CMD :=
TAGS := all

install:
	@echo Installing dependensies...
	ansible-galaxy install -r requirements.yml

provision:
	@echo Provision ${INVENTORY} configuration...
	ansible-playbook ${ANSIBLE_OPTIONS} --diff --inventory ./inventories/${INVENTORY}.ini ./playbooks/provision.yml -k -u root


update:
	@echo Update ${INVENTORY} configuration...
	@echo ansible-playbook ${ANSIBLE_OPTIONS} --diff --inventory ./inventories/${INVENTORY}.ini --tags ${TAGS} ./playbooks/update.yml

update_nginx:
	@echo Update ${INVENTORY} nginx configuration...
	@echo ansible-playbook --diff --inventory ./inventories/${INVENTORY}.ini ./playbooks/update_nginx.yml -u ${USER} -s -t nginx-restart

migrate:
	@echo Migrate ${INVENTORY} DB schema...
	@echo ansible-playbook ${ANSIBLE_OPTIONS} --diff --inventory ./inventories/${INVENTORY}.ini ./playbooks/migrate.yml --tags migrate

users:
	@echo Synchronizing ${INVENTORY} users accounts...
	@echo Please provide root password:
	ansible-playbook ${ANSIBLE_OPTIONS} --diff --inventory ./inventories/${INVENTORY}.ini ./playbooks/users.yml -u root -k


run:
	@echo Run...
	@echo ssh ${USER}@${INVENTORY}.${DOMAIN} -t "zsh --login -c 'source ~/.zshrc && cd /home/${USER}/app/current && ${CMD}'"

console:
	@echo Rails console...
	@echo ssh ${USER}@${INVENTORY}.${DOMAIN} -t "zsh --login -c 'source ~/.zshrc && cd /home/${USER}/app/current && rails c -e production'"

logs:
	@echo Rails log / last 100 lines /...
	@echo ssh ${USER}@${INVENTORY}.${DOMAIN} -t "tail -n 100 -f /home/${USER}/app/shared/log/production.log"

cache:
	@echo Reset redis cache...
	@echo ssh ${USER}@${INVENTORY}.${DOMAIN} -t "zsh --login -c 'source ~/.zshrc && cd /home/${USER}/app/current && rails runner 'puts Redis.current.flushdb'"


deploy:
	@echo Deploying ${INVENTORY}...
	@echo ansible-playbook ${ANSIBLE_OPTIONS} --diff --inventory ./inventories/${INVENTORY}.ini --tags ${TAGS} ./playbooks/deploy.yml

rollback:
	@echo Rolling back ${INVENTORY}...
	@echo ansible-playbook ${ANSIBLE_OPTIONS} --diff --inventory ./inventories/${INVENTORY}.ini ./playbooks/rollback.yml

$(INVENTORIES):
	$(eval INVENTORY := $@)
	@echo Forced ${INVENTORY} environment

