#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
	shopt -s dotglob
	find "$HOME/Library/Caches/"* -type f -delete
	find "$HOME/Library/Logs/"* -type f -delete
	find "$HOME/Downloads/"* "$HOME/Movies/"*.mp4 "$HOME/Music/"*.m4a -type f -delete
	find "$HOME/Library/Application Support/obs-studio/basic/profiles/Untitled/"*.bak \
		"$HOME/Library/Application Support/obs-studio/basic/scenes/"*.bak \
		"$HOME/Library/Application Support/obs-studio/logs/"* \
		"$HOME/Library/Application Support/obs-studio/profiler_data/"* -type f -delete
	read -p "Delete all '.DS_Store' files? (y/n): " choice
	if [[ "$choice" == [yY] ]]; then
		find / -name '.DS_Store' -type f -delete
	elif [[ "$choice" == [nN] ]]; then
		echo "No action taken."
		exit 0
	else
		echo "Error: Please enter 'y' or 'n'."
		exit 1
	fi
elif [[ "$OSTYPE" == "msys" ]]; then
	taskkill //F //IM node.exe
	rm -rf "$HOME/Downloads/"* "$HOME/Videos/"*.mp4 "$HOME/Music/"*.m4a
	rm -rf "$HOME/AppData/Roaming/obs-studio/basic/profiles/Untitled/"*.bak \
		"$HOME/AppData/Roaming/obs-studio/basic/scenes/"*.bak \
		"$HOME/AppData/Roaming/obs-studio/logs/"* \
		"$HOME/AppData/Roaming/obs-studio/profiler_data/"*
else
	echo "Error: This script is for 'macos' and 'windows' only."
	exit 1
fi
