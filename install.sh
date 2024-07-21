#!/bin/bash

dir="$(dirname "$0")"

function InstallCommand() {
  local name=""
  local file_path=""
  local command=""
  local additional=""
  while "$#" -gt 0; do
    case $1 in
    -name)
      name="$2"
      shift
      ;;
    -file_path)
      file_path="$2"
      shift
      ;;
    -command)
      command="$2"
      shift
      ;;
    -additional)
      additional="$2"
      shift
      ;;
    esac
    shift
  done
  if ! -f "$file_path"; then
    echo "File not found $file_path."
    return
  fi
  {
    if -n "$name"; then
      echo "Installing $name."
    fi
    for line in $(cat "$file_path"); do
      if -n "$additional"; then
        eval "$command $line $additional"
      else
        eval "$command $line"
      fi
    done
  } || {
    echo "Error occurred while installing $name command."
  }
}

function UninstallCommand {
  local name=""
  local file_path=""
  local command=""
  while "$#" -gt 0; do
    case $1 in
    -name)
      name="$2"
      shift
      ;;
    -file_path)
      file_path="$2"
      shift
      ;;
    -command)
      command="$2"
      shift
      ;;
    esac
    shift
  done
  {
    if -n "$name"; then
      echo "Uninstalling $name."
    fi
    for line in $(cat "$file_path"); do
      eval "$command $line"
    done
  } || {
    echo "Error occurred while uninstalling $name command."
  }
}

function InstallHomebrew() {
  if ! command -v brew &>/dev/null; then
    echo "Installing homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  InstallCommand -name "homebrew packages" -file_path "$dir/.requirement/brew.txt" -command "brew install"
  InstallCommand -name "homebrew applications" -file_path "$dir/.requirement/brew_application.txt" -command "brew install --cask"
  InstallCommand -name "homebrew fonts" -file_path "$dir/.requirement/brew_font.txt" -command "brew install"
}

function UninstallHomebrew() {
  UninstallCommand -name "homebrew packages" -file_path "$dir/.requirement/brew.txt" -command "brew uninstall"
  UninstallCommand -name "homebrew applications" -file_path "$dir/.requirement/brew_application.txt" -command "brew uninstall --cask"
  UninstallCommand -name "homebrew fonts" -file_path "$dir/.requirement/brew_font.txt" -command "brew uninstall"
}

function InstallVisualStudioCodeExtension() {
  if ! command -v code &>/dev/null; then
    echo "visual studio code is not installed."
    return
  fi
  InstallCommand -name "visual studio code extensions" -file_path "$dir/.requirement/visual_studio_code.txt" -command "code --install-extension" -additional "--force"
}

function UninstallVisualStudioCodeExtension() {
  if ! command -v code &>/dev/null; then
    echo "visual studio code is not installed."
    return
  fi
  UninstallCommand -name "visual studio code extensions" -file_path "$dir/.requirement/visual_studio_code.txt" -command "code --uninstall-extension"
}

function SetFishAsDefaultShell() {
  if ! grep -q "$(which fish)" /etc/shells; then
    echo "Adding fish shell to the list of known shells."
    sudo sh -c 'echo "$(which fish)" >> /etc/shells'
  fi
  chsh -s "$(which fish)"
  fish -c 'fish_add_path (dirname (which brew))'
  echo "Please restart your terminal for changes to take effect."
}

function DeleteFishAsDefaultShell() {
  if grep -q "$(which fish)" /etc/shells; then
    echo "Removing fish shell from the list of known shells."
    sudo sed -i '' "/$(which fish)/d" /etc/shells
  fi
  chsh -s "$(which zsh)"
  echo "Please restart your terminal for changes to take effect."
}

function ConfigureApplication() {
  local app_name=""
  local source_path=""
  local destination_path=""
  local files_extensions=()
  local files=()
  while "$#" -gt 0; do
    case $1 in
    -app_name)
      app_name="$2"
      shift
      ;;
    -source_path)
      source_path="$2"
      shift
      ;;
    -destination_path)
      destination_path="$2"
      shift
      ;;
    -files_extensions)
      IFS=',' read -ra files_extensions <<<"$2"
      shift
      ;;
    -files)
      IFS=',' read -ra files <<<"$2"
      shift
      ;;
    esac
    shift
  done
  {
    if -n "$app_name"; then
      echo "Configuring $app_name setting."
    fi
    if -d "$destination_path"; then
      for extension in "${files_extensions[@]}"; do
        find "$destination_path" -type f -name "*$extension" -delete
      done
      for file in "${files[@]}"; do
        find "$destination_path" -type f -name "$file" -delete
      done
    else
      mkdir -p "$destination_path"
    fi
    if -d "$source_path"; then
      cp -R "$source_path/." "$destination_path"
    elif -f "$source_path"; then
      cp "$source_path" "$destination_path"
    fi
  } || {
    echo "Error occurred while configuring $app_name setting."
  }
}

