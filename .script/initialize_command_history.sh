#!/bin/bash

default_command="
pwd
cd
cd /
cd ~
cd ..
cd -
ls
ls -A
ls -l
ls -l -A
ll
lla
mkdir
mkdir -p
cat
less
clear
rm
rm -rf
mv
mv -f
cp
cp -rf
touch
chmod
chmod +x
find
grep
ping
curl
curl -sSL https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt
ssh
brew
brew install
brew install --cask
brew list
brew update
brew update --auto-update
brew update -f
brew update --auto-update -f
brew outdated
brew outdated -g
brew upgrade
brew upgrade -g
brew uninstall
brew uninstall --cask
brew cleanup
brew cleanup --prune=all
scoop
scoop install
scoop list
scoop update
scoop update -a
scoop uninstall
scoop cache
scoop cache rm -a
scoop cleanup
scoop cleanup -a
pip
pip install
pip install -r requirements.txt
pip list
pip list --outdated
pip list --format=columns
pip list --outdated --format=columns
pip install --upgrade
pip install --upgrade -r requirements.txt
pip freeze
pip freeze > requirements.txt
pip uninstall
pip uninstall -r requirements.txt -y
pip cache
pip cache purge
flutter
flutter doctor
flutter create
flutter pub add
flutter pub remove
flutter pub get
flutter pub outdated
flutter pub upgrade
flutter pub upgrade --major-versions
flutter pub downgrade
flutter pub cache
flutter pub cache add
flutter pub cache add --all
flutter pub cache repair
flutter pub cache clear
flutter run
flutter clean
flutter build
docker
docker compose
docker compose up
docker compose up -d
docker compose up --build
docker compose up -d --build
docker compose watch
docker compose down
docker compose down -v
docker compose down --rmi all
docker compose ps
docker compose ps -a
docker compose ps -q
docker compose logs
docker compose logs -f
docker compose exec
nvm
nvm install
nvm use
nvm list
nvm uninstall
npm
npm init
npm init -y
npm install
npm install -g
npm list
npm list -g
npm outdated
npm outdated -g
npm update
npm update -g
npm uninstall
npm uninstall -g
npm cache clean
npm cache clean --force
npm start
npm run dev
npm run build
npm run format
yarn
yarn add
yarn global add
yarn list
yarn global list
yarn upgrade-interactive --latest
yarn global upgrade-interactive --latest
yarn remove
yarn global remove
yarn cache clean
yarn cache clean --all
ncu
ncu -g
ncu -i
ncu -i --format group
git
git init
git clone
git clone git@github.com:
git clone https://github.com/
git status
git log
git diff
git show
git add .
git reset
git commit
git commit -m
git commit --allow-empty
git branch
git branch -a
git checkout
git remote
git remote -v
git remote add origin
git remote remove origin
git merge
git merge --abort
git merge --continue
git rebase
git rebase -i --root
git rebase --abort
git rebase --continue
git push origin
git push origin --force
git pull origin
git cz
git cz -a
lazygit
z
z -l
z -c
wsl
wsl -l -v
wsl --default
wsl --shutdown
wsl --terminate
"

custom_command="
npm i
npm i -g
g init
g clone
g clone git@github.com:
g clone https://github.com/
g a
g hist
g llog
g d
g df
g show
g add .
g reset
g ci
g ci -m
g ci --allow-empty
g br
g br -a
g co
g remote
g remote -v
g remote add origin
g remote remove origin
g merge
g merge --abort
g merge --continue
g rebase
g rebase -i --root
g rebase --abort
g rebase --continue
g ps
g ps -f
g pl
g cz
g cz -a
lg
ide
youtube_download
cleanup_directories
initialize_command_history
resize_dock
"

SetOsSpecificVariables() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
		command_prefix="- cmd:"
		history_file_path="$HOME/.local/share/fish/fish_history"
	elif [[ "$OSTYPE" == "msys" ]]; then
		command_prefix=""
		history_file_path="$HOME/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadline/ConsoleHost_history.txt"
	else
		echo "This script does not support the os."
		exit 1
	fi
}

CleanHistoryFile() {
	if [[ -f "$history_file_path" ]]; then
		rm "$history_file_path"
	fi
	touch "$history_file_path"
}

AppendCommandsToHistoryFile() {
	local commands="$1"
	echo "$commands" | sed '/^$/d' | while IFS= read -r command; do
		if [[ -n "$command_prefix" ]]; then
			echo "$command_prefix $command" >>"$history_file_path"
		else
			echo "$command" >>"$history_file_path"
		fi
	done
}

InitializeCommandHistory() {
	SetOsSpecificVariables
	CleanHistoryFile
	AppendCommandsToHistoryFile "$default_command"
	AppendCommandsToHistoryFile "$custom_command"
}

InitializeCommandHistory
