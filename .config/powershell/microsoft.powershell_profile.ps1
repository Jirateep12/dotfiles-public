[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$profile_omp = "$PSScriptRoot/jirateep12_black.omp.json"
oh-my-posh init pwsh --config $profile_omp | Invoke-Expression

Set-PSReadLineOption -EditMode Emacs -BellStyle None
Set-PSReadLineKeyHandler -Chord "enter" -Function ValidateAndAcceptLine
Set-PSReadLineKeyHandler -Chord "ctrl+d" -Function DeleteChar

Set-PsFzfOption -PSReadlineChordProvider "ctrl+f" -PSReadlineChordReverseHistory "ctrl+r"

Set-Alias vim "nvim"
Set-Alias g "git"
Set-Alias lg "lazygit"
Set-Alias pip "pip3"
Set-Alias grep "findstr"
Set-Alias tig "$ENV:USERPROFILE\scoop\apps\git\current\usr\bin\tig.exe"
Set-Alias less "$ENV:USERPROFILE\scoop\apps\git\current\usr\bin\less.exe"

$sort = $function:prompt

function prompt() {
  python3 "$ENV:USERPROFILE\AppData\Local\script\filter_history.py.py"
  &$sort
}

function ll() {
  eza -l -g --icons
}

function lla() {
  eza -l -g --icons -a
}

function ide() {
  sh $ENV:USERPROFILE\AppData\Local\script\ide.sh
}

function youtube_download() {
  sh $ENV:USERPROFILE\AppData\Local\script\youtube_download.sh
}

function cleanup_directories() {
  sh $ENV:USERPROFILE\AppData\Local\script\cleanup_directories.sh
}

function initialize_command_history() {
  sh $ENV:USERPROFILE\AppData\Local\script\initialize_command_history.sh
}

function resize_dock() {
  sh $ENV:USERPROFILE\AppData\Local\script\resize_dock.sh
}

function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
