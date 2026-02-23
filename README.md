# dotfiles

Personal configuration, helper scripts, and automation to make workstations reproducible and consistent across installs.

## Purpose
- Centralize user-specific config for shells, editors, terminals, Git, and small utilities.
- Provide bootstrap/install tooling to apply configs on a new machine.

## Typical contents
- Shell profiles and helpers: .bashrc, .zshrc, PowerShell profile, aliases, completions, prompts
- Editor config: .vimrc / init.vim, VS Code settings, .editorconfig
- Git config and hooks: .gitconfig, templates
- Terminal / multiplexer: .tmux.conf, Windows Terminal profiles
- Bootstrap/install scripts: setup or install scripts for dependencies and symlinks



## Best practices
- Keep machine-specific overrides out of tracked files (use local files or env vars).
- Document install steps and external tool requirements.
- Review repo history before publishing.