function RemoveApplicationSetting() {
  local app_name=""
  local destination_path=""
  local files_extensions=()
  local files=()
  while "$#" -gt 0; do
    case $1 in
    -app_name)
      app_name="$2"
      shift
      ;;
    -destination_path)
      destination_path="$2"
      shift
      ;;
    -files_extensions)
      IFS=',' read -ra files_extensions <<<"$2"
      shift
      ;;
    -files)
      IFS=',' read -ra files <<<"$2"
      shift
      ;;
    esac
    shift
  done
  {
    if -n "$app_name"; then
      echo "Removing $app_name setting."
    fi
    if -d "$destination_path"; then
      for extension in "${files_extensions[@]}"; do
        find "$destination_path" -type f -name "*$extension" -delete
      done
      for file in "${files[@]}"; do
        find "$destination_path" -type f -name "$file" -delete
      done
    fi
  } || {
    echo "Error occurred while removing $app_name setting."
  }
}

function ConfigureFishSetting() {
  ConfigureApplication -app_name "fish" -source_path "$dir/.config/fish" -destination_path "$HOME/.config/fish"
}

function RemoveFishSetting() {
  RemoveApplicationSetting -app_name "fish" -destination_path "$HOME/.config/fish"
}

function ConfigureTmuxSetting() {
  ConfigureApplication -app_name "tmux" -source_path "$dir/.config/tmux" -destination_path "$HOME/.config/tmux"
}

function RemoveTmuxSetting() {
  RemoveApplicationSetting -app_name "tmux" -destination_path "$HOME/.config/tmux"
}

function ConfigureVimSetting() {
  ConfigureApplication -app_name "vim" -source_path "$dir/.config/vim" -destination_path "$HOME" -files ".vimrc"
}

function RemoveVimSetting() {
  RemoveApplicationSetting -app_name "vim" -destination_path "$HOME" -files ".vimrc"
}

function ConfigureNeovimSetting() {
  ConfigureApplication -app_name "neovim" -source_path "$dir/.config/nvim" -destination_path "$HOME/.config/nvim"
}

function RemoveNeovimSetting() {
  RemoveApplicationSetting -app_name "neovim" -destination_path "$HOME/.config/nvim"
}

function ConfigureScriptSetting() {
  ConfigureApplication -app_name "script" -source_path "$dir/.script" -destination_path "$HOME/.script"
}

function RemoveScriptSetting() {
  RemoveApplicationSetting -app_name "script" -destination_path "$HOME/.script"
}

function ConfigureGitSetting() {
  ConfigureApplication -app_name "git" -source_path "$dir/.gitconfig" -destination_path "$HOME" -files ".gitconfig"
}

function RemoveGitSetting() {
  RemoveApplicationSetting -app_name "git" -destination_path "$HOME" -files ".gitconfig"
}

function ConfigureLazygitSetting() {
  ConfigureApplication -app_name "lazygit" -source_path "$dir/.config/lazygit" -destination_path "$HOME/.config/lazygit"
}

function RemoveLazygitSetting() {
  RemoveApplicationSetting -app_name "lazygit" -destination_path "$HOME/.config/lazygit"
}

function ConfigureCommitizenSetting() {
  ConfigureApplication -app_name "commitizen" -source_path "$dir/.config/commitizen" -destination_path "$HOME" -files ".czrc"
}

function RemoveCommitizenSetting() {
  RemoveApplicationSetting -app_name "commitizen" -destination_path "$HOME" -files ".czrc"
}

function ConfigurePythonSetting() {
  ConfigureApplication -app_name "python" -source_path "$dir/.config/pip" -destination_path "$HOME/.config/pip"
}

function RemovePythonSetting() {
  RemoveApplicationSetting -app_name "python" -destination_path "$HOME/.config/pip"
}

function ConfigureVisualStudioCodeSetting() {
  if ! command -v code &>/dev/null; then
    echo "visual studio code is not installed."
    return
  fi
  ConfigureApplication -app_name "visual studio code" -source_path "$dir/.config/vscode" -destination_path "$HOME/Library/Application Support/Code/User"
}

function RemoveVisualStudioCodeSetting() {
  RemoveApplicationSetting -app_name "visual studio code" -destination_path "$HOME/Library/Application Support/Code/User"
}

# function ConfigureAllApplicationsSetting() {
# }

# function RemoveAllApplicationSetting() {
# }

function MainMenu() {
  cat "$dir/ascii.txt"
}

function Main() {
  while true; do
    MainMenu
    read -p "Choose an option: " option
    case $option in
    q | Q)
      break
      ;;
    *)
      echo "Invalid option. Please try again."
      ;;
    esac
  done
}

Main
