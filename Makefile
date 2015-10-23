SHELL := /bin/bash
PROJECT_ID := datainasafeorg

# ----------------------------------------------------------------------------
#    P R O D U C T I O N     C O M M A N D S
# ----------------------------------------------------------------------------

default: deploy

build:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Building in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -p $(PROJECT_ID) build

deploy: build
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Bringing up fresh instance "
	@echo "You can access it on http://localhost:8190"
	@echo "------------------------------------------------------------------"
	@docker-compose -p $(PROJECT_ID) up -d btsync
	@docker-compose -p $(PROJECT_ID) up -d apache

pushbackup:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Push local backup in sftpbackup to sftp remote server"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)_sftpbackup_1 /start.sh push-to-remote-sftp

pullbackup:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Pull remote sftp backup to local backup"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)_sftpbackup_1 /start.sh pull-from-remote-sftp
