#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Emacs AI
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

emacsclient -ne "(my/make-ai-frame)"
