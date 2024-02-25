#!/bin/bash

CheckRequiredCommands() {
	local required_commands="yt-dlp ffmpeg"
	for command in $required_commands; do
		if [[ ! -x "$(command -v "$command")" ]]; then
			echo "$command is required to run this script."
			exit 1
		fi
	done
}

ValidateYoutubeInput() {
	if [[ "$input" =~ ^(http(s)?:\/\/)?(www\.)?youtube\.com\/watch.* ]]; then
		if [[ "$input" =~ ^.*\?v=[A-Za-z0-9_-]{11}$ ]]; then
			echo "Video url detected."
		elif [[ "$input" =~ ^.*\&list=[A-Za-z0-9_-].* ]]; then
			echo "Playlist url detected."
		fi
		video_id="${input#*v=}"
	elif [[ "$input" =~ ^[A-Za-z0-9_-]{11}$ ]]; then
		echo "Video id detected."
		video_id="$input"
	elif [[ "$input" =~ ^.*\&list=[A-Za-z0-9_-].* ]]; then
		echo "Playlist id detected."
		video_id="$input"
	else
		echo "Please enter a valid youtube video id or url."
		exit 1
	fi
}

GetOutputDirectory() {
	local media_type="$1"
	local output_directory=""
	if [[ "$media_type" =~ ^[vV]$ ]]; then
		if [[ $OSTYPE == "darwin"* ]]; then
			output_directory="$HOME/Movies"
		elif [[ $OSTYPE == "msys" ]]; then
			output_directory="$HOME/Videos"
		fi
	elif [[ "$media_type" =~ ^[aA]$ ]]; then
		if [[ $OSTYPE == "darwin"* ]]; then
			output_directory="$HOME/Music"
		elif [[ $OSTYPE == "msys" ]]; then
			output_directory="$HOME/Music"
		fi
	else
		echo "Please enter video or audio (v/a)."
		exit 1
	fi
	echo "$output_directory"
}

DownloadYoutubeContent() {
	local video_id="$1"
	local media_type="$2"
	local output_directory="$3"
	if [[ "$media_type" =~ ^[vV]$ ]]; then
		yt-dlp --merge-output-format mp4 -f bestvideo+bestaudio[ext=m4a]/best "https://www.youtube.com/watch?v=$video_id" -o "$output_directory/%(id)s.%(ext)s"
	elif [[ "$media_type" =~ ^[aA]$ ]]; then
		yt-dlp -f bestaudio[ext=m4a]/best "https://www.youtube.com/watch?v=$video_id" -o "$output_directory/%(id)s.%(ext)s"
	else
		echo "Please enter video or audio (v/a)."
		exit 1
	fi
}

OpenOutputDirectory() {
	local output_directory="$1"
	local open_command=""
	if [[ $OSTYPE == "darwin"* ]]; then
		open_command="open"
	elif [[ $OSTYPE == "msys" ]]; then
		open_command="start"
	fi
	"$open_command" "$output_directory"
}

YoutubeDownload() {
	local output_directory=""
	CheckRequiredCommands
	read -r -p "Enter youtube video id or url: " input
	ValidateYoutubeInput "$input"
	read -r -p "Download video or audio? (v/a): " type
	output_directory=$(GetOutputDirectory "$type")
	DownloadYoutubeContent "$video_id" "$type" "$output_directory"
	OpenOutputDirectory "$output_directory"
}

YoutubeDownload
