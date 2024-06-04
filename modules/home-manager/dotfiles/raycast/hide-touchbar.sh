#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Hide Touchbar
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ◼️

MTMR_LOC=~/Library/Application\ Support/MTMR/items.json

VAR1=$(cat $MTMR_LOC)

echo $VAR1
unlink $MTMR_LOC

if [ "$VAR1" = "[]" ]; then
    echo "Strings are equal."
    ln -s ~/.config/mtmr/items.json $MTMR_LOC
else
    echo "Not equal"
    ln -s ~/.config/mtmr/empty.json $MTMR_LOC
fi

pkill mtmr
open /Applications/MTMR.app

