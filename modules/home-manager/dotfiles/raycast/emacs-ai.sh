#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Emacs AI
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

emacsclient -ne "(my/focus-or-make-ai-frame)"
