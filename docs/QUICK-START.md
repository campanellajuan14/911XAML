# Quick Start — For non-technical users (Sue / lab operators)

**Read this first.** You do not need Visual Studio, programming knowledge, or a separate .NET install.

---

## Easiest way — use the installer (recommended)

1. Double-click **`Windows911-Launcher-Setup.exe`**
2. Click **Next** through the wizard (accept the default install location)
3. When finished, open the **Start menu** → **911 Reality Launcher** → **Active Light (main screen)**

That is it. The installer includes everything the app needs.

**Desktop shortcut:** If you checked “Create a desktop shortcut” during setup, double-click **911 Reality Launcher** on the desktop.

---

## Alternative — ZIP package (if you received a ZIP instead)

1. Unzip **`911XAML-delivery.zip`** to a simple folder, for example:  
   `C:\911Reality\`
2. Open folder **`Launcher-Run`**
3. Double-click **`START - Active Light.bat`**

No separate .NET install is required — the ZIP also includes the runtime.

---

## What you need on the PC

- **Windows 10 or 11** (64-bit)
- About **200 MB** free disk space

You do **not** need to install the .NET SDK or Desktop Runtime separately.

---

## How to start each screen

After installing, use **Start menu → 911 Reality Launcher**:

| Shortcut | What opens |
|----------|------------|
| **Active Light (main screen)** | Main instructor screen (white) — normal daily use |
| **Active Dark** | Main instructor screen (dark + cityscape) |
| **Dashboard Light / Dark** | Folder-view dashboard only |
| **Inactive …** shortcuts | Full-screen inactive monitor skins |
| **Inactive Picker (M4)** | Menu to pick inactive screens |

**Typical lab use:** open **Active Light**, then click **Dashboard** in the left sidebar to open the second screen on another monitor.

If you used the ZIP instead, the same screens are in **`Launcher-Run`** as **START - …** files.

---

## What each monitor should show

| Monitor | What Sue should see |
|---------|---------------------|
| **1 (main)** | Active instructor screen (Start Simulation) |
| **2** | Dashboard / Folder View (open from sidebar **Dashboard**) |
| **3** | Instructor inactive (VIEW STUDENT art) |
| **4** | Student CALL CARDS inactive |
| **5** | Student MAPPING inactive |
| Optional | ON AIR inactive |

Full diagram: [MULTI-MONITOR.md](MULTI-MONITOR.md)

---

## If a window is on the wrong monitor

1. Click the window’s title bar.
2. Press **Win + Shift + Left Arrow** or **Win + Shift + Right Arrow** to move it to the next display.
3. Or drag the window to the correct monitor.

After a reboot, you may need to move windows again.

---

## If the app freezes or looks wrong

1. Close all 911 Reality windows.
2. Open Task Manager (Ctrl+Shift+Esc) → end **NineOneOneReality.Launcher** if it is still listed.
3. Start **Active Light** again from the Start menu (or **START - Active Light.bat** if using the ZIP).

See [EMERGENCY-RECOVERY.md](EMERGENCY-RECOVERY.md) for a one-page recovery guide.

---

## Changing pictures later (artwork)

Installed location (default):

`C:\Program Files\911 Reality\Launcher\`

Art source files for IT updates live in the **source** folder inside the ZIP:

`NineOneOneReality.Launcher\Resources\Images\`

| To change | Replace this file (same name) |
|-----------|-------------------------------|
| Instructor inactive screen | `inactive-viewstudent-source.png` |
| CALL CARDS screen | `inactive-callcards-source.png` |
| MAPPING screen | `inactive-mapping-source.png` |
| ON AIR screen | `inactive-onair-source.png` |
| Dark city background | `citymap_dark_4k.png` |
| Main logo on active screen | `911-reality-logo.png` |

After replacing a file, IT must rebuild and send a new installer or `Launcher-Run` folder.

---

## Important: what buttons do in this delivery

This package is the **visual skin** (screens and layout). Sidebar items, **START**, Restart, and Shutdown **look** correct but do **not** start the full simulator backend unless your IT team connects them later.

---

## More help

| Document | For |
|----------|-----|
| [EMERGENCY-RECOVERY.md](EMERGENCY-RECOVERY.md) | One-page troubleshooting |
| [USER_MANUAL.md](../USER_MANUAL.md) | IT / admin (install, shortcuts, technical detail) |
| [DELIVERY-CONTENTS.md](../DELIVERY-CONTENTS.md) | What is inside the ZIP |
| [MILESTONE-5.md](../MILESTONE-5.md) | Final acceptance checklist |

**Support contact:** _(add your name, email, and phone here before sending to client)_
