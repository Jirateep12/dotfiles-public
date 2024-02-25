function _fzf_change_directory
    fzf | perl -pe 's/([ ()])/\\\\$1/g' | read argv
    if [ $argv ]
        builtin cd $argv
        commandline -r ''
        commandline -f repaint
    else
        commandline ''
    end
end

function fzf_change_directory
    begin
        echo $HOME
        find $HOME/Developers -type d -maxdepth 1
        find $PWD -type d -maxdepth 1
    end |
        sed -e 's/\/$//' |
        awk '!a[$0]++' |
        _fzf_change_directory $argv
end
