#!/usr/bin/env bash

EVENING=18

current_hour=$(date +%H)

if (( current_hour < EVENING )); then
    echo "It is not evening yet. Script will not execute."
    exit 0
fi

osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to dark mode'
