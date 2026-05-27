# 9-1-1 Reality Simulator Launcher — User Manual

**Audience:** System administrators, IT staff, and deployment engineers responsible for installing, configuring, and maintaining the WPF launcher on training-lab workstations.

**Non-technical operators (Sue / lab):** use [docs/QUICK-START.md](docs/QUICK-START.md) and [docs/EMERGENCY-RECOVERY.md](docs/EMERGENCY-RECOVERY.md) instead of this manual.

---

## 1. Overview

The 9-1-1 Reality Simulator Launcher is a Windows desktop application that displays the instructor console UI and inactive monitor skins for the simulator training environment. It is a **presentation shell** — navigation buttons, START, Restart, and Shutdown are visual only and are not wired to backend simulator processes in this delivery.

The launcher supports:

- **Active instructor screen** — dark and light themes
- **Dashboard / folder view** — instructor file browser layout
- **Dashboard (secondary display)** — folder view on a separate owned window
- **Four inactive monitor skins** — full-screen PNG artwork for lab secondary/tertiary displays

---

## 2. System requirements

| Requirement | Detail |
|-------------|--------|
| Operating system | Windows 10 or Windows 11 (64-bit) |
| Runtime | [.NET 8 Desktop Runtime](https://dotnet.microsoft.com/download/dotnet/8.0) |
| Display | 1920×1080 minimum recommended; multi-monitor supported |
| DPI | Per-monitor scaling supported (100%, 125%, 150% verified) |

To build from source, install the [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0) and Visual Studio 2022 (17.8+) or use the `dotnet` CLI.

---

## 3. Installation

### Option A — Run from published build

1. Copy the published folder (containing `NineOneOneReality.Launcher.exe`) to the target machine.
2. Ensure .NET 8 Desktop Runtime is installed.
3. Double-click `NineOneOneReality.Launcher.exe`, or create a shortcut pointing to it.

### Option B — Build from source

1. Extract the delivery ZIP to a local folder (e.g. `C:\911XAML`).
2. Open PowerShell and run:

```powershell
cd C:\911XAML\NineOneOneReality.Launcher
dotnet restore
dotnet build -c Release
```

3. The executable is at:

`NineOneOneReality.Launcher\bin\Release\net8.0-windows\NineOneOneReality.Launcher.exe`

---

## 4. Starting the application

### Default (production use)

Double-click the executable or run without arguments:

```powershell
.\NineOneOneReality.Launcher.exe
```

This opens the **light active instructor screen**, maximized.

### Command-line flags (testing / multi-monitor setup)

| Flag | Result |
|------|--------|
| *(none)* | Light active screen |
| `--dark` | Dark active screen |
| `--dashboard` | Dashboard only (light theme) |
| `--dashboard --dark` | Dashboard only (dark theme) |
| `--m4` | Picker menu for inactive monitors |
| `--inactive=instructor` | Instructor VIEW STUDENT inactive |
| `--inactive=student-basic` | BASIC student CALL CARDS inactive |
| `--inactive=student-procom` | PROCOM student MAPPING inactive |
| `--inactive=onair` | ON AIR inactive |

Aliases: `basic`, `procom`, `on-air`, `air`.

Example — launch dark active screen:

```powershell
.\NineOneOneReality.Launcher.exe --dark
```

Example — launch PROCOM inactive on a second monitor:

```powershell
.\NineOneOneReality.Launcher.exe --inactive=student-procom
```

Move the window to the desired monitor before taking screenshots or during lab setup.

### Opening the dashboard from the active screen

1. Start the active screen (light or dark).
2. In the left sidebar, click **Dashboard**.
3. The dashboard opens as a separate window. Click **Dashboard** again (uncheck) to close it.

The dashboard theme matches the active screen (dark active → dark dashboard).

---

## 5. Multi-monitor lab configuration

Typical training-lab layout:

| Monitor | Screen | Launch method |
|---------|--------|---------------|
| 1 (primary) | Active instructor console | Default exe (or `--dark`) |
| 2 (secondary) | **Dashboard / folder view** | Sidebar **Dashboard** on active screen, or `--dashboard` / `--dashboard --dark` |
| 3 | Instructor inactive (VIEW STUDENT) | `--inactive=instructor` |
| 4 | Student BASIC (CALL CARDS) | `--inactive=student-basic` |
| 5 | Student PROCOM (MAPPING) | `--inactive=student-procom` |
| Optional | ON AIR | `--inactive=onair` |

See [docs/MULTI-MONITOR.md](../docs/MULTI-MONITOR.md) for architecture (why there is one `DashboardWindow.xaml`, owned-window behavior, and DPI evidence paths).

Each inactive window sizes itself to the PNG's native aspect ratio, capped to the monitor work area. Position each window on its assigned display using Windows display settings or Win+Shift+Arrow.

The M4 picker (`--m4`) provides a small menu to open any inactive screen without memorizing flag names.

---

## 6. Theme structure

Themes control background, foreground, sidebar, and dashboard colors. They do **not** change brand orange/green, which are fixed in `Brushes.Brand.xaml`.

| File | Purpose |
|------|---------|
| `Themes/Theme.Dark.xaml` | Dark palette — active dark, inactive monitors, dark dashboard |
| `Themes/Theme.Light.xaml` | Light palette — active light, light dashboard |
| `Themes/Brushes.Brand.xaml` | Brand orange, green, header accents (shared) |
| `Themes/Typography.xaml` | Font family and text size resources |
| `Themes/Effects.xaml` | Drop shadow effects |

Each window merges its theme at the **window level** (`Window.Resources`), not globally. Control templates use `DynamicResource` for theme brushes so they update when the theme dictionary is swapped.

To adjust a theme color, edit the corresponding `Color.Theme.*` or `Brush.Theme.*` entry in `Theme.Dark.xaml` or `Theme.Light.xaml`, then rebuild.

---

## 7. Resource and asset locations

### Editable image assets

All runtime images live under:

`NineOneOneReality.Launcher/Resources/Images/`

| Subfolder / file | Contents |
|------------------|----------|
| `SidebarNav/` | Sidebar navigation SVG icons (active screens) |
| `DashboardNav/` | Dashboard tile SVG icons |
| `911-reality-logo.png` | Colored hero wordmark (active screens) |
| `911-reality-logo.svg` | Vector wordmark (dashboard header) |
| `citymap_dark_4k.png` | Cityscape background (dark active hero only) |
| `inactive-viewstudent-source.png` | Instructor inactive full-screen art |
| `inactive-callcards-source.png` | BASIC student inactive art |
| `inactive-mapping-source.png` | PROCOM student inactive art |
| `inactive-onair-source.png` | ON AIR inactive art |
| `SidebarNav/instructor-sidebar-badge.png` | Instructor headset badge in sidebar |

### Fonts

`Resources/Fonts/RobotoCondensed-*.ttf` — embedded as WPF resources.

### Vector icons (XAML)

`Resources/Icons.xaml` — inline Geometry paths for ECG pulse, folder, restart/shutdown, etc.

---

## 8. Replacing or updating artwork

### Inactive monitor PNGs

1. Prepare the new PNG at the target resolution (existing files are full mockup captures).
2. Replace the file in `Resources/Images/` keeping the **exact same filename**.
3. Rebuild: `dotnet build -c Release`
4. Launch with the matching `--inactive=*` flag to verify.

No XAML or code changes are needed unless the filename changes. If renaming, update the `ArtFileName` attribute in the matching file under `Views/Inactive/`.

### Sidebar or dashboard SVG icons

1. Replace the SVG in `Resources/Images/SidebarNav/` or `DashboardNav/`.
2. Keep the same filename so existing XAML references resolve.
3. Rebuild and verify in the active screen or dashboard.

Icons are tinted at runtime via `NavIconAssist.cs` for sidebar items.

### Hero wordmark

- **Active screens:** replace `911-reality-logo.png`. Recommended max display size ~1140×440 px.
- **Dashboard header:** replace `911-reality-logo.svg` (vector preferred for crisp scaling).

### Cityscape (dark active only)

Replace `citymap_dark_4k.png`. Recommended: 3840×2160 PNG with transparent or dark-base city skyline. The image is displayed at 42% opacity with a vertical fade mask in `ActiveDarkWindow.xaml` layer L5.

Light active mode does **not** use the cityscape.

---

## 9. Troubleshooting

| Symptom | Action |
|---------|--------|
| App exits immediately | Check `startup-error.log` next to the `.exe` for exception details |
| Missing hero logo or cityscape | Verify PNG files exist in `Resources/Images/` and rebuild |
| Blurry text at 125%/150% | Confirm Windows display scale was applied (sign out/in after changing scale) |
| Inactive window wrong size | PNG may exceed work area; window caps to monitor bounds automatically |
| Dashboard wrong colors | Dashboard theme follows owner active window; use `--dashboard --dark` for standalone dark |

Log file location:

`<folder containing NineOneOneReality.Launcher.exe>\startup-error.log`

---

## 10. Deployment checklist

- [ ] .NET 8 Desktop Runtime installed on all lab PCs
- [ ] Launcher exe deployed to a read-accessible folder (or built from source)
- [ ] Display scaling set per site standard (100%, 125%, or 150%)
- [ ] Each monitor assigned the correct inactive screen via shortcut or startup script
- [ ] `startup-error.log` location documented for IT support
- [ ] Artwork update procedure communicated to whoever manages client PNG/SVG assets

---

## 11. Creating shortcuts for lab stations

Example PowerShell to create desktop shortcuts:

```powershell
$exe = "C:\911XAML\NineOneOneReality.Launcher\bin\Release\net8.0-windows\NineOneOneReality.Launcher.exe"
$ws = New-Object -ComObject WScript.Shell

$s = $ws.CreateShortcut("$env:USERPROFILE\Desktop\911 Active (Light).lnk")
$s.TargetPath = $exe
$s.Save()

$s = $ws.CreateShortcut("$env:USERPROFILE\Desktop\911 Inactive - Instructor.lnk")
$s.TargetPath = $exe
$s.Arguments = "--inactive=instructor"
$s.Save()
```

Repeat for each inactive monitor and theme variant as needed.
