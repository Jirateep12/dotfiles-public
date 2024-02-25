#!/bin/bash

CheckOs() {
	if [[ $OSTYPE != "darwin"* ]]; then
		echo "This script does not support the os."
		exit 1
	fi
}

CheckTmuxSession() {
	if [[ -z "$TMUX" ]]; then
		echo "Please run this script inside tmux."
		exit 1
	fi
}

CreateTmuxLayout() {
	tmux split-window -v -l 30%
	tmux split-window -h -l 50%
	tmux select-pane -t 0
}

Ide() {
	CheckOs
	CheckTmuxSession
	CreateTmuxLayout
}

Ide
