# Git Profile Setup Script
# Run this script to configure your git profiles

param(
    [switch]$Interactive = $true,
    [string]$GitHubName,
    [string]$GitHubEmail,
    [string]$OneStreamName,
    [string]$OneStreamEmail
)

Write-Host "`n=== Git Profile Configuration ===" -ForegroundColor Cyan
Write-Host "This script will help you set up your git profiles for easy switching.`n" -ForegroundColor White

$dotfilesPath = "$env:USERPROFILE\workspace\dotfiles\configs\git"

# GitHub Configuration
Write-Host "`n--- GitHub Profile ---" -ForegroundColor Yellow
if ($Interactive -and -not $GitHubName) {
    $GitHubName = Read-Host "Enter your GitHub name"
}
if ($Interactive -and -not $GitHubEmail) {
    $GitHubEmail = Read-Host "Enter your GitHub email"
}

if ($GitHubName -and $GitHubEmail) {
    $githubUserConfig = @"
[user]
	name = $GitHubName
	email = $GitHubEmail
"@
    $githubUserConfig | Out-File -FilePath "$dotfilesPath\github\.gitconfig-user" -Encoding UTF8 -Force
    Write-Host "✓ GitHub profile configured" -ForegroundColor Green
}

# OneStream Software/Azure DevOps Configuration
Write-Host "`n--- OneStream Software (Azure DevOps) Profile ---" -ForegroundColor Yellow
if ($Interactive -and -not $OneStreamName) {
    $OneStreamName = Read-Host "Enter your OneStream/Azure DevOps name"
}
if ($Interactive -and -not $OneStreamEmail) {
    $OneStreamEmail = Read-Host "Enter your OneStream/Azure DevOps email"
}

if ($OneStreamName -and $OneStreamEmail) {
    $oneStreamUserConfig = @"
[user]
	name = $OneStreamName
	email = $OneStreamEmail
"@
    $oneStreamUserConfig | Out-File -FilePath "$dotfilesPath\oneStreamSoftware\.gitconfig-user" -Encoding UTF8 -Force
    Write-Host "✓ OneStream Software/Azure DevOps profile configured" -ForegroundColor Green
}

Write-Host "`n=== Setup Complete! ===" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Reload your PowerShell profile by running: " -NoNewline -ForegroundColor White
Write-Host "reload-profile" -ForegroundColor Green
Write-Host "   or restart your PowerShell terminal" -ForegroundColor White
Write-Host "`n2. Switch to a profile using one of these commands:" -ForegroundColor White
Write-Host "   gitgithub     " -NoNewline -ForegroundColor Green
Write-Host "- Switch to GitHub profile" -ForegroundColor Gray
Write-Host "   gitonestream  " -NoNewline -ForegroundColor Green
Write-Host "- Switch to OneStream Software/Azure DevOps profile" -ForegroundColor Gray
Write-Host "   gitazure      " -NoNewline -ForegroundColor Green
Write-Host "- Switch to Azure DevOps profile (same as gitonestream)" -ForegroundColor Gray
Write-Host "   gitwork       " -NoNewline -ForegroundColor Green
Write-Host "- Switch to work profile (same as gitonestream)" -ForegroundColor Gray
Write-Host "`n3. Check your active profile with: " -NoNewline -ForegroundColor White
Write-Host "gitprofile" -ForegroundColor Green
Write-Host "`nRun " -NoNewline -ForegroundColor White
Write-Host "Get-Help Show-GitProfile " -NoNewline -ForegroundColor Green
Write-Host "for more information`n" -ForegroundColor White
