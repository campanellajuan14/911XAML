# Quick Start — For non-technical users (Sue / lab operators)

**Read this first.** You do not need Visual Studio or programming knowledge to run the simulator skins.

---

## What you need installed once per PC

1. **Windows 10 or 11** (64-bit)
2. **[.NET 8 Desktop Runtime](https://dotnet.microsoft.com/download/dotnet/8.0)** — download “Desktop Runtime” for Windows x64 and run the installer.

If the app will not open, install .NET 8 first, then try again.

---

## Where to put the files

1. Unzip **`911XAML-delivery.zip`** to a simple folder, for example:  
   `C:\911Reality\`
2. Inside you will see a folder named **`Launcher-Run`**.  
   That folder contains everything you double-click to start the app.

You may move `Launcher-Run` to the Desktop or any drive letter. Avoid very long path names.

---

## How to start (easiest)

Open the **`Launcher-Run`** folder and double-click:

| File | What opens |
|------|------------|
| **START - Active Light.bat** | Main instructor screen (white background, no map) — normal daily use |
| **START - Active Dark.bat** | Main instructor screen (dark + cityscape) |
| **START - Dashboard Light.bat** | Folder-view dashboard only (light) |
| **START - Dashboard Dark.bat** | Folder-view dashboard only (dark) |

**Typical lab use:** double-click **START - Active Light.bat**, then click **Dashboard** in the left sidebar to open the second screen on another monitor.

---

## What each monitor should show

| Monitor | What Sue should see |
|---------|---------------------|
| **1 (main)** | Active instructor screen (Start Simulation) |
| **2** | Dashboard / Folder View (open from sidebar **Dashboard**) |
| **3** | Instructor inactive (VIEW STUDENT art) — use shortcut or IT script |
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
3. Double-click **START - Active Light.bat** again.

See [EMERGENCY-RECOVERY.md](EMERGENCY-RECOVERY.md) for a one-page recovery guide.

---

## Changing pictures later (artwork)

Art files live in the **source** folder (for IT), not in `Launcher-Run`:

`NineOneOneReality.Launcher\Resources\Images\`

| To change | Replace this file (same name) |
|-----------|-------------------------------|
| Instructor inactive screen | `inactive-viewstudent-source.png` |
| CALL CARDS screen | `inactive-callcards-source.png` |
| MAPPING screen | `inactive-mapping-source.png` |
| ON AIR screen | `inactive-onair-source.png` |
| Dark city background | `citymap_dark_4k.png` |
| Main logo on active screen | `911-reality-logo.png` |

After replacing a file, IT must rebuild or copy a new `Launcher-Run` folder from Juan’s build script. Operators normally only replace PNGs when IT provides an updated `Launcher-Run` zip.

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
