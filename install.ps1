$ErrorActionPreference = "SilentlyContinue"

function InstallCommand {
  param (
    [string]$name,
    [string]$file_path,
    [string]$command,
    [string]$additional
  )
  if (-not (Test-Path $file_path)) {
    Write-Warning "File not found $file_path"
    return
  }
  try {
    if ($name) {
      Write-Host "Installing $name."
    }
    Get-Content $file_path | ForEach-Object {
      if ($additional) {
        Invoke-Expression "$command $_ $additional"
      } else {
        Invoke-Expression "$command $_"
      }
    }
  }
  catch {
    Write-Error "Error occurred while installing $name command."
  }
}

function UninstallCommand {
  param (
    [string]$name,
    [string]$file_path,
    [string]$command
  )
  if (-not (Test-Path $file_path)) {
    Write-Warning "File not found $file_path"
    return
  }
  try {
    if ($name) {
      Write-Host "Uninstalling $name."
    }
    Get-Content $file_path | ForEach-Object {
      Invoke-Expression "$command $_"
    }
  }
  catch {
    Write-Error "Error occurred while uninstalling $name command."
  }
}

function InstallPowerShell {
  if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "Installing powershell."
    winget install --id Microsoft.Powershell -s winget
  }
  InstallCommand -name "powershell modules" -file_path "$PSScriptRoot/.requirement/powershell.txt" -command "Install-Module -Name" -additional "-Scope CurrentUser -AllowClobber -Force"
}

function UninstallPowerShell {
  UninstallCommand -name "powershell modules" -file_path "$PSScriptRoot/.requirement/powershell.txt" -command "Uninstall-Module -Name"
}

function InstallScoop {
  if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing scoop."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
  }
  InstallCommand -name "scoop buckets" -file_path "$PSScriptRoot/.requirement/scoop_bucket.txt" -command "scoop bucket add"
  InstallCommand -name "scoop packages" -file_path "$PSScriptRoot/.requirement/scoop_package.txt" -command "scoop install"
  InstallCommand -name "scoop applications" -file_path "$PSScriptRoot/.requirement/scoop_application.txt" -command "scoop install"
  InstallCommand -name "scoop fonts" -file_path "$PSScriptRoot/.requirement/scoop_font.txt" -command "scoop install"
}

function UninstallScoop {
  UninstallCommand -name "scoop packages" -file_path "$PSScriptRoot/.requirement/scoop_package.txt" -command "scoop uninstall"
  UninstallCommand -name "scoop applications" -file_path "$PSScriptRoot/.requirement/scoop_application.txt" -command "scoop uninstall"
  UninstallCommand -name "scoop fonts" -file_path "$PSScriptRoot/.requirement/scoop_font.txt" -command "scoop uninstall"
}

function InstallNvm {
  if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    Write-Warning "nvm is not installed."
    return
  }
  Write-Host "Installing node.js lts version."
  nvm install lts
  Write-Host "Using node.js lts version."
  nvm use lts
}

function UninstallNvm {
  if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    Write-Warning "nvm is not installed."
    return
  }
  Write-Host "Uninstalling node.js lts version."
  nvm uninstall lts
}

function InstallNpm {
  if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Warning "npm is not installed."
    return
  }
  InstallCommand -name "npm packages" -file_path "$PSScriptRoot/.requirement/npm.txt" -command "npm install -g"
}

function UninstallNpm {
  if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Warning "npm is not installed."
    return
  }
  UninstallCommand -name "npm packages" -file_path "$PSScriptRoot/.requirement/npm.txt" -command "npm uninstall -g"
}

function InstallVisualStudioCodeExtension {
  if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Warning "visual studio code is not installed."
    return
  }
  InstallCommand -name "visual studio code extensions" -file_path "$PSScriptRoot/.requirement/visual_studio_code.txt" -command "code --install-extension" -additional "--force"
}

function UninstallVisualStudioCodeExtension {
  if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Warning "visual studio code is not installed."
    return
  }
  UninstallCommand -name "visual studio code extensions" -file_path "$PSScriptRoot/.requirement/visual_studio_code.txt" -command "code --uninstall-extension"
}

function InstallAllCommand {
  InstallPowerShell
  InstallScoop
  InstallNvm
  InstallNpm
  InstallVisualStudioCodeExtension
}

function UninstallAllCommand {
  UninstallPowerShell
  UninstallScoop
  UninstallNvm
  UninstallNpm
  UninstallVisualStudioCodeExtension
}

function ConfigureApplicationSetting {
  param (
  [string]$app_name,
  [string]$source_path,
  [string]$destination_path,
  [string[]]$files_extensions = @(),
  [string[]]$files = @()
  )
  if ($app_name) {
    Write-Host "Configuring $app_name setting."
  }
  try {
    if (Test-Path $destination_path) {
      foreach ($extension in $files_extensions) {
        Get-ChildItem -Path "$destination_path" -Filter "*$extension" -Recurse | Remove-Item -Recurse -Force
      }
      foreach ($file in $files) {
        Get-ChildItem -Path "$destination_path" -Filter "$file" -Recurse | Remove-Item -Recurse -Force
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
    Write-Error "Error occurred while configuring $app_name setting."
  }
}

function RemoveApplicationSetting {
  param (
  [string]$app_name,
  [string]$destination_path
  )
  if ($app_name) {
    Write-Host "Removing $app_name setting."
  }
  try {
    if (Test-Path $destination_path) {
      Remove-Item -Path "$destination_path" -Recurse -Force
    }
  }
  catch {
    Write-Error "Error occurred while removing $app_name setting."
  }
}

function ConfigurePowerShellSetting {
  $module_paths = Get-Module -ListAvailable | Select-Object -ExpandProperty Path
  foreach ($path in $module_paths) {
    if ($path -like "*Documents\*") {
      $powershell_path = "$ENV:USERPROFILE\Documents"
    } elseif ($path -like "*OneDrive\Documents\*") {
      $powershell_path = "$ENV:USERPROFILE\OneDrive\Documents"
    }
  }
  ConfigureApplicationSetting -app_name "windows powershell" -source_path "$PSScriptRoot/.config/powershell" -destination_path "$powershell_path/WindowsPowerShell" -files_extensions @(".txt", ".json", ".ps1")
  Rename-Item -Path "$powershell_path/WindowsPowerShell/microsoft.powershell_profile.ps1" -NewName "Microsoft.PowerShell_profile.ps1" -Force
  Copy-Item -Path "$powershell_path/WindowsPowerShell/Modules/*" -ErrorAction SilentlyContinue -Destination "$powershell_path/PowerShell/Modules" -Recurse -Force
  ConfigureApplicationSetting -app_name "powershell" -source_path "$PSScriptRoot/.config/powershell" -destination_path "$powershell_path/PowerShell" -files_extensions @(".txt", ".json", ".ps1")
  Rename-Item -Path "$powershell_path/PowerShell/microsoft.powershell_profile.ps1" -NewName "Microsoft.PowerShell_profile.ps1" -Force
  Copy-Item -Path "$powershell_path/PowerShell/Modules/*" -ErrorAction SilentlyContinue -Destination "$powershell_path/WindowsPowerShell/Modules" -Recurse -Force
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
  RemoveApplicationSetting -app_name "windows powershell" -destination_path "$powershell_path/WindowsPowerShell"
  RemoveApplicationSetting -app_name "powershell" -destination_path "$powershell_path/PowerShell"
}

function ConfigureWindowsTerminalSetting {
  ConfigureApplicationSetting -app_name "windows terminal" -source_path "$PSScriptRoot/.config/windows terminal" -destination_path "$ENV:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" -files @("settings.json")
}

function RemoveWindowsTerminalSetting {
  RemoveApplicationSetting -app_name "windows terminal" -destination_path "$ENV:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
}

function ConfigureVimSetting {
  ConfigureApplicationSetting -app_name "vim" -source_path "$PSScriptRoot/.config/vim" -destination_path "$ENV:USERPROFILE" -files @(".vimrc")
}

function RemoveVimSetting {
  RemoveApplicationSetting -app_name "vim" -destination_path "$ENV:USERPROFILE/.vimrc"
}

function ConfigureNeovimSetting {
  ConfigureApplicationSetting -app_name "neovim" -source_path "$PSScriptRoot/.config/nvim" -destination_path "$ENV:USERPROFILE/AppData/Local/nvim"
}

function RemoveNeovimSetting {
  RemoveApplicationSetting -app_name "neovim" -destination_path "$ENV:USERPROFILE/AppData/Local/nvim"
}

function ConfigureScriptSetting {
  ConfigureApplicationSetting -app_name "script" -source_path "$PSScriptRoot/.script" -destination_path "$ENV:USERPROFILE/AppData/Local/script"
}

function RemoveScriptSetting {
  RemoveApplicationSetting -app_name "script" -destination_path "$ENV:USERPROFILE/AppData/Local/script"
}

function ConfigureGitSetting {
  ConfigureApplicationSetting -app_name "git" -source_path "$PSScriptRoot/.gitconfig" -destination_path "$ENV:USERPROFILE" -files @(".gitconfig")
}

function RemoveGitSetting {
  RemoveApplicationSetting -app_name "git" -destination_path "$ENV:USERPROFILE/.gitconfig"
}

function ConfigureLazyGitSetting {
  ConfigureApplicationSetting -app_name "lazygit" -source_path "$PSScriptRoot/.config/lazygit" -destination_path "$ENV:USERPROFILE/AppData/Local/lazygit"
}

function RemoveLazyGitSetting {
  RemoveApplicationSetting -app_name "lazygit" -destination_path "$ENV:USERPROFILE/AppData/Local/lazygit"
}

function ConfigurePythonSetting {
  ConfigureApplicationSetting -app_name "python" -source_path "$PSScriptRoot/.config/pip" -destination_path "$ENV:USERPROFILE/AppData/Local/pip"
}

function RemovePythonSetting {
  RemoveApplicationSetting -app_name "python" -destination_path "$ENV:USERPROFILE/AppData/Local/pip"
}

function ConfigureCommitizenSetting {
  ConfigureApplicationSetting -app_name "commitizen" -source_path "$PSScriptRoot/.config/commitizen" -destination_path "$ENV:USERPROFILE" -files @(".czrc")
}

function RemoveCommitizenSetting {
  RemoveApplicationSetting -app_name "commitizen" -destination_path "$ENV:USERPROFILE/.czrc"
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
  ConfigureApplicationSetting -app_name "visual studio code" -source_path "$PSScriptRoot/.config/vscode" -destination_path "$vscode_path" -files_extensions @(".json")
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
  RemoveApplicationSetting -app_name "visual studio code" -destination_path "$vscode_path"
}

function ConfigureAllAppicationSetting {
  Write-Host "Configuring all applications setting."
  ConfigurePowerShellSetting
  ConfigureWindowsTerminalSetting
  ConfigureVimSetting
  ConfigureNeovimSetting
  ConfigureScriptSetting
  ConfigureGitSetting
  ConfigureLazyGitSetting
  ConfigurePythonSetting
  ConfigureCommitizenSetting
  ConfigureVisualStudioCodeSetting
}

function RemoveAllAppicationSetting {
  Write-Host "Removing all applications setting."
  RemovePowerShellSetting
  RemoveWindowsTerminalSetting
  RemoveVimSetting
  RemoveNeovimSetting
  RemoveScriptSetting
  RemoveGitSetting
  RemoveLazyGitSetting
  RemovePythonSetting
  RemoveCommitizenSetting
  RemoveVisualStudioCodeSetting
}

function MainMenu {
  Get-Content "$PSScriptRoot/ascii.txt" -Raw -Encoding utf8
  @("1. Install powershell.",
    "2. Install scoop.",
    "3. Install nvm.",
    "4. Install npm.",
    "5. Install visual studio code extension.",
    "6. Install all commands.",
    "7. Uninstall powershell.",
    "8. Uninstall scoop.",
    "9. Uninstall nvm.",
    "10. Uninstall npm.",
    "11. Uninstall visual studio code extension.",
    "12. Uninstall all commands.",
    "14. Configure powershell setting.",
    "15. Configure windows terminal setting.",
    "16. Configure vim setting.",
    "17. Configure neovim setting.",
    "18. Configure script setting.",
    "19. Configure git setting.",
    "20. Configure lazygit setting.",
    "21. Configure python setting.",
    "22. Configure commitizen setting.",
    "23. Configure visual studio code setting.",
    "24. Configure all applications setting.",
    "25. Remove powershell setting.",
    "26. Remove windows terminal setting.",
    "27. Remove vim setting.",
    "28. Remove neovim setting.",
    "29. Remove script setting.",
    "30. Remove git setting.",
    "31. Remove lazygit setting.",
    "32. Remove python setting.",
    "33. Remove commitizen setting.",
    "34. Remove visual studio code setting.",
    "35. Remove all applications setting.",
    "q/Q. Quit.",
    "") | ForEach-Object { Write-Host $_ }
}

function Main {
  do {
    MainMenu
    $choice = Read-Host "Enter your choice"
    switch ($choice) {
      "1" { InstallPowerShell }
      "2" { InstallScoop }
      "3" { InstallNvm }
      "4" { InstallNpm }
      "5" { InstallVisualStudioCodeExtension }
      "6" { InstallAllCommand }
      "7" { UninstallPowerShell }
      "8" { UninstallScoop }
      "9" { UninstallNvm }
      "10" { UninstallNpm }
      "11" { UninstallVisualStudioCodeExtension }
      "12" { UninstallAllCommand }
      "14" { ConfigurePowerShellSetting }
      "15" { ConfigureWindowsTerminalSetting }
      "16" { ConfigureVimSetting }
      "17" { ConfigureNeovimSetting }
      "18" { ConfigureScriptSetting }
      "19" { ConfigureGitSetting }
      "20" { ConfigureLazyGitSetting }
      "21" { ConfigurePythonSetting }
      "22" { ConfigureCommitizenSetting }
      "23" { ConfigureVisualStudioCodeSetting }
      "24" { ConfigureAllAppicationSetting }
      "25" { RemovePowerShellSetting }
      "26" { RemoveWindowsTerminalSetting }
      "27" { RemoveVimSetting }
      "28" { RemoveNeovimSetting }
      "29" { RemoveScriptSetting }
      "30" { RemoveGitSetting }
      "31" { RemoveLazyGitSetting }
      "32" { RemovePythonSetting }
      "33" { RemoveCommitizenSetting }
      "34" { RemoveVisualStudioCodeSetting }
      "35" { RemoveAllAppicationSetting }
      "q" { break }
      "Q" { break }
      default { Write-Warning "Invalid choice. Please try again." }
    }
  } while ($choice -ne "q" -and $choice -ne "Q")
}

Main
