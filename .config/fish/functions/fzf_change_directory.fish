function _fzf_change_directory
    fzf | perl -pe 's/([ ()])/\\\\$1/g' | read foo
    if [ $foo ]
        builtin cd $foo
        commandline -r ''
        commandline -f repaint
    else
        commandline ''
    end
end

function fzf_change_directory
    begin
        echo $HOME
        echo $HOME/.config
        echo $HOME/.local/share
        echo $HOME/Developers
        if not test -d $HOME/Developers
            mkdir -p $HOME/Developers
        end
        if test (count $HOME/Developers/.*) -gt 0
            ls -ad $HOME/Developers/.* | grep -v -e '\.git' -e '\.DS_Store'
        end
        if test (count $HOME/Developers/*) -gt 0
            ls -ad $HOME/Developers/* | grep -v -e '\.git' -e '\.DS_Store'
        end
        if test (count $PWD/*) -gt 0
            ls -ad $PWD/* | grep -v -e '\.git' -e '\.DS_Store'
        end
    end | sed -e 's/\/$//' | awk '!a[$0]++' | _fzf_change_directory $argv
end
