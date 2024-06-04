#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Hide Touchbar
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ◼️

VAR1=cat ~/Library/Application\ Support/MTMR/items.json

if [ "$VAR1" = "[]\n" ]; then
    echo "Strings are equal."
else
    echo "Not equal"
fi

