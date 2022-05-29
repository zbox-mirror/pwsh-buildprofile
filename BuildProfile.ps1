<#
.SYNOPSIS
  Profile installation script.
.DESCRIPTION
  The script helps to set up a user profile and install apps.
#>

#Requires -Version 7.2

Param(
  [Parameter(
    Mandatory,
    HelpMessage="Drive letter."
  )]
  [ValidatePattern("^[A-Z]$")]
  [Alias("DL")]
  [string]$DriveLetter,

  [Parameter(HelpMessage="Install applications.")]
  [Alias("IA")]
  [switch]$InstallApps = $false,

  [Parameter(HelpMessage="Install documents.")]
  [Alias("ID")]
  [switch]$InstallDocs = $false,

  [Parameter(HelpMessage="Install PATH variable.")]
  [Alias("IP")]
  [switch]$InstallPath = $false
)

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

function Start-BuildProfile() {
  # Directories.
  $D_APPS       = "$($DriveLetter):\Apps"
  $D_DOCS       = "$($DriveLetter):\Documents"
  $D_DOWNLOADS  = "$($DriveLetter):\Downloads"
  $D_MUSIC      = "$($DriveLetter):\Music"
  $D_PICTURES   = "$($DriveLetter):\Pictures"
  $D_TORRENTS   = "$($DriveLetter):\Torrents"
  $D_VIDEOS     = "$($DriveLetter):\Videos"

  # New line separator.
  $NL = [Environment]::NewLine

  # Run.
  Start-BuildData
}

# -------------------------------------------------------------------------------------------------------------------- #
# BUILD PROFILE.
# -------------------------------------------------------------------------------------------------------------------- #

function Start-BuildData() {
  # Install directories.
  Start-BPInstallDirs

  # Install applications.
  if ( $InstallApps ) { Start-BPInstallApps }

  # Install documents.
  if ( $InstallDocs ) { Start-BPInstallDocs }

  # Install PATH variable.
  if ( $InstallPath ) { Start-BPInstallPath }
}

# -------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------< COMMON FUNCTIONS >------------------------------------------------ #
# -------------------------------------------------------------------------------------------------------------------- #

function Start-BPInstallDirs() {
  Write-BPMsg -Title -Message "--- Check & Create Directories on Disk D:..."

  $Dirs = @(
    "$($D_APPS)"
    "$($D_DOCS)"
    "$($D_DOWNLOADS)"
    "$($D_MUSIC)"
    "$($D_PICTURES)"
    "$($D_TORRENTS)"
    "$($D_VIDEOS)"
  )

  foreach ($Dir in $Dirs) {
    if ( -not ( Test-Path "$($Dir)" ) ) { New-Item -Path "$($Dir)" -ItemType "Directory" }
  }
}

function Start-BPInstallApps() {
  Write-BPMsg -Title -Message "--- Install Apps..."

  $Apps = Get-ChildItem -Path "$($PSScriptRoot)\Apps" -Filter "*.7z" -Recurse
  foreach ( $App in $Apps ) {
    Expand-7z -In "$($App.FullName)" -Out "$($D_APPS)"
  }
}

function Start-BPInstallDocs() {
  Write-BPMsg -Title -Message "--- Install Documents..."

  Copy-Item "$($PSScriptRoot)\Docs\Git\.gitconfig" -Destination "$($Env:USERPROFILE)"
  Copy-Item "$($PSScriptRoot)\Docs\Git\.git-credentials" -Destination "$($Env:USERPROFILE)"
}

function Start-BPInstallPath() {
  Write-BPMsg -Title -Message "--- Install PATH variable..."

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

function Write-BPMsg() {
  param (
    [string]$Message,
    [switch]$Title = $false
  )

  if ( $Title ) {
    Write-Host "$($NL)$($Message)" -ForegroundColor Blue
  } else {
    Write-Host "$($Message)"
  }
}

function Expand-7z() {
  param (
    [string]$In,
    [string]$Out
  )

  $7zParams = "x", "$($In)", "-o$($Out)", "-aoa"
  & "$($PSScriptRoot)\_META\7z\7za.exe" @7zParams
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

Start-BuildProfile
