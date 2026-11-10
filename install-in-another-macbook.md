# Install on another MacBook

There are two independent automations, and each one is installed differently.

| Automation | What it does | How to install |
|---|---|---|
| Quick Actions (Automator) | "New README.md" when right-clicking folders, and the ⌃⌥⌘N shortcut | Copy `QuickActions/` |
| Finder Sync extension | "New README.md" when right-clicking the empty background of a Finder window | Build from this repo |

## 1. Quick Actions (Automator)

The Quick Actions are in the `QuickActions/` folder of this repo.
To install them, copy them to `~/Library/Services/` on the other Mac:

```bash
cp -R QuickActions/*.workflow ~/Library/Services/
```

If the Quick Actions are changed in Automator, the copy in the repo must be updated manually:

```bash
cp -R ~/Library/Services/New\ README.md*.workflow QuickActions/
```

The keyboard shortcut is not part of the files, because it is stored in the system preferences.
To set it again, go to **System Settings → Keyboard → Keyboard Shortcuts → Services → Files and Folders** and assign **⌃⌥⌘N** to "New README.md in curr dir".

On first run, macOS asks for permission to control Finder (the script uses `osascript`), which must be allowed.

## 2. Finder Sync extension

### Prerequisites

1. **Xcode** installed (the Command Line Tools alone are not enough).
2. **xcodegen**: `brew install xcodegen` (the `.xcodeproj` is in `.gitignore` and is generated from `project.yml`).
3. An **"Apple Development" certificate** on that Mac: sign in with the Apple ID in **Xcode → Settings → Accounts**, which creates a certificate for that machine.

### Installation

1. Copy or clone this repo to the other Mac (the `build/` folder can be left out, `install.sh` recreates it).
2. Run `./install.sh`.
   If the certificate name differs from the one in the script, run `IDENTITY="Apple Development: <name>" ./install.sh`.
   The available names are listed by `security find-identity -v -p codesigning`.

The script builds the app, signs it, copies it to `~/Applications/NewReadme.app`, enables the extension and restarts Finder.

If the option does not show up in the menu, enable "New README" in **System Settings → General → Login Items & Extensions → Finder Extensions**.

### Alternative without building (not guaranteed)

Copy the already built `~/Applications/NewReadme.app` to the other Mac and remove the quarantine:

```bash
xattr -dr com.apple.quarantine ~/Applications/NewReadme.app
open ~/Applications/NewReadme.app
pluginkit -e use -i pt.diogomaia.NewReadme.FinderSync
killall Finder
```

The app is signed with a development certificate and is not notarized.
It may work, but building on the target Mac is the reliable way.

## Maintenance

The "Apple Development" certificate expires (usually after one year).
If the extension stops showing up, run `./install.sh` again.
