#!/bin/bash

shopt -s dotglob

DeleteFilesInPaths() {
	local file_paths=("$@")
	for file_path in "${file_paths[@]}"; do
		find "$file_path" -delete
	done
}

DeleteDsStoreFiles() {
	read -r -p "Delete all '.ds_store' files? (y/n): " user_choice
	if [[ "$user_choice" =~ ^[yY]$ ]]; then
		find / -name '.DS_Store' -type f -delete
	fi
}

CleanupDirectories() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
		local macos_paths=(
			"$HOME/Downloads/"*
			"$HOME/Movies/"*
			"$HOME/Music/"*
			"$HOME/Library/Caches/"*
			"$HOME/Library/Logs/"*
		)
		DeleteFilesInPaths "${macos_paths[@]}"
		DeleteDsStoreFiles
	elif [[ "$OSTYPE" == "msys" ]]; then
		local windows_paths=(
			"$HOME/Downloads/"*
			"$HOME/Videos/"*
			"$HOME/Music/"*
		)
		DeleteFilesInPaths "${windows_paths[@]}"
	else
		echo "This script does not support the os."
		exit 1
	fi
}

CleanupDirectories
