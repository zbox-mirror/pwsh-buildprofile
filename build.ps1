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
  $d_apps       = "$($DriveLetter):\Apps"
  $d_docs       = "$($DriveLetter):\Documents"
  $d_downloads  = "$($DriveLetter):\Downloads"
  $d_music      = "$($DriveLetter):\Music"
  $d_pictures   = "$($DriveLetter):\Pictures"
  $d_torrents   = "$($DriveLetter):\Torrents"
  $d_videos     = "$($DriveLetter):\Videos"

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
  Write-BPMsg -Title -Message "--- Check & Create Directories on Disk D:..."
  if ( ! ( Test-Path "$($d_apps)" ) ) { New-Item -Path "$($d_apps)" -ItemType "Directory" }
  if ( ! ( Test-Path "$($d_docs)" ) ) { New-Item -Path "$($d_docs)" -ItemType "Directory" }
  if ( ! ( Test-Path "$($d_downloads)" ) ) { New-Item -Path "$($d_downloads)" -ItemType "Directory" }
  if ( ! ( Test-Path "$($d_music)" ) ) { New-Item -Path "$($d_music)" -ItemType "Directory" }
  if ( ! ( Test-Path "$($d_pictures)" ) ) { New-Item -Path "$($d_pictures)" -ItemType "Directory" }
  if ( ! ( Test-Path "$($d_torrents)" ) ) { New-Item -Path "$($d_torrents)" -ItemType "Directory" }
  if ( ! ( Test-Path "$($d_videos)" ) ) { New-Item -Path "$($d_videos)" -ItemType "Directory" }
}

# Install apps.
function Start-BPInstallApps() {
  Write-BPMsg -Title -Message "--- Install Apps..."
  Expand-7z -In "$($PSScriptRoot)\Apps\Far\Far.7z" -Out "$($d_apps)"
  # Expand-7z -In "$($PSScriptRoot)\Apps\Git\Git.7z" -Out "$($d_apps)"
  Expand-7z -In "$($PSScriptRoot)\Apps\KiTTY\KiTTY.7z" -Out "$($d_apps)"
  Expand-7z -In "$($PSScriptRoot)\Apps\MPC-HC\MPC-HC.7z" -Out "$($d_apps)"
  Expand-7z -In "$($PSScriptRoot)\Apps\OBS-Studio\OBS-Studio.7z" -Out "$($d_apps)"
  Expand-7z -In "$($PSScriptRoot)\Apps\PHP\PHP.7z" -Out "$($d_apps)"
  Expand-7z -In "$($PSScriptRoot)\Apps\Tixati\Tixati.7z" -Out "$($d_apps)"
  Expand-7z -In "$($PSScriptRoot)\Apps\VSCode\VSCode.7z" -Out "$($d_apps)"
  Expand-7z -In "$($PSScriptRoot)\Apps\OpenSSL\OpenSSL.7z" -Out "$($d_apps)"
}

# Install docs.
function Start-BPInstallDocs() {
  Write-BPMsg -Title -Message "--- Install Documents..."
  Copy-Item "$($PSScriptRoot)\Docs\Git\.gitconfig" -Destination "$($Env:USERPROFILE)"
  Copy-Item "$($PSScriptRoot)\Docs\Git\.git-credentials" -Destination "$($Env:USERPROFILE)"
}

# Install PATH variable.
function Start-BPInstallPath() {
  Write-BPMsg -Title -Message "--- Install PATH variable..."
  if ( Test-Path "$($d_apps)\Git" ) {
    [Environment]::SetEnvironmentVariable( "Path", ([Environment]::GetEnvironmentVariables("User")).Path + "$($d_apps)\Git;", "User" )
  }
  if ( Test-Path "$($d_apps)\PHP" ) {
    [Environment]::SetEnvironmentVariable( "Path", ([Environment]::GetEnvironmentVariables("User")).Path + "$($d_apps)\PHP;", "User" )
  }
  if ( Test-Path "$($d_apps)\OpenSSL" ) {
    [Environment]::SetEnvironmentVariable( "Path", ([Environment]::GetEnvironmentVariables("User")).Path + "$($d_apps)\OpenSSL;", "User" )
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
