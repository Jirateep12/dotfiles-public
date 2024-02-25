if type -q eza
    alias ll "eza -l -g --icons"
    alias lla "ll -a"
end

set -g fzf_preview_file_cmd "bat --style=numbers --color=always --line-range :500"
set -g fzf_legacy_keybindings 0
