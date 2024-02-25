#!/bin/bash

function InstallHomebrew() {
  if [[ ! -x "$(command -v brew)" ]]; then
    echo "Installing homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  echo "Installing homebrew packages."
  while IFS= read -r package; do
    brew install "$package"
  done <"$PWD/.requirements/brew.txt"
  echo "Installing homebrew applications."
  while IFS= read -r app; do
    brew install --cask "$app"
  done <"$PWD/.requirements/brew_application.txt"
  echo "Installing homebrew fonts."
  while IFS= read -r font; do
    brew install "$font"
  done <"$PWD/.requirements/brew_font.txt"
}

function InstallVscodeExtensions() {
  if [[ ! -x "$(command -v code)" ]]; then
    echo "Visual studio code is not installed."
    return
  fi
  echo "Installing visual studio code extensions."
  while IFS= read -r extension; do
    code --install-extension "$extension"
  done <"$PWD/.requirements/visual_studio_code.txt"
}

function SetFishToDefaultShell() {
  echo "Add fish shell to the list of known shells."
  if ! grep -q "$(which fish)" /etc/shells; then
    echo "Adding fish shell to the list of known shells."
    sudo sh -c 'echo "$(which fish)" >> /etc/shells'
  else
    echo "Fish shell is already in the list of known shells."
  fi
  echo "Set fish shell as the default shell."
  chsh -s "$(which fish)"
  echo "Add homebrew binaries to fish shell's path."
  fish -c 'fish_add_path (dirname (which brew))'
  echo "Please restart your terminal for changes to take effect."
}

function ConfigureFish() {
  echo "Configuring fish."
  find "$HOME/.config/fish" -delete
  mkdir -p "$HOME/.config/fish"
  cp -r "$PWD/.config/fish/." "$HOME/.config/fish"
}

function ConfigureTmux() {
  echo "Configuring tmux."
  find "$HOME/.config/tmux" -delete
  mkdir -p "$HOME/.config/tmux"
  cp -r "$PWD/.config/tmux/." "$HOME/.config/tmux"
}

function ConfigureVim() {
  echo "Configuring vim."
  find "$HOME/.vimrc" -type f -delete
  cp -r "$PWD/.config/vim/." "$HOME"
}

function ConfigureNeovim() {
  echo "Configuring neovim."
  find "$HOME/.config/nvim" -delete
  mkdir -p "$HOME/.config/nvim"
  cp -r "$PWD/.config/nvim/." "$HOME/.config/nvim"
}

function ConfigureScript() {
  echo "Configuring scripts."
  find "$HOME/.script" -delete
  mkdir -p "$HOME/.script"
  cp -r "$PWD/.script/." "$HOME/.script"
  chmod +x "$HOME/.script/"*
}

function ConfigureGit() {
  echo "Configuring git."
  find "$HOME/.gitconfig" -type f -delete
  cp -r "$PWD/.gitconfig" "$HOME/.gitconfig"
}

function ConfigureLazygit() {
  echo "Configuring lazygit."
  find "$HOME/.config/lazygit" -delete
  mkdir -p "$HOME/.config/lazygit"
  cp -r "$PWD/.config/lazygit/." "$HOME/.config/lazygit"
}

function ConfigureCommitizen() {
  echo "Configuring commitizen."
  find "$HOME/.czrc" -type f -delete
  cp -r "$PWD/.config/commitizen/." "$HOME"
}

function ConfigurePython() {
  echo "Configuring python."
  find "$HOME/.config/pip" -delete
  mkdir -p "$HOME/.config/pip"
  cp -r "$PWD/.config/pip/." "$HOME/.config/pip"
}

function ConfigureVscode() {
  if [[ ! -x "$(command -v code)" ]]; then
    echo "Visual studio code is not installed."
    return
  fi
  echo "Configuring visual studio code."
  vscode_path="$HOME/Library/Application Support/Code/User"
  find "$vscode_path" -name "*.json" -type f -delete
  mkdir -p "$vscode_path"
  cp -r "$PWD/.config/vscode/." "$vscode_path"
}

function CheckOs() {
  if [[ ! "$OSTYPE" == "darwin"* ]]; then
    echo "This script does not support the os."
    exit 1
  fi
}

function ShowMenu() {
  cat "$PWD/ascii.txt"
  echo "1. Install homebrew."
  echo "2. Install visual studio code extensions."
  echo "3. Set fish to default shell."
  echo "4. Configure fish."
  echo "5. Configure tmux."
  echo "6. Configure vim."
  echo "7. Configure neovim."
  echo "8. Configure scripts."
  echo "9. Configure git."
  echo "10. Configure lazygit."
  echo "11. Configure commitizen."
  echo "12. Configure python."
  echo "13. Configure visual studio code."
  echo "14. Configure all."
  echo "q. Quit."
  echo ""
}

while true; do
  CheckOs
  ShowMenu
  read -r -p "Enter your choice: " choice
  case $choice in
  1) InstallHomebrew ;;
  2) InstallVscodeExtensions ;;
  3) SetFishToDefaultShell ;;
  4) ConfigureFish ;;
  5) ConfigureTmux ;;
  6) ConfigureVim ;;
  7) ConfigureNeovim ;;
  8) ConfigureScript ;;
  9) ConfigureGit ;;
  10) ConfigureLazygit ;;
  11) ConfigureCommitizen ;;
  12) ConfigurePython ;;
  13) ConfigureVscode ;;
  14)
    ConfigureFish
    ConfigureTmux
    ConfigureVim
    ConfigureNeovim
    ConfigureScript
    ConfigureGit
    ConfigureLazygit
    ConfigureCommitizen
    ConfigurePython
    ConfigureVscode
    ;;
  q) break ;;
  *) echo "Invalid choice. Please try again." ;;
  esac
done
