GOLANGCI_LINT_VERSION := v1.42.1
HADOLINT_VERSION := v2.12.1-beta-alpine

.PHONY: all
all:
	@make test
	@make build

.PHONY: build
build:
	@make common-tasks
	@make setup-docker
	@make deploy-runner
	@make register-runner

.PHONY: clean
clean:
	@rm ./iac/inventories/inventory.ini

.PHONY: test
test:
	@docker build --tag ansible-lint:latest --target=ansible-lint .
	@docker container run --name ansible-lint --rm --volume ./iac/:/work ansible-lint:latest

	@docker build --build-arg BUILDER_NAME="name" --build-arg BUILDER_EMAIL="email" --tag makefile-lint:latest --target=makefile-lint .
	@docker container run --name makefile-lint --rm --volume ./Makefile:/Makefile makefile-lint:latest

    @docker container run --interactive --rm hadolint/hadolint:$(HADOLINT_VERSION) < ./Dockerfile

###############################
# Individual playbook targets #
###############################

.PHONY: common-tasks
common-tasks:
	@ansible-playbook ./iac/playbooks/common_tasks.yml -vvv

.PHONY: setup-docker
setup-docker:
	@ansible-playbook ./iac/playbooks/setup_docker.yml -vvv

.PHONY: deploy-runner
deploy-runner:
	@ansible-playbook ./iac/playbooks/deploy_runner.yml -vvv

.PHONY: register-runner
register-runner:
	@read -p "Enter your GitLab Runner authentication token: " RUNNER_AUTHENTICATION_TOKEN; \
	ansible-playbook ./iac/playbooks/register_runner.yml -vvv --extra-vars "RUNNER_AUTHENTICATION_TOKEN=$$RUNNER_AUTHENTICATION_TOKEN"
