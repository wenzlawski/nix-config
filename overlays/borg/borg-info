#!/usr/bin/env bash

##
## Source configuration
##

. borg.conf

export BORG_RSH="${REPOSITORY_KEY}"

export BORG_PASSCOMMAND="${REPOSITORY_PASS}"

REPOSITORY="ssh://${BACKUP_USER}@${REPOSITORY_HOST}:${REPOSITORY_PORT}/./${REPOSITORY_DIR}"

borg info $REPOSITORY

export BORG_PASSCOMMAND=''


