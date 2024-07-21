$ErrorActionPreference = "SilentlyContinue"

function Install-Item {
  param (
    [string]$name,
    [string]$path,
    [string]$command,
    [string]$additional
  )
  if (-not (Test-Path $path)) {
    Write-Warning "File not found $path"
    return
  }
  try {
    if ($name) {
      Write-Host "Installing $name."
    }
    Get-Content $path | ForEach-Object {
      if ($additional) {
        Invoke-Expression "$command $_ $additional"
      } else {
        Invoke-Expression "$command $_"
      }
    }
  }
  catch {
    Write-Error "Error occurred while installing $name."
  }
}

function Uninstall-Item {
  param (
    [string]$name,
    [string]$path,
    [string]$command
  )
  if (-not (Test-Path $path)) {
    Write-Warning "File not found $path"
    return
  }
  try {
    if ($name) {
      Write-Host "Uninstalling $name."
    }
    Get-Content $path | ForEach-Object {
      Invoke-Expression "$command $_"
    }
  }
  catch {
    Write-Error "Error occurred while uninstalling $name."
  }
}

function Install-PowerShell {
  if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "Installing powershell."
    winget install --id Microsoft.Powershell -s winget
  }
  Install-Item -name "powershell modules" -path "$PSScriptRoot/.requirement/powershell.txt" -command "Install-Module -Name" -additional "-Scope CurrentUser -AllowClobber -Force"
}

function Uninstall-PowerShell {
  Uninstall-Item -name "powershell modules" -path "$PSScriptRoot/.requirement/powershell.txt" -command "Uninstall-Module -Name"
}

function Install-Scoop {
  if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing scoop."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
  }
  Install-Item -name "scoop buckets" -path "$PSScriptRoot/.requirement/scoop_bucket.txt" -command "scoop bucket add"
  Install-Item -name "scoop packages" -path "$PSScriptRoot/.requirement/scoop_package.txt" -command "scoop install"
  Install-Item -name "scoop applications" -path "$PSScriptRoot/.requirement/scoop_application.txt" -command "scoop install"
  Install-Item -name "scoop fonts" -path "$PSScriptRoot/.requirement/scoop_font.txt" -command "scoop install"
}

function Uninstall-Scoop {
  Uninstall-Item -name "scoop packages" -path "$PSScriptRoot/.requirement/scoop_package.txt" -command "scoop uninstall"
  Uninstall-Item -name "scoop applications" -path "$PSScriptRoot/.requirement/scoop_application.txt" -command "scoop uninstall"
  Uninstall-Item -name "scoop fonts" -path "$PSScriptRoot/.requirement/scoop_font.txt" -command "scoop uninstall"
}

function Install-Nvm {
  if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    Write-Warning "nvm is not installed."
    return
  }
  Write-Host "Installing node.js lts version."
  nvm install lts
  Write-Host "Using node.js lts version."
  nvm use lts
}

function Uninstall-Nvm {
  if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    Write-Warning "nvm is not installed."
    return
  }
  Write-Host "Uninstalling node.js lts version."
  nvm uninstall lts
}

function Install-Npm {
  if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Warning "npm is not installed."
    return
  }
  Install-Item -name "npm packages" -path "$PSScriptRoot/.requirement/npm.txt" -command "npm install -g"
}

function Uninstall-Npm {
  if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Warning "npm is not installed."
    return
  }
  Uninstall-Item -name "npm packages" -path "$PSScriptRoot/.requirement/npm.txt" -command "npm uninstall -g"
}

function Install-VisualStudioCodeExtension {
  if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Warning "visual studio code is not installed."
    return
  }
  Install-Item -name "visual studio code extensions" -path "$PSScriptRoot/.requirement/visual_studio_code.txt" -command "code --install-extension" -additional "--force"
}

function Uninstall-VisualStudioCodeExtension {
  if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Warning "visual studio code is not installed."
    return
  }
  Uninstall-Item -name "visual studio code extensions" -path "$PSScriptRoot/.requirement/visual_studio_code.txt" -command "code --uninstall-extension"
}

function Install-All {
  Install-PowerShell
  Install-Scoop
  Install-Nvm
  Install-Npm
  Install-VisualStudioCodeExtension
}

