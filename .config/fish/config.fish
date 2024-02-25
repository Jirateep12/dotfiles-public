set fish_greeting ""

set -gx TERM xterm-256color

set -g theme_color_scheme terminal-dark

set -g fish_prompt_pwd_dir_length 1

set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

alias vim nvim
alias ide $HOME/.config/script/ide.sh
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
alias pip pip3
alias ytd $HOME/.config/script/yt-download.sh
alias cleanup "sudo $HOME/.config/script/cleanup.sh"
alias initial-command $HOME/.config/script/initial-command.sh
alias set-dock $HOME/.config/script/dock.sh

python3 $HOME/.config/script/sort-history.py

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH $HOME/bin $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH node_modules/.bin $PATH
set -gx PATH $HOME/go/bin $PATH

switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end
