#!/bin/bash

CheckOs() {
	if [[ $OSTYPE != "darwin"* ]]; then
		echo "This script does not support the os."
		exit 1
	fi
}

CheckArguments() {
	if [[ $# -ne 1 ]]; then
		echo "Usage: resize_dock <percentage>"
		exit 1
	fi
}

ValidateTileSize() {
	local tile_size="$1"
	if [[ ! "$tile_size" =~ ^[0-9]+$ || "$tile_size" -lt 20 || "$tile_size" -gt 80 ]]; then
		echo "Please enter a valid tile size between 20 and 80."
		exit 1
	fi
}

SetDockTileSize() {
	local tile_size="$1"
	defaults write com.apple.dock tilesize -int "$tile_size"
	killall Dock
}

ResizeDock() {
	local tile_size="$1"
	CheckOs
	CheckArguments "$@"
	ValidateTileSize "$tile_size"
	SetDockTileSize "$tile_size"
}

ResizeDock "$@"
