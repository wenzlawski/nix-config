#!/usr/bin/env bash

# Source config file

. $HOME/.local/bin/borg.conf

info() {
	printf "\n%s %s\n\n" "$(date)" "$*" >&2
}

export BORG_RSH="${REPOSITORY_KEY}"
export BORG_PASSCOMMAND="${REPOSITORY_PASS}"

REPOSITORY="ssh://${BACKUP_USER}@${REPOSITORY_HOST}:${REPOSITORY_PORT}/./${REPOSITORY_DIR}"

echo "====== Starting Backup: $(date) ======"
info "====== Starting Backup: $(date) ======"

# Create list of exclude dirs

# echo "====== Starting pre exec scripts: $(date) ======"
# info "====== Starting pre exec scripts: $(date) ======"

# run-parts /etc/borg_backup.d/preexec/

borg create \
	--list --filter=AME \
	--stats --show-rc \
	--compression auto,lzma,6 \
	-e"*/node_modules" \
	-e"*/.DS_Store" \
	-e"*/.cache" \
	-e"*/cache" \
	-e"*/__pycache__" \
	-e"Users/mw/.emacs.d/straight" \
	-e"Users/mw/.emacs.d/eln-cache" \
	$REPOSITORY::"{$BACKUP_TIMESTAMP}" \
	/Users/mw/.ssh \
	/Users/mw/.config \
	/Users/mw/.emacs.d \
	/Users/mw/.gnupg \
	/Users/mw/.authinfo.gpg \
	/Users/mw/Calibre\ Library \
	/Users/mw/Zotero \
	/Users/mw/personal \
	/Users/mw/files \
	/Users/mw/Maildir \
	/Users/mw/Library/Keychains

echo "====== Backup finished: $(date) ======"

# echo "====== Starting post exec scripts: $(date) ======"
# info "====== Starting post exec scripts: $(date) ======"

# run-parts /etc/borg_backup.d/postexec/

echo "====== Pruning Backup: $(date) ======"
info "====== Pruning Backup: $(date) ======"

borg prune \
	--list --stats \
	--glob-archives '{hostname}-daily-' \
	--show-rc \
	--keep-daily 7 \
	--keep-weekly 5 \
	--keep-monthly 6 \
	$REPOSITORY

echo "====== Pruning finished: $(date) ======"
info "====== Pruning finished: $(date) ======"

echo "====== Status: $(date) ======"
info "====== Status: $(date) ======"

borg list $REPOSITORY

# create statusfiles for monitoring
borg list $REPOSITORY --short >$BORG_STATUSFILE 2>/dev/null
# borg info $REPOSITORY::$(tail -n1 /var/borgstatus) > ${BORG_STATUSFILE}_info 2>/dev/null

# Unset pass
export BORG_PASSCOMMAND=''
