# 9-1-1 Reality Simulator — WPF Launcher

WPF desktop launcher for the 9-1-1 Reality Simulator instructor console. Implements the **active** instructor screens (dark and light), the **dashboard / folder view** (secondary operator display), and **four inactive monitor skins** for multi-display lab setups.

Built with **.NET 8**, pure XAML layouts, shared resource dictionaries, and no third-party UI framework beyond SharpVectors (SVG) and Microsoft.Xaml.Behaviors.

---

## Quick start

**Requirements:** Windows 10/11, [.NET 8 Desktop Runtime](https://dotnet.microsoft.com/download/dotnet/8.0) (or SDK to build from source).

```powershell
cd NineOneOneReality.Launcher
dotnet build -c Release
dotnet run -c Release
```

Default startup opens the **light active** screen, maximized.

**Client / operator:** [docs/QUICK-START.md](docs/QUICK-START.md) · [DELIVERY-CONTENTS.md](DELIVERY-CONTENTS.md)

See [DELIVERY.md](DELIVERY.md) for all CLI entry points and [USER_MANUAL.md](USER_MANUAL.md) for Admin/IT operations.

---

## Screens included

| Screen | Window | How to open |
|--------|--------|-------------|
| Active — light (default) | `ActiveLightWindow` | `dotnet run` |
| Active — dark | `ActiveDarkWindow` | `dotnet run -- --dark` |
| Dashboard / folder view | `DashboardWindow` | Sidebar **Dashboard** on active screen, or `dotnet run -- --dashboard` |
| Dashboard — dark theme | `DashboardWindow` | `dotnet run -- --dashboard --dark` |
| Inactive picker (M4 menu) | `M4PickerWindow` | `dotnet run -- --m4` |
| Instructor inactive (VIEW STUDENT) | `InactiveInstructorWindow` | `dotnet run -- --inactive=instructor` |
| BASIC student inactive (CALL CARDS) | `InactiveStudentBasicWindow` | `dotnet run -- --inactive=student-basic` |
| PROCOM student inactive (MAPPING) | `InactiveStudentProcomWindow` | `dotnet run -- --inactive=student-procom` |
| ON AIR inactive | `InactiveOnAirWindow` | `dotnet run -- --inactive=onair` |
| Any inactive — **white demo** | same windows + `--light` | `dotnet run -- --inactive=instructor --light` or M4 picker checkbox |

Release executable (after build):

`NineOneOneReality.Launcher\bin\Release\net8.0-windows\NineOneOneReality.Launcher.exe`

Pass the same flags after the `.exe` path.

---

## Project structure

```
911XAML/
├── README.md                          ← this file
├── USER_MANUAL.md                     ← Admin / IT operations guide
├── DELIVERY.md                        ← quick build/run reference
├── MILESTONE-4.md                     ← inactive monitor notes
├── MILESTONE-5.md                     ← final QA / handoff checklist
├── NineOneOneReality.Launcher.sln
└── NineOneOneReality.Launcher/
    ├── App.xaml                       ← global merged dictionaries
    ├── App.xaml.cs                    ← startup routing + exception logging
    ├── app.manifest                   ← PerMonitorV2 DPI awareness
    ├── NavIconAssist.cs               ← sidebar SVG icon tinting
    │
    ├── Themes/
    │   ├── Brushes.Brand.xaml         ← theme-independent brand colors
    │   ├── Theme.Dark.xaml            ← dark palette (Brush.Theme.* keys)
    │   ├── Theme.Light.xaml           ← light palette (parallel keys)
    │   ├── Typography.xaml            ← Roboto Condensed + text styles
    │   └── Effects.xaml               ← shared DropShadowEffect resources
    │
    ├── Controls/                      ← reusable control templates
    │   ├── HeaderBar.xaml
    │   ├── NavButton.xaml
    │   ├── PrimaryButton.xaml
    │   └── StatusPill.xaml
    │
    ├── Animations/
    │   └── MicroInteractions.xaml     ← durations + easing for micro-animations
    │
    ├── Resources/
    │   ├── Icons.xaml                 ← vector Geometry icons (ECG, folder, etc.)
    │   ├── Fonts/                     ← RobotoCondensed-*.ttf
    │   └── Images/
    │       ├── SidebarNav/            ← sidebar navigation SVG icons
    │       ├── DashboardNav/          ← dashboard tile SVG icons
    │       ├── 911-reality-logo.png   ← hero wordmark (active screens)
    │       ├── 911-reality-logo.svg   ← header wordmark (dashboard)
    │       ├── citymap_dark_4k.png    ← dark active hero cityscape (L5)
    │       └── inactive-*-source.png  ← full-bleed inactive monitor art
    │
    ├── Views/
    │   ├── ActiveDarkWindow.xaml      ← dark active instructor console
    │   ├── ActiveLightWindow.xaml     ← light active instructor console
    │   ├── DashboardWindow.xaml       ← folder view / dashboard
    │   └── Inactive/
    │       ├── InactiveScreenView.xaml    ← shared PNG host control
    │       ├── InactiveInstructorWindow.xaml
    │       ├── InactiveStudentBasicWindow.xaml
    │       ├── InactiveStudentProcomWindow.xaml
    │       ├── InactiveOnAirWindow.xaml
    │       └── M4PickerWindow.xaml
    │
    └── Screenshots/                   ← DPI verification evidence (100/125/150%)
        └── README.md
```

---

## Theming

Themes are **window-scoped**, not application-scoped. Each window merges either `Theme.Dark.xaml` or `Theme.Light.xaml` into its own `Window.Resources`. Both theme files declare the same key names (`Brush.Theme.Background`, `Brush.Theme.Sidebar`, etc.) so control templates bound via `DynamicResource` re-resolve automatically when the theme dictionary changes.

Brand colors that stay constant across themes (safety orange, READY green) live in `Brushes.Brand.xaml`, merged globally in `App.xaml`.

| Theme file | Used by |
|------------|---------|
| `Theme.Dark.xaml` | `ActiveDarkWindow`, inactive monitors, dark dashboard |
| `Theme.Light.xaml` | `ActiveLightWindow`, light dashboard |

**Active screen differences:** Dark mode includes layered vector hero background plus `citymap_dark_4k.png` at layer L5. Light mode uses a clean white hero base (no citymap).

**Dashboard:** Theme is chosen in `DashboardWindow.xaml.cs` based on the owning active window, or via `--dark` when launched from CLI.

---

## Monitor / multi-screen behavior

This launcher is designed for a **multi-monitor training lab**:

1. **Active screen** — one maximized window on the instructor's primary display (`ActiveLightWindow` or `ActiveDarkWindow`).
2. **Dashboard (secondary display)** — `DashboardWindow` opens as an **owned** window from the active screen sidebar (or via `--dashboard`). It is the instructor folder-view / secondary operator UI. Light and dark variants share one window with theme merged at runtime — there is no separate `DashboardDarkWindow.xaml`. Move the dashboard to the second monitor in the lab; theme follows the active screen.
3. **Inactive monitors** — four full-screen skin windows, each showing a single client-supplied PNG at native aspect ratio. Windows use `SizeToContent` and cap to the monitor work area. Launch individually via `--inactive=*` or through the M4 picker (`--m4`).

Inactive art is swapped by replacing PNG files under `Resources/Images/` and rebuilding — no code changes required. See [USER_MANUAL.md](USER_MANUAL.md) § "Replacing artwork".

---

## DPI and scaling

- `ApplicationHighDpiMode` = **PerMonitorV2** (also declared in `app.manifest`).
- Design canvas: **1920×1080**, window opens **maximized**.
- `UseLayoutRounding="True"` and `SnapsToDevicePixels="True"` on all primary views.

Verification screenshots at **100%, 125%, and 150%** are in `NineOneOneReality.Launcher/Screenshots/`. Regenerate from the current build (do not reuse old `side-by-side-*.png`):

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Capture-M5Screenshots.ps1
```

See `Screenshots/README.md` and `MILESTONE-5.md` §3 (active screen acceptance).

---

## Build and deployment

### Build from source

```powershell
cd NineOneOneReality.Launcher
dotnet restore
dotnet build -c Release
```

Expect **0 errors, 0 warnings**.

### Publish a self-contained folder (optional)

```powershell
dotnet publish -c Release -r win-x64 --self-contained false -o ..\publish
```

The `publish\` folder contains the exe, dependencies, and embedded resources. Copy to target machines that already have .NET 8 Desktop Runtime installed.

### Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| .NET 8 (Windows) | 8.0+ | Runtime / SDK |
| Microsoft.Xaml.Behaviors.Wpf | 1.1.135 | XAML behaviors |
| SharpVectors.Wpf | 1.8.5 | SVG rendering (dashboard header, nav icons) |

---

## Error logging

Unhandled exceptions are written to `startup-error.log` next to the executable. In **DEBUG** builds, a MessageBox also shows the stack trace. Check this file if a screen fails to open silently.

---

## Milestone documentation

| Document | Scope |
|----------|-------|
| `MILESTONE-4.md` | Inactive monitor skins (M4) |
| `docs/MULTI-MONITOR.md` | Secondary dashboard + lab monitor map |
| `MILESTONE-5.md` | Final QA, cleanup, and handoff checklist |

Historical milestone notes (M1–M3) were consolidated into this README and the user manual for the final delivery.

---

## Replacing artwork (summary)

| Asset | Path | Used in |
|-------|------|---------|
| Hero wordmark (PNG) | `Resources/Images/911-reality-logo.png` | Active dark/light hero |
| Hero wordmark (SVG) | `Resources/Images/911-reality-logo.svg` | Dashboard header |
| Cityscape background | `Resources/Images/citymap_dark_4k.png` | Dark active hero L5 only |
| Sidebar nav icons | `Resources/Images/SidebarNav/*.svg` | Active screens sidebar |
| Dashboard tile icons | `Resources/Images/DashboardNav/*.svg` | Dashboard tiles |
| Instructor inactive | `Resources/Images/inactive-viewstudent-source.png` | `--inactive=instructor` |
| BASIC inactive | `Resources/Images/inactive-callcards-source.png` | `--inactive=student-basic` |
| PROCOM inactive | `Resources/Images/inactive-mapping-source.png` | `--inactive=student-procom` |
| ON AIR inactive | `Resources/Images/inactive-onair-source.png` | `--inactive=onair` |

Replace the file, keep the same filename, rebuild. Full instructions in [USER_MANUAL.md](USER_MANUAL.md).
