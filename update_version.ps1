param (
    [string]$Version,
    [string]$Build
)

# Check if both Version and Build are provided
if (-not $Version -or -not $Build) {
    Write-Host "Usage: .\update_version.ps1 <version> <build>"
    exit 1
}

# Read the content of pubspec.yaml, replace the version line, and save it
(Get-Content pubspec.yaml) -replace 'version: \d+\.\d+\.\d+\+\d+', "version: $Version+$Build" | Set-Content pubspec.yaml

# Output a success message
Write-Host "Version updated to $Version+$Build"
