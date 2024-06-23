#!/usr/bin/env bash

##
## Source configuration
##

. borg.conf

export BORG_RSH="${REPOSITORY_KEY}"

export BORG_PASSCOMMAND="${REPOSITORY_PASS}"

REPOSITORY="ssh://${BACKUP_USER}@${REPOSITORY_HOST}:${REPOSITORY_PORT}/./${REPOSITORY_DIR}"

borg recreate \
	-e"*/cache" \
	-e"Users/mw/.emacs.d/straight" \
	-e"Users/mw/.emacs.d/eln-cache" \
	-e"*/node_modules" \
	-e"*/.DS_Store" \
	-e"*/.cache" \
	-e"*/cache" \
	$REPOSITORY

export BORG_PASSCOMMAND=''
