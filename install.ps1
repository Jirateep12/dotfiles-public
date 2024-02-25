$ErrorActionPreference = "slentlycontinue"

function Install-Powershell {
  winget install --id Microsoft.Powershell -s winget
  Write-Host "Installing powershell modules."
  $requirements = Get-Content "$PSScriptRoot/.requirements/powershell.txt"
  $requirements | ForEach-Object {
    Install-Module -Name $_ -Scope CurrentUser -AllowClobber -Force
  }
}

function Install-Scoop {
  if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing scoop."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
  }
  Write-Host "Installing scoop buckets."
  $requirements = Get-Content "$PSScriptRoot/.requirements/scoop_bucket.txt"
  $requirements | ForEach-Object {
    scoop bucket add $_
  }
  Write-Host "Installing scoop packages."
  $requirements = Get-Content "$PSScriptRoot/.requirements/scoop.txt"
  $requirements | ForEach-Object {
    scoop install $_
  }
  Write-Host "Installing scoop applications."
  $requirements = Get-Content "$PSScriptRoot/.requirements/scoop_application.txt"
  $requirements | ForEach-Object {
    scoop install $_
  }
  Write-Host "Installing scoop fonts."
  $requirements = Get-Content "$PSScriptRoot/.requirements/scoop_font.txt"
  $requirements | ForEach-Object {
    scoop install $_
  }
}

function Install-Nvm {
  if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    Write-Host "Nvm is not installed."
    return 1
  }
  Write-Host "Installing node.js lts version."
  nvm install lts
  Write-Host "Using node.js lts version."
  nvm use lts
  if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "Npm is not installed."
    return 1
  }
  Write-Host "Installing npm packages."
  $requirements = Get-Content "$PSScriptRoot/.requirements/npm.txt"
  $requirements | ForEach-Object {
    npm install -g $_
  }
  Write-Host "Configuring commitizen."
  Set-Content "$ENV:USERPROFILE/.czrc" '{ "path": "cz-conventional-changelog" }'
}

function Install-VisualStudioCodeExtensions {
  if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "Visual studio code is not installed."
    return 1
  }
  Write-Host "Installing visual studio code extensions."
  $requirements = Get-Content "$PSScriptRoot/.requirements/visual_studio_code.txt"
  $requirements | ForEach-Object {
    code --install-extension $_
  }
}

function Configure-Powershell {
  $module_path = Get-Module -ListAvailable | Select-Object -ExpandProperty Path
  if ($module_path -like "*Documents\*") {
    $powershell_path = "$ENV:USERPROFILE/Documents"
  } elseif ($module_path -like "*OneDrive\Documents\*") {
    $powershell_path = "$ENV:USERPROFILE/OneDrive/Documents"
  } else {
    Write-Host "Invalid powershell module path."
    return 1
  }
  Write-Host "Configuring powershell."
  if ($PSHOME -match "\\WindowsPowerShell") {
    Get-ChildItem -Path "$powershell_path/WindowsPowerShell", "$powershell_path/PowerShell" -ErrorAction SilentlyContinue | Where-Object Extension -in @(".txt", ".json", ".ps1") | Remove-Item -Recurse -Force
    New-Item -Path "$powershell_path/WindowsPowerShell", "$powershell_path/PowerShell" -ItemType Directory -Force
    Copy-Item -Path "$PSScriptRoot/.config/powershell/*" -Destination "$powershell_path/WindowsPowerShell" -Recurse -Force
    Rename-Item -Path "$powershell_path/WindowsPowerShell/microsoft.powershell_profile.ps1" -NewName "Microsoft.PowerShell_profile.ps1" -Force
    Copy-Item -Path "$powershell_path/WindowsPowerShell/*" -Destination "$powershell_path/PowerShell" -Recurse -Force
  } else {
    Get-ChildItem -Path "$powershell_path/PowerShell", "$powershell_path/WindowsPowerShell" -ErrorAction SilentlyContinue | Where-Object Extension -in @(".txt", ".json", ".ps1") | Remove-Item -Recurse -Force
    New-Item -Path "$powershell_path/PowerShell", "$powershell_path/WindowsPowerShell" -ItemType Directory -Force
    Copy-Item -Path "$PSScriptRoot/.config/powershell/*" -Destination "$powershell_path/PowerShell" -Recurse -Force
    Rename-Item -Path "$powershell_path/PowerShell/microsoft.powershell_profile.ps1" -NewName "Microsoft.PowerShell_profile.ps1" -Force
    Copy-Item -Path "$powershell_path/PowerShell/*" -Destination "$powershell_path/WindowsPowerShell" -Recurse -Force
  }
}

function Configure-WindowsTerminal {
  Write-Host "Configuring windows terminal."
  Get-ChildItem -Path "$ENV:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" -ErrorAction SilentlyContinue | Where-Object Name -in "settings.json" | Remove-Item -Recurse -Force
  New-Item -Path "$ENV:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" -ItemType Directory -Force
  Copy-Item -Path "$PSScriptRoot/.config/windows_terminal/*" -Destination "$ENV:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" -Recurse -Force
}

function Configure-Vim {
  Write-Host "Configuring vim."
  Get-ChildItem -Path "$ENV:USERPROFILE" -ErrorAction SilentlyContinue | Where-Object Name -in ".vimrc" | Remove-Item -Recurse -Force
  Copy-Item -Path "$PSScriptRoot/.config/vim/*" -Destination "$ENV:USERPROFILE" -Recurse -Force
}

