#!/bin/bash

command_prefix=""
history_file=""

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
ls -lA
ll
lla
mkdir
mkdir -p
cat
less
clear
rm
rm -rf
rm -r -force
mv
mv -f
mv -force
cp
cp -rf
cp -r -force
touch
chmod
find
grep
ping
curl
ssh
brew install
brew install --cask
brew list
brew list --cask
brew outdated
brew outdated --cask
brew upgrade
brew upgrade --cask
brew uninstall
brew uninstall --cask
brew cleanup
scoop install
scoop list
scoop update
scoop uninstall
pip install
pip install -r requirements.txt
pip list
pip list --outdated --format=columns
pip install --upgrade
pip install --upgrade -r requirements.txt
pip uninstall
pip uninstall -r requirements.txt -y
pip freeze > requirements.txt
pip cache purge
docker compose up
docker compose up -d
docker compose up --build
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
ncu -u
ncu -g
git clone
git clone git@github.com:
git status
git log
git diff
git show
git add .
git reset
git commit
git commit -m
git branch
git branch -a
git checkout
git remote
git remote add origin
git remote -v
git remote rm origin
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
npm ls
npm ls -g
npm up
npm up -g
npm un
npm un -g
g clone
g clone git@github.com:
g st
g llog
g d
g show
g add .
g reset
g cm
g cm -m
g br
g br -a
g co
g remote
g remote add origin
g remote -v
g remote rm origin
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
ide
ytd
cleanup
initial-command
set-dock
"

if [[ "$OSTYPE" == "darwin"* ]]; then
	command_prefix="- cmd:"
	history_file="$HOME/.local/share/fish/fish_history"
elif [[ "$OSTYPE" == "msys" ]]; then
	command_prefix=""
	history_file="$HOME/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadline/ConsoleHost_history.txt"
else
	echo "Error: This script is for 'macos' and 'windows' only."
	exit 1
fi

>"$history_file"

(
	echo "$default_command"
	echo "$custom_command"
) | sed '/^$/d' | while read -r cmd; do
	if [ -n "$command_prefix" ]; then
		echo "$command_prefix $cmd" >>"$history_file"
	else
		echo "$cmd" >>"$history_file"
	fi
done
