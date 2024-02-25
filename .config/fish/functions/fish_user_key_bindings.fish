function fish_user_key_bindings
    bind \cf fzf_change_directory
    bind \cl forward-char
    bind \cd delete-char
end

fzf_configure_bindings --directory=\co
