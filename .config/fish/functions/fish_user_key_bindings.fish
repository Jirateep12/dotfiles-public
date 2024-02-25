function fish_user_key_bindings
    bind \cf fzf_change_directory
    bind \cl forward-char
    bind \cd delete-char
end

if test -e "$HOME/.config/fish/functions/fzf_configure_bindings.fish"
    fzf_configure_bindings --directory=\co
end
