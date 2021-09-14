GITFLAGS ?= GIT_DIR=${SRCDIR}/.git GIT_WORK_TREE=${SRCDIR}
ifeq ($(NOGIT),1)
  GIT_SUMMARY ?= Unknown
  GIT_BRANCH ?= Unknown
  GIT_MERGE ?= Unknown
else
  GIT_SUMMARY ?= $(shell ${GITFLAGS} git describe --tags --dirty --always)
  GIT_BRANCH ?= $(shell ${GITFLAGS} git symbolic-ref -q --short HEAD)
  GIT_MERGE ?= $(shell ${GITFLAGS} git rev-list --count --merges main)
endif

LDFLAGS += -X main.GitBranch=${GIT_BRANCH} -X main.GitSummary=${GIT_SUMMARY} -X main.GitMerge=${GIT_MERGE}

default: help 

## up: Docker compose up in all services
.PHONY: up
up:
	@docker compose up\
		--build --force-recreate --no-deps

## down: Docker compose down in all services
.PHONY: down
down:
	@docker compose down

## help: show this help
.PHONY: help
help: Makefile
	@echo
	@echo " Choose a command run:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo
