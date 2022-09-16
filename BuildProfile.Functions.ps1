function Start-BPInstallDirs() {
  Write-BPMsg -T "HL" -M "Check & Create Directories on Disk D:..."

  $Dirs = @(
    "$($D_APPS)"
    "$($D_DOCS)"
    "$($D_DOWNLOADS)"
    "$($D_MUSIC)"
    "$($D_PICTURES)"
    "$($D_TORRENTS)"
    "$($D_VIDEOS)"
  )

  foreach ( $Dir in $Dirs ) {
    if ( -not ( Test-Path "$($Dir)" ) ) { New-Item -Path "$($Dir)" -ItemType "Directory" }
  }
}

function Start-BPInstallApps() {
  Write-BPMsg -T "HL" -M "Install Apps..."

  $Apps = Get-ChildItem -Path "$($PSScriptRoot)\Apps" -Filter "*.7z" -Recurse
  foreach ( $App in $Apps ) {
    Expand-7z -I "$($App.FullName)" -O "$($D_APPS)"
  }
}

function Start-BPInstallDocs() {
  Write-BPMsg -T "HL" -M "Install Documents..."

  Copy-Item "$($PSScriptRoot)\Docs\Git\.gitconfig" -Destination "$($Env:USERPROFILE)"
  Copy-Item "$($PSScriptRoot)\Docs\Git\.git-credentials" -Destination "$($Env:USERPROFILE)"
}

function Start-BPInstallPath() {
  Write-BPMsg -T "HL" -M "Install PATH variable..."

  if ( Test-Path "$($D_APPS)\7z" ) {
    [Environment]::SetEnvironmentVariable( "Path", ([Environment]::GetEnvironmentVariables("User")).Path + "$($D_APPS)\7z;", "User" )
  }

  if ( Test-Path "$($D_APPS)\Git" ) {
    [Environment]::SetEnvironmentVariable( "Path", ([Environment]::GetEnvironmentVariables("User")).Path + "$($D_APPS)\Git\bin;", "User" )
  }

  if ( Test-Path "$($D_APPS)\PHP" ) {
    [Environment]::SetEnvironmentVariable( "Path", ([Environment]::GetEnvironmentVariables("User")).Path + "$($D_APPS)\PHP;", "User" )
  }

  if ( Test-Path "$($D_APPS)\OpenSSL" ) {
    [Environment]::SetEnvironmentVariable( "Path", ([Environment]::GetEnvironmentVariables("User")).Path + "$($D_APPS)\OpenSSL;", "User" )
  }
}

# -------------------------------------------------------------------------------------------------------------------- #
# MESSAGES.
# -------------------------------------------------------------------------------------------------------------------- #

function Write-BPMsg() {
  param (
    [Alias("M")]
    [string]$Message,

    [Alias("T")]
    [string]$Type,

    [Alias("A")]
    [string]$Action = "Continue"
  )

  switch ( $Type ) {
    "HL" {
      Write-Host "$($NL)--- $($Message)" -ForegroundColor Blue
    }
    "I" {
      Write-Information -MessageData "$($Message)" -InformationAction "$($Action)"
    }
    "W" {
      Write-Warning -Message "$($Message)" -WarningAction "$($Action)"
    }
    "E" {
      Write-Error -Message "$($Message)" -ErrorAction "$($Action)"
    }
    default {
      Write-Host "$($Message)"
    }
  }
}

# -------------------------------------------------------------------------------------------------------------------- #
# 7Z ARCHIVE: EXPAND.
# -------------------------------------------------------------------------------------------------------------------- #

function Expand-7z() {
  param (
    [Alias("I")]
    [string]$In,

    [Alias("O")]
    [string]$Out
  )

  $7zParams = "x", "$($In)", "-o$($Out)", "-aoa"
  & "$($PSScriptRoot)\_META\7z\7za.exe" @7zParams
}
