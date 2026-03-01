# Git Profile Switcher

This directory contains multiple git configuration profiles that you can easily switch between using PowerShell commands.

## Available Profiles

- **GitHub** - Personal GitHub account
- **OneStream Software** - Work account for Azure DevOps

## Setup

1. **Edit your user information** in each `.gitconfig-user` file:
   - `github/.gitconfig-user` - Your GitHub name and email
   - `oneStreamSoftware/.gitconfig-user` - Your OneStream/Azure DevOps name and email

2. **Reload your PowerShell profile** or restart PowerShell terminal to load the new functions

## Usage

### Switch Git Profiles

Use these commands to switch between profiles:

```powershell
# Switch to GitHub
gitgithub
# or
SetGitGitHub

# Switch to OneStream Software/Azure DevOps
gitonestream
# or
gitazure
# or
gitwork
# or
SetGitOneStream
```

### Check Current Profile

```powershell
# See which profile is active
git config --global user.name
git config --global user.email

# or use the helper script
Show-GitProfile
```

### Check Current Remote

```powershell
# See which remote you're using in current repo
git remote -v
```

## How It Works

Each command creates a symbolic link from `~/.gitconfig` to the appropriate profile configuration file:
- `~/workspace/dotfiles/configs/git/github/.gitconfig`
- `~/workspace/dotfiles/configs/git/oneStreamSoftware/.gitconfig`

Each profile includes:
- User name and email (from `.gitconfig-user`)
- Credential helper settings
- Proxy settings (if needed)
- Common git configurations (editor, merge tool, diff tool)

## Troubleshooting

If commands don't work:
1. Make sure you've edited the `.gitconfig-user` files with your actual information
2. Reload your PowerShell profile: `. $PROFILE`
3. Check if symbolic link was created: `Get-Item $env:USERPROFILE\.gitconfig`
4. Verify the link target: `(Get-Item $env:USERPROFILE\.gitconfig).Target`

## Example Workflow

```powershell
# Working on personal GitHub project
gitgithub
cd ~/projects/my-personal-repo
git status
git commit -m "Personal project update"
git push

# Switch to work project
gitpaychex
cd onestreampace/XF
git status
git commit -m "Work changes"
git push
```
