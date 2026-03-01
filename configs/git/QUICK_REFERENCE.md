# Git Profile Switcher - Quick Reference

## 🚀 Quick Commands

### Switch Profiles
```powershell
gitgithub       # Switch to GitHub (personal)
gitonestream    # Switch to OneStream Software/Azure DevOps (work)
gitazure        # Switch to Azure DevOps (alias for gitonestream)
gitwork         # Switch to work profile (alias for gitonestream)
```

### Check Current Profile
```powershell
gitprofile      # Show current profile details
gitshow         # Show current profile (alias)
```

### Check Git Status
```powershell
git config --global user.name   # Show current name
git config --global user.email  # Show current email
git remote -v                   # Show current repo remote
```

## 📋 First Time Setup

1. **Run the setup script:**
   ```powershell
   cd ~/workspace/dotfiles/configs/git
   .\Setup-GitProfiles.ps1
   ```

2. **Reload PowerShell:**
   ```powershell
   reload-profile
   # or just restart your terminal
   ```

3. **Switch to a profile:**
   ```powershell
   gitgithub     # or gitonestream, gitwork
   ```

4. **Verify it worked:**
   ```powershell
   gitprofile
   ```

## 🔧 Manual Configuration

If you prefer to configure manually, edit these files:

- GitHub: `~/workspace/dotfiles/configs/git/github/.gitconfig-user`
- Paychex: `~/workspace/dotfiles/configs/git/paychex/.gitconfig-user`
- BitBucket: `~/workspace/dotfiles/configs/git/bitBucket/.gitconfig-user`

Format:
```ini
[user]
	name = Your Name
	email = your.email@example.com
```

## 🎯 Common Workflows

### Working on Personal Project
```powershell
gitgithub                          # Switch to GitHub profile
cd ~/projects/my-repo              # Navigate to project
git status                         # Should use GitHub credentials
git commit -m "Update"
git push
```

### Working on Work Project  
```powershell
gitonestream                       # Switch to work profile
cd ~/workspace/XF                  # Navigate to work repo
git status                         # Should use OneStream credentials  
git commit -m "Work update"
git push
```

### Check Before Committing
```powershell
gitprofile                         # Verify correct profile active
git remote -v                      # Verify correct remote
git status                         # Verify correct changes
```

## ❓ Troubleshooting

**Commands not found?**
```powershell
reload-profile
# or restart PowerShell
```

**User not set?**
```powershell
# Run setup again
cd ~/workspace/dotfiles/configs/git
.\Setup-GitProfiles.ps1
```

**Want to see what's linked?**
```powershell
Get-Item $env:USERPROFILE\.gitconfig
(Get-Item $env:USERPROFILE\.gitconfig).Target
```

**Reset to specific profile manually:**
```powershell
Remove-Item $env:USERPROFILE\.gitconfig -Force
New-Item -Path $env:USERPROFILE\.gitconfig -ItemType SymbolicLink -Value $env:USERPROFILE\workspace\dotfiles\configs\git\github\.gitconfig -Force
```

## 📁 File Structure

```
dotfiles/configs/git/
├── README.md                              # Full documentation
├── QUICK_REFERENCE.md                     # This file
├── Setup-GitProfiles.ps1                  # Setup script
├── github/
│   ├── .gitconfig                         # GitHub settings
│   └── .gitconfig-user                    # Your GitHub name/email
└── oneStreamSoftware/
    ├── .gitconfig                         # OneStream/Azure DevOps settings  
    └── .gitconfig-user                    # Your work name/email
```

## 🔑 Key Points

- ✅ Switching is instant - just run the command
- ✅ Each profile has its own proxy settings
- ✅ Each profile has its own credentials
- ✅ Switches affect ALL git repos system-wide
- ⚠️ Remember to switch before committing!
- ⚠️ Check `gitprofile` if you're unsure

## 💡 Pro Tips

1. Add `gitprofile` to your Oh My Posh prompt to always see active profile
2. Create project-specific aliases if you work on same repos frequently
3. Use `gitprofile` before any `git commit` or `git push`
4. The symbolic link survives reboots - it stays switched
