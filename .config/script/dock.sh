#!/bin/bash

percentage=$1

if [[ "$OSTYPE" == "darwin"* ]]; then
	if ! [[ "$percentage" =~ ^[0-9]+$ ]]; then
		echo "Error: Please enter a valid percentage."
		exit 1
	fi
	defaults write com.apple.dock tilesize -int "$percentage"
	killall Dock
	echo "Dock size has been set to $percentage."
else
	echo "Error: This script is for 'macos' only."
	exit 1
fi
