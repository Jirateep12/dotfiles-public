set fish_greeting ""

set -gx term xterm-256color
set -gx editor nvim

set -gx path bin $path
set -gx path $HOME/bin $path
set -gx path $HOME/.local/bin $path
set -gx path node_modules/.bin $path
set -gx path $HOME/go/bin $path

set fish_prompt_pwd_dir_length 1

set -g theme_color_scheme terminal-dark
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

alias vim nvim
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
alias lg lazygit
alias pip pip3
alias ide "$HOME/.script/ide.sh"
alias youtube_download "$HOME/.script/youtube_download.sh"
alias cleanup_directories "$HOME/.script/cleanup_directories.sh"
alias initialize_command_history "$HOME/.script/initialize_command_history.sh"
alias resize_dock "$HOME/.script/resize_dock.sh"

python3 "$HOME/.script/filter_history.py"

if test -d /opt/homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"
end

if not test -d "$HOME/Developers"
  mkdir -p "$HOME/Developers"
end

switch (uname)
case Darwin
  source (dirname (status --current-filename))/config_osx.fish
case Linux
  source (dirname (status --current-filename))/config_linux.fish
end

export XDG_CONFIG_HOME="$HOME/.config"
