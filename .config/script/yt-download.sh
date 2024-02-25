#!/bin/bash

options=""
output=""

if [[ ! -x "$(command -v yt-dlp)" && ! -x "$(command -v ffmpeg)" ]]; then
	echo "Error: 'yt-dlp' and 'ffmpeg' are required to run this script."
	exit 1
fi

read -p "Enter youtube video 'id' or 'url': " input

if [[ "$input" =~ ^(http(s)?:\/\/)?(www\.)?youtube\.com\/watch.* ]]; then
	if [[ "$input" =~ ^.*\?v=[A-Za-z0-9_-]{11}$ ]]; then
		echo "Video url detected."
	elif [[ "$input" =~ ^.*\&list=[A-Za-z0-9_-].* ]]; then
		echo "Playlist url detected."
	fi
	input=$(echo "$input" | sed 's/.*\?v=//')
elif [[ "$input" =~ ^[A-Za-z0-9_-]{11}$ ]]; then
	echo "Video id detected."
elif [[ "$input" =~ ^.*\&list=[A-Za-z0-9_-].* ]]; then
	echo "Playlist id detected."
else
	echo "Error: Please enter a valid youtube video 'id' or 'url'."
	exit 1
fi

read -p "Download 'video' or 'audio'? (v/a): " type

if [[ "$type" =~ ^[vV]$ ]]; then
	options="--merge-output-format mp4 -f bestvideo+bestaudio[ext=m4a]/best"
	if [[ "$OSTYPE" == "darwin"* ]]; then
		output="$HOME/Movies"
	elif [[ "$OSTYPE" == "msys" ]]; then
		output="$HOME/Videos"
	else
		echo "Error: This script is for 'macos' and 'windows' only."
		exit 1
	fi
elif [[ "$type" =~ ^[aA]$ ]]; then
	options="-f bestaudio[ext=m4a]/best"
	if [[ "$OSTYPE" == "darwin"* ]]; then
		output="$HOME/Music"
	elif [[ "$OSTYPE" == "msys" ]]; then
		output="$HOME/Music"
	else
		echo "Error: This script is for 'macos' and 'windows' only."
		exit 1
	fi
else
	echo "Error: Please enter 'v' or 'a'."
	exit 1
fi

yt-dlp $options "https://www.youtube.com/watch?v=$input" -o "$output/%(id)s.%(ext)s"

if [[ "$OSTYPE" == "darwin"* ]]; then
	open "$output"
elif [[ "$OSTYPE" == "msys" ]]; then
	start "$output"
else
	echo "Error: This script is for 'macos' and 'windows' only."
	exit 1
fi
