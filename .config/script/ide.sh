#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
	if [[ -n "$TMUX" ]]; then
		tmux split-window -v -l 30%
		tmux split-window -h -l 66%
		tmux split-window -h -l 50%
		tmux select-pane -t 0
	else
		echo "Error: Please run this script inside 'tmux'."
		exit 1
	fi
else
	echo "Error: This script is for 'macos' only."
	exit 1
fi
