# dotfiles

Personal configuration, helper scripts, and automation to make workstations reproducible and consistent across installs.

## Purpose
- Centralize user-specific config for shells, editors, terminals, Git, and small utilities.
- Provide bootstrap/install tooling to apply configs on a new machine.
- Easy switching between multiple git profiles (GitHub, Azure DevOps/Paychex, BitBucket)

## Quick Start

### Git Profile Switcher 🔄
Easily switch between multiple git configurations:

```powershell
# Run setup (first time only)
cd ~/workspace/dotfiles/configs/git
.\Setup-GitProfiles.ps1

# Reload PowerShell
reload-profile

# Switch profiles
gitgithub      # Switch to GitHub (personal)
gitonestream   # Switch to OneStream Software/Azure DevOps (work)
gitwork        # Switch to work (alias)
gitazure       # Switch to Azure DevOps (alias)

# Check current profile
gitprofile
```

📖 See [configs/git/README.md](configs/git/README.md) for full documentation  
⚡ See [configs/git/QUICK_REFERENCE.md](configs/git/QUICK_REFERENCE.md) for quick reference

## Typical contents
- Shell profiles and helpers: .bashrc, .zshrc, PowerShell profile, aliases, completions, prompts
- Editor config: .vimrc / init.vim, VS Code settings, .editorconfig
- Git config and hooks: .gitconfig, templates, **profile switcher**
- Terminal / multiplexer: .tmux.conf, Windows Terminal profiles
- Bootstrap/install scripts: setup or install scripts for dependencies and symlinks



## Best practices
- Keep machine-specific overrides out of tracked files (use local files or env vars).
- Document install steps and external tool requirements.
- Review repo history before publishing.