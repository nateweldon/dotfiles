# Oh My Posh Git Profile Indicator

This custom Oh My Posh theme displays which git profile is currently active in your prompt.

## What It Shows

The prompt will display an orange segment showing your active git profile:
- **󰊤 GitHub** - When GitHub profile is active
- **󰿗 OneStream** - When OneStream Software/Azure DevOps profile is active

## How It Works

1. **Environment Variables**: The system sets `$env:GIT_PROFILE` and `$env:GIT_PROFILE_ICON` based on which `.gitconfig` is linked
2. **Custom Theme**: The Oh My Posh theme reads these variables and displays them
3. **Auto-Update**: When you run `gitgithub` or `gitonestream`, the display updates automatically

## Setup

Already done! Your PowerShell profile now:
1. Detects the active git profile on startup
2. Loads the custom Oh My Posh theme
3. Updates the display when you switch profiles

## Usage

Just use your git profile switcher commands as normal:

```powershell
# Switch to GitHub - prompt will show "󰊤 GitHub"
gitgithub

# Switch to OneStream - prompt will show "󰿗 OneStream"  
gitonestream
```

The prompt updates immediately after switching!

## Customization

To change colors or icons, edit:
- **Theme File**: `~/workspace/dotfiles/configs/ohmyposh/custom-with-gitprofile.omp.json`
- **Git Profile Segment**: Look for the "text" segment with `GIT_PROFILE`

### Example Customizations

**Change Background Color:**
```json
{
  "background": "#ff8800",  // Orange (current)
  "background": "#00C853",  // Green
  "background": "#2196F3",  // Blue
}
```

**Change Icons:**
Edit in the PowerShell profile where `$env:GIT_PROFILE_ICON` is set:
```powershell
$env:GIT_PROFILE_ICON = "󰊤"  # GitHub icon
$env:GIT_PROFILE_ICON = ""  # Different GitHub icon
$env:GIT_PROFILE_ICON = "󰿗"  # Azure icon
$env:GIT_PROFILE_ICON = ""  # Different Azure icon
```

## Troubleshooting

**Profile not showing?**
```powershell
# Check environment variables
$env:GIT_PROFILE
$env:GIT_PROFILE_ICON

# If empty, reload profile
reload-profile
```

**Still using old theme?**
```powershell
# Verify custom theme exists
Test-Path ~/workspace/dotfiles/configs/ohmyposh/custom-with-gitprofile.omp.json

# Reload profile
reload-profile
```

**Want to use your original theme?**
Edit `Microsoft.PowerShell_profile.ps1` and change the theme path back to:
```powershell
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_rainbow.omp.json" | Invoke-Expression
```

## Files Created

- `configs/ohmyposh/custom-with-gitprofile.omp.json` - Custom Oh My Posh theme
- `psModules/git/gitProfileEnv.psm1` - Git profile environment variable helper
- Updated `psModules/Microsoft.PowerShell_profile.ps1` - Profile initialization
- Updated `psModules/generalCommands.psm1` - Profile switcher functions