function Uninstall-All {
  Uninstall-PowerShell
  Uninstall-Scoop
  Uninstall-Nvm
  Uninstall-Npm
  Uninstall-VisualStudioCodeExtension
}

function Set-Config {
  param (
  [string]$name,
  [string]$source_path,
  [string]$destination_path,
  [string[]]$files = @()
  [string[]]$extensions = @(),
  )
  if ($name) {
    Write-Host "Configuring $name setting."
  }
  try {
    if (Test-Path $destination_path) {
      foreach ($file in $files) {
        Get-ChildItem -Path "$destination_path" -Filter "$file" -Recurse | Remove-Item -Recurse -Force
      }
      foreach ($extension in $extensions) {
        Get-ChildItem -Path "$destination_path" -Filter "*$extension" -Recurse | Remove-Item -Recurse -Force
      }
    } else {
      New-Item -Path "$destination_path" -ItemType Directory -Force | Out-Null
    }
    if ((Get-Item $source_path).PSIsContainer) {
      Copy-Item -Path "$source_path/*" -ErrorAction SilentlyContinue -Destination "$destination_path" -Recurse -Force
    } else {
      Copy-Item -Path $source_path -ErrorAction SilentlyContinue -Destination $destination_path -Force
    }
  }
  catch {
    Write-Error "Error occurred while configuring $name setting."
  }
}

function Remove-Config {
  param (
  [string]$name,
  [string]$destination_path,
  [string[]]$files = @()
  [string[]]$extensions = @(),
  )
  if ($name) {
    Write-Host "Removing $name setting."
  }
  try {
    if (Test-Path $destination_path) {
      foreach ($file in $files) {
        Get-ChildItem -Path "$destination_path" -Filter "$file" -Recurse | Remove-Item -Recurse -Force
      }
      foreach ($extension in $extensions) {
        Get-ChildItem -Path "$destination_path" -Filter "*$extension" -Recurse | Remove-Item -Recurse -Force
      }
    }
  }
  catch {
    Write-Error "Error occurred while removing $name setting."
  }
}

function ConfigurePowerShellSetting {
  $module_paths = Get-Module -ListAvailable | Select-Object -ExpandProperty Path
  foreach ($module_path in $module_paths) {
    if ($module_path -like "*Documents\*") {
      $path = "$ENV:USERPROFILE\Documents"
    } elseif ($module_path -like "*OneDrive\Documents\*") {
      $path = "$ENV:USERPROFILE\OneDrive\Documents"
    }
  }
  if ($PSVersionTable.PSEdition -eq "Desktop") {
    $editions = $("WindowsPowerShell", "PowerShell")
  } elseif ($PSVersionTable.PSEdition -eq "Core") {
    $editions = $("PowerShell", "WindowsPowerShell")
  }
  Write-Host "Configuring powershell setting."
  foreach ($edition in $editions) {
    Set-Config -source_path "$PSScriptRoot/.config/powershell" -destination_path "$path/$edition" -files_extension @(".txt", ".json", ".ps1")
  }
  Copy-Item -Path "$path/$($editions[0])/Modules" -ErrorAction SilentlyContinue -Destination "$path/$($editions[1])" -Recurse -Force
}

function RemovePowerShellSetting {
  $module_paths = Get-Module -ListAvailable | Select-Object -ExpandProperty Path
  foreach ($path in $module_paths) {
    if ($path -like "*Documents\*") {
      $powershell_path = "$ENV:USERPROFILE\Documents"
    } elseif ($path -like "*OneDrive\Documents\*") {
      $powershell_path = "$ENV:USERPROFILE\OneDrive\Documents"
    }
  }
  Remove-Config -app_name "windows powershell" -destination_path "$powershell_path/WindowsPowerShell"
  Remove-Config -app_name "powershell" -destination_path "$powershell_path/PowerShell"
}

function ConfigureWindowsTerminalSetting {
  Set-Config -app_name "windows terminal" -source_path "$PSScriptRoot/.config/windows terminal" -destination_path "$ENV:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" -files @("settings.json")
}

function RemoveWindowsTerminalSetting {
  Remove-Config -app_name "windows terminal" -destination_path "$ENV:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" -files @("settings.json")
}

function ConfigureVimSetting {
  Set-Config -app_name "vim" -source_path "$PSScriptRoot/.config/vim" -destination_path "$ENV:USERPROFILE" -files @(".vimrc")
}

