#### Variables ####

export ROOT_DIR ?= $(PWD)
export ADDON_ROOT_DIR ?= $(ROOT_DIR)

export ANSIBLE_NAME ?= addon
export HOSTS_INI_FILE ?= $(ADDON_ROOT_DIR)/hosts.ini

export EXTRA_VARS ?= ""

#### Start Ansible docker ####

ansible:
	export ANSIBLE_NAME=$(ANSIBLE_NAME); \
	sh $(ADDON_ROOT_DIR)/scripts/ansible ssh-agent bash

#### a. Debugging ####
debug:
	ansible-playbook -i $(HOSTS_INI_FILE) $(ADDON_ROOT_DIR)/debug.yml \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)

#### b. Provision addons (default docker)####
registry-install: registry-docker-install
registry-uninstall: registry-docker-uninstall

#### c. Provision registry ####
registry-docker-install:
	ansible-playbook -i $(HOSTS_INI_FILE) $(ADDON_ROOT_DIR)/deploy_docker.yml --tags install \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)
registry-docker-uninstall:
	ansible-playbook -i $(HOSTS_INI_FILE) $(ADDON_ROOT_DIR)/deploy_docker.yml --tags uninstall \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)