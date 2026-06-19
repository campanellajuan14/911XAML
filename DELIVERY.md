# 9-1-1 Reality Simulator — Client delivery package

**This is the final complete production delivery ZIP** for the WPF **skin and dashboard** (all monitor UI states). Simulator backend wiring is not included unless separately scoped.

## Start here (non-technical)

**Send the client this file:** `Windows911-Launcher-Setup.exe` — double-click install, no SDK or .NET download needed.

1. Double-click **`Windows911-Launcher-Setup.exe`**
2. Click through the wizard
3. Start menu → **911 Reality Launcher** → **Active Light (main screen)**

Alternative ZIP package: unzip `911XAML-delivery.zip` → open **`Launcher-Run`** → **`START - Active Light.bat`**

Read [docs/QUICK-START.md](docs/QUICK-START.md) and [docs/EMERGENCY-RECOVERY.md](docs/EMERGENCY-RECOVERY.md)

Full ZIP inventory: [DELIVERY-CONTENTS.md](DELIVERY-CONTENTS.md)

## Documentation

| Document | Purpose |
|----------|---------|
| [docs/QUICK-START.md](docs/QUICK-START.md) | **Non-technical** — install, double-click, monitors |
| [docs/EMERGENCY-RECOVERY.md](docs/EMERGENCY-RECOVERY.md) | One-page restart / recovery |
| [DELIVERY-CONTENTS.md](DELIVERY-CONTENTS.md) | Everything inside the ZIP |
| [README.md](README.md) | Full project overview, structure, theming, build |
| [USER_MANUAL.md](USER_MANUAL.md) | Admin/IT guide — install, launch, multi-monitor, assets |
| [MILESTONE-4.md](MILESTONE-4.md) | Inactive monitor notes |
| [MILESTONE-5.md](MILESTONE-5.md) | Final QA checklist and definition of done |
| [docs/MULTI-MONITOR.md](docs/MULTI-MONITOR.md) | Secondary dashboard + lab monitor map |

## Screenshots (QA evidence)

Regenerate proof images (do not reuse old `side-by-side-*.png`):

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Capture-M5Screenshots.ps1
```

Output: `NineOneOneReality.Launcher/Screenshots/` — see `Screenshots/README.md`.

## Build and run (IT / developer)

**Operators:** use `Launcher-Run\` only (see QUICK-START).

**IT rebuild from source:**

```powershell
cd NineOneOneReality.Launcher
dotnet build -c Release
```

Or build only the client installer:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Build-WindowsInstaller.ps1
```

Output: `Windows911-Launcher-Setup.exe` at the repository root (~180 MB, self-contained).

## Entry points

| Screen | Command |
|--------|---------|
| Light active (default) | `dotnet run -c Release` |
| Dark active | `dotnet run -c Release -- --dark` |
| Dashboard (light) | `dotnet run -c Release -- --dashboard` |
| Dashboard (dark) | `dotnet run -c Release -- --dashboard --dark` |
| Inactive picker | `dotnet run -c Release -- --m4` |
| Instructor inactive | `dotnet run -c Release -- --inactive=instructor` |
| BASIC inactive | `dotnet run -c Release -- --inactive=student-basic` |
| PROCOM inactive | `dotnet run -c Release -- --inactive=student-procom` |
| ON AIR inactive | `dotnet run -c Release -- --inactive=onair` |

Dashboard can also be opened from the active screen sidebar (**Dashboard** nav item).

## Requirements

- Windows 10/11 (64-bit)
- No separate .NET install required (runtime is bundled in the installer and `Launcher-Run`)

## Delivery package

**Client installer (primary):**

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Build-WindowsInstaller.ps1
```

Output: `Windows911-Launcher-Setup.exe` — send this single file to the client.

**Full ZIP (source + docs + optional folder run):**

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Build-FinalDelivery.ps1
```

Output: `911XAML-delivery.zip` and `Windows911-Launcher-Setup.exe` at the repository root.
