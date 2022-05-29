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
  [string]$DriveLetter
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
  Start-BPDirs
  Start-BPInstallApps
  Start-BPInstallDocs
  Start-BPInstallPath
}

# -------------------------------------------------------------------------------------------------------------------- #
# BUILD PROFILE.
# -------------------------------------------------------------------------------------------------------------------- #

# Check directories.
function Start-BPDirs() {
  Write-BPMsg -Title -Message "$($NL)--- Check & Create Directories on Disk D:..."

  if ( -not ( Test-Path "$($D_APPS)" ) ) { New-Item -Path "$($D_APPS)" -ItemType "Directory" }
  if ( -not ( Test-Path "$($D_DOCS)" ) ) { New-Item -Path "$($D_DOCS)" -ItemType "Directory" }
  if ( -not ( Test-Path "$($D_DOWNLOADS)" ) ) { New-Item -Path "$($D_DOWNLOADS)" -ItemType "Directory" }
  if ( -not ( Test-Path "$($D_MUSIC)" ) ) { New-Item -Path "$($D_MUSIC)" -ItemType "Directory" }
  if ( -not ( Test-Path "$($D_PICTURES)" ) ) { New-Item -Path "$($D_PICTURES)" -ItemType "Directory" }
  if ( -not ( Test-Path "$($D_TORRENTS)" ) ) { New-Item -Path "$($D_TORRENTS)" -ItemType "Directory" }
  if ( -not ( Test-Path "$($D_VIDEOS)" ) ) { New-Item -Path "$($D_VIDEOS)" -ItemType "Directory" }
}

# Install apps.
function Start-BPInstallApps() {
  Write-BPMsg -Title -Message "$($NL)--- Install Apps..."

  $Apps = Get-ChildItem -Path "$($PSScriptRoot)\Apps" -Filter "*.7z" -Recurse
  foreach ( $App in $Apps ) {
    Expand-7z -In "$($App.FullName)" -Out "$($D_APPS)"
  }
}

# Install docs.
function Start-BPInstallDocs() {
  Write-BPMsg -Title -Message "$($NL)--- Install Documents..."

  Copy-Item "$($PSScriptRoot)\Docs\Git\.gitconfig" -Destination "$($Env:USERPROFILE)"
  Copy-Item "$($PSScriptRoot)\Docs\Git\.git-credentials" -Destination "$($Env:USERPROFILE)"
}

# Install PATH variable.
function Start-BPInstallPath() {
  Write-BPMsg -Title -Message "$($NL)--- Install PATH variable..."

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
# ------------------------------------------------< COMMON FUNCTIONS >------------------------------------------------ #
# -------------------------------------------------------------------------------------------------------------------- #

function Write-BPMsg() {
  param (
    [string]$Message,
    [switch]$Title = $false
  )

  if ( $Title ) {
    Write-Host "$($Message)" -ForegroundColor Blue
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
