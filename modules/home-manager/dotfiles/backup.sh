#!/bin/sh

export BORG_FILES_CACHE_TTL=40 # https://borgbackup.readthedocs.io/en/stable/faq.html#it-always-chunks-all-my-files-even-unchanged-ones
# default repo location so that we can use '::archive' shorthand notation later
export BORG_REPO='ssh://u411549-sub1@u411549.your-storagebox.de/./backups/mbp2019'
# get repo passphrase from password store
export BORG_PASSCOMMAND='security find-generic-password -s borg-repo -w'
export BORG_RSH="ssh -i /root/.ssh/id_ed25519_hetznerbackup"

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# create a daily backup
borg create \
    --verbose \
   --list --filter=AME \
   --stats --show-rc \
   --compression auto,lzma,6 \
    '::{hostname}-daily-{now}' \
      /Users/mw/.ssh \
      /Users/mw/.config \
      /Users/mw/.emacs.d \
      /Users/mw/.gnupg
      /Users/mw/.authinfo.gpg \
      /Users/mw/Calibre\ Library \
      /Users/mw/Zotero \
      /Users/mw/personal \

backup_exit=$?

info "Pruning repository"

# prune the repo
borg prune \
    --list --stats \
    --glob-archives '{hostname}-daily-' \
    --show-rc \
    --keep-daily 7 \
    --keep-weekly 5 \
    --keep-monthly 6

prune_exit=$?

# use highest exit code as exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 1 ];
then
    info "Backup and/or Prune finished with a warning"
fi

if [ ${global_exit} -gt 1 ];
then
    info "Backup and/or Prune finished with an error"
fi

exit ${global_exit}
