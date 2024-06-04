#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Touchbar
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ◼️

MTMR_LOC=~/Library/Application\ Support/MTMR/items.json

VAR1=$(cat "$MTMR_LOC")

unlink "$MTMR_LOC"

if [ "$VAR1" = "[]" ]; then
    ln -s ~/.config/mtmr/items.json "$MTMR_LOC"
else
    echo "[]" > "$MTMR_LOC"
fi

pkill MTMR
open /Applications/MTMR.app