function RemoveVimSetting {
  Remove-Config -app_name "vim" -destination_path "$ENV:USERPROFILE" -files @(".vimrc")
}

function ConfigureNeovimSetting {
  Set-Config -app_name "neovim" -source_path "$PSScriptRoot/.config/nvim" -destination_path "$ENV:USERPROFILE/AppData/Local/nvim"
}

function RemoveNeovimSetting {
  Remove-Config -app_name "neovim" -destination_path "$ENV:USERPROFILE/AppData/Local/nvim"
}

function ConfigureVisualStudioCodeSetting {
  if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Warning "visual studio code is not installed."
    return
  }
  $installed_paths = Get-Command code -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path
  foreach ($path in $installed_paths) {
    if ($path -like "*Microsoft VS Code\*") {
      $vscode_path = "$ENV:USERPROFILE/AppData/Roaming/Code/User"
    } elseif ($path -like "*scoop\apps\vscode\current\*") {
      $vscode_path = "$ENV:USERPROFILE/scoop/apps/vscode/current/data/user-data/User"
    }
  }
  Set-Config -app_name "visual studio code" -source_path "$PSScriptRoot/.config/vscode" -destination_path "$vscode_path" -files_extension @(".json")
}

function RemoveVisualStudioCodeSetting {
  if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Warning "visual studio code is not installed."
    return
  }
  $installed_paths = Get-Command code -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path
  foreach ($path in $installed_paths) {
    if ($path -like "*Microsoft VS Code\*") {
      $vscode_path = "$ENV:USERPROFILE/AppData/Roaming/Code/User"
    } elseif ($path -like "*scoop\apps\vscode\current\*") {
      $vscode_path = "$ENV:USERPROFILE/scoop/apps/vscode/current/data/user-data/User"
    }
  }
  Remove-Config -app_name "visual studio code" -destination_path "$vscode_path" -files_extension @(".json")
}

function ConfigureScriptSetting {
  Set-Config -app_name "script" -source_path "$PSScriptRoot/.script" -destination_path "$ENV:USERPROFILE/AppData/Local/script"
}

function RemoveScriptSetting {
  Remove-Config -app_name "script" -destination_path "$ENV:USERPROFILE/AppData/Local/script"
}

function ConfigureGitSetting {
  Set-Config -app_name "git" -source_path "$PSScriptRoot/.gitconfig" -destination_path "$ENV:USERPROFILE" -files @(".gitconfig")
}

function RemoveGitSetting {
  Remove-Config -app_name "git" -destination_path "$ENV:USERPROFILE" -files @(".gitconfig")
}

function ConfigureLazyGitSetting {
  Set-Config -app_name "lazygit" -source_path "$PSScriptRoot/.config/lazygit" -destination_path "$ENV:USERPROFILE/AppData/Local/lazygit"
}

function RemoveLazyGitSetting {
  Remove-Config -app_name "lazygit" -destination_path "$ENV:USERPROFILE/AppData/Local/lazygit"
}

function ConfigureCommitizenSetting {
  Set-Config -app_name "commitizen" -source_path "$PSScriptRoot/.config/commitizen" -destination_path "$ENV:USERPROFILE" -files @(".czrc")
}

function RemoveCommitizenSetting {
  Remove-Config -app_name "commitizen" -destination_path "$ENV:USERPROFILE" -files @(".czrc")
}

function ConfigurePythonSetting {
  Set-Config -app_name "python" -source_path "$PSScriptRoot/.config/pip" -destination_path "$ENV:USERPROFILE/AppData/Local/pip"
}

function RemovePythonSetting {
  Remove-Config -app_name "python" -destination_path "$ENV:USERPROFILE/AppData/Local/pip"
}

function ConfigureAllAppicationSetting {
  Write-Host "Configuring all applications setting."
}

function RemoveAllAppicationSetting {
  Write-Host "Removing all applications setting."
}

function MainMenu {
  Get-Content "$PSScriptRoot/ascii.txt" -Encoding utf8
  Write-Host "q/Q. Quit."
  Write-Host ""
}

function Main {
  do {
    MainMenu
    $choice = Read-Host "Enter your choice"
    switch ($choice.ToLower()) {
      "q" { return }
      default { Write-Warning "Invalid choice. Please try again." }
    }
  } while ($true)
}

Main