function Configure-Neovim {
  Write-Host "Configuring neovim."
  Get-ChildItem -Path "$ENV:USERPROFILE/AppData/Local/nvim" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
  New-Item -Path "$ENV:USERPROFILE/AppData/Local/nvim" -ItemType Directory -Force
  Copy-Item -Path "$PSScriptRoot/.config/nvim/*" -Destination "$ENV:USERPROFILE/AppData/Local/nvim" -Recurse -Force
}

function Configure-Script {
  Write-Host "Configuring script."
  Get-ChildItem -Path "$ENV:USERPROFILE/AppData/Local/script" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
  New-Item -Path "$ENV:USERPROFILE/AppData/Local/script" -ItemType Directory -Force
  Copy-Item -Path "$PSScriptRoot/.script/*" -Destination "$ENV:USERPROFILE/AppData/Local/script" -Recurse -Force
}

function Configure-Git {
  Write-Host "Configuring git."
  Get-ChildItem -Path "$ENV:USERPROFILE" -ErrorAction SilentlyContinue | Where-Object Name -in ".gitconfig" | Remove-Item -Recurse -Force
  Copy-Item -Path "$PSScriptRoot/.gitconfig" -Destination "$ENV:USERPROFILE" -Recurse -Force
}

function Configure-LazyGit {
  Write-Host "Configuring lazygit."
  Get-ChildItem -Path "$ENV:USERPROFILE/AppData/Local/lazygit" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
  New-Item -Path "$ENV:USERPROFILE/AppData/Local/lazygit" -ItemType Directory -Force
  Copy-Item -Path "$PSScriptRoot/.config/lazygit/*" -Destination "$ENV:USERPROFILE/AppData/Local/lazygit" -Recurse -Force
}

function Configure-Python {
  Write-Host "Configuring python."
  Get-ChildItem -Path "$ENV:USERPROFILE/AppData/Local/pip" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
  New-Item -Path "$ENV:USERPROFILE/AppData/Local/pip" -ItemType Directory -Force
  Copy-Item -Path "$PSScriptRoot/.config/pip/*" -Destination "$ENV:USERPROFILE/AppData/Local/pip" -Recurse -Force
}

function Configure-VisualStudioCode {
  if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Warning "Visual studio code is not installed."
    return 1
  }
  $installed_path = Get-Command code | Select-Object -ExpandProperty Path
  if ($installed_path -like "*Microsoft VS Code\*") {
    $vscode_path = "$ENV:USERPROFILE/AppData/Roaming/Code/User"
  } elseif ($installed_path -like "*scoop\apps\vscode\current\*") {
    $vscode_path = "$ENV:USERPROFILE/scoop/apps/vscode/current/data/user-data/User"
  } else {
    Write-Host "Invalid visual studio code path."
    return 1
  }
  Write-Host "Configuring visual studio code."
  Get-ChildItem -Path "$vscode_path" -ErrorAction SilentlyContinue | Where-Object Extension -in ".json" | Remove-Item -Recurse -Force
  New-Item -Path "$vscode_path" -ItemType Directory -Force
  Copy-Item -Path "$PSScriptRoot/.config/vscode/*" -Destination "$vscode_path" -Recurse -Force
}

function Check-Os {
  if ($env:OS -ne "Windows_NT") {
    Write-Warning "This script does not support the os."
    return 1
  }
}

function Show-Menu {
  Get-Content "$PSScriptRoot/ascii.txt" -Raw -Encoding utf8
  Write-Host "1. Install powershell."
  Write-Host "2. Install scoop."
  Write-Host "3. Install nvm."
  Write-Host "4. Install visual studio code extensions."
  Write-Host "5. Configure powershell."
  Write-Host "6. Configure windows terminal."
  Write-Host "7. Configure vim."
  Write-Host "8. Configure neovim."
  Write-Host "9. Configure script."
  Write-Host "10. Configure git."
  Write-Host "11. Configure lazygit."
  Write-Host "12. Configure python."
  Write-Host "13. Configure visual studio code."
  Write-Host "14. Configure all."
  Write-Host "q. Quit."
  Write-Host ""
}

do {
  Check-Os
  Show-Menu
  $choice = Read-Host "Enter your choice"
  switch ($choice) {
    "1" { Install-Powershell }
    "2" { Install-Scoop }
    "3" { Install-Nvm }
    "4" { Install-VisualStudioCodeExtensions }
    "5" { Configure-Powershell }
    "6" { Configure-WindowsTerminal }
    "7" { Configure-Vim }
    "8" { Configure-Neovim }
    "9" { Configure-Script }
    "10" { Configure-Git }
    "11" { Configure-LazyGit }
    "12" { Configure-Python }
    "13" { Configure-VisualStudioCode }
    "14" {
      Configure-Powershell
      Configure-WindowsTerminal
      Configure-Vim
      Configure-Neovim
      Configure-Script
      Configure-Git
      Configure-LazyGit
      Configure-Python
      Configure-VisualStudioCode
    }
    "q" { break }
    default { Write-Warning "Invalid choice. Please try again." }
  }
} while ($choice -ne "q")
