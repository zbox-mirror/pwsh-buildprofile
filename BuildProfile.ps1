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
  [string]$P_DriveLetter,

  [Parameter(HelpMessage="Install applications.")]
  [Alias("IA")]
  [switch]$P_InstallApps = $false,

  [Parameter(HelpMessage="Install documents.")]
  [Alias("ID")]
  [switch]$P_InstallDocs = $false,

  [Parameter(HelpMessage="Install PATH variable.")]
  [Alias("IP")]
  [switch]$P_InstallPath = $false
)

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION.
# -------------------------------------------------------------------------------------------------------------------- #

# Directories.
$D_APPS       = "$($Env:USERPROFILE)\Apps"
$D_DOCS       = "$($P_DriveLetter):\Documents"
$D_DOWNLOADS  = "$($P_DriveLetter):\Downloads"
$D_MUSIC      = "$($P_DriveLetter):\Music"
$D_PICTURES   = "$($P_DriveLetter):\Pictures"
$D_TORRENTS   = "$($P_DriveLetter):\Torrents"
$D_VIDEOS     = "$($P_DriveLetter):\Videos"

# New line separator.
$NL = [Environment]::NewLine

# Load functions.
. "$($PSScriptRoot)\BuildProfile.Functions.ps1"

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

function Start-BuildProfile() {
  Start-BuildData
}

# -------------------------------------------------------------------------------------------------------------------- #
# BUILD PROFILE.
# -------------------------------------------------------------------------------------------------------------------- #

function Start-BuildData() {
  # Install directories.
  Start-BPInstallDirs

  # Install applications.
  if ( $P_InstallApps ) { Start-BPInstallApps }

  # Install documents.
  if ( $P_InstallDocs ) { Start-BPInstallDocs }

  # Install PATH variable.
  if ( $P_InstallPath ) { Start-BPInstallPath }
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

Start-BuildProfile
