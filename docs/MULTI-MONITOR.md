# Multi-monitor architecture

This document answers how the **secondary active dashboard** is implemented and how lab monitors map to launcher windows.

## Summary

| Lab role | Window | XAML | Theme |
|----------|--------|------|-------|
| Primary — active instructor console | `ActiveLightWindow` or `ActiveDarkWindow` | `Views/ActiveLightWindow.xaml`, `Views/ActiveDarkWindow.xaml` | Light or dark (startup flag) |
| Secondary — dashboard / folder view | `DashboardWindow` | `Views/DashboardWindow.xaml` (single file) | Follows owning active window, or `--dark` with `--dashboard` |
| Inactive — VIEW STUDENT | `InactiveInstructorWindow` | `Views/Inactive/InactiveInstructorWindow.xaml` | Dark |
| Inactive — CALL CARDS (BASIC) | `InactiveStudentBasicWindow` | `Views/Inactive/InactiveStudentBasicWindow.xaml` | Dark |
| Inactive — MAPPING (PROCOM) | `InactiveStudentProcomWindow` | `Views/Inactive/InactiveStudentProcomWindow.xaml` | Dark |
| Inactive — ON AIR (optional) | `InactiveOnAirWindow` | `Views/Inactive/InactiveOnAirWindow.xaml` | Dark |

There is **no** separate `SecondaryDashboardWindow` or `DashboardDarkWindow`. The secondary operator display is **`DashboardWindow`**, opened beside the active console.

## Secondary dashboard behavior

1. Start the active screen (default light, or `--dark`).
2. Click **Dashboard** in the left sidebar (`ActiveLightWindow` / `ActiveDarkWindow`).
3. `DashboardWindow` is created with `Owner` set to the active window (`ActiveLightWindow.xaml.cs` / dark equivalent).
4. The dashboard is shown as a **separate top-level window** — position it on the second monitor (Windows display settings or drag).
5. Uncheck **Dashboard** in the sidebar to close the owned dashboard window.

Standalone QA without the active shell:

```powershell
dotnet run -c Release --project NineOneOneReality.Launcher -- --dashboard
dotnet run -c Release --project NineOneOneReality.Launcher -- --dashboard --dark
```

## Why one dashboard XAML file

- **Light and dark** are theme dictionaries (`Theme.Light.xaml`, `Theme.Dark.xaml`), merged in `DashboardWindow.xaml.cs` after `InitializeComponent`.
- The layout is identical; only brushes and surfaces change.
- This matches how inactive monitors share `InactiveScreenView` with per-window PNG sources.

## DPI / QA evidence for both displays

Screenshot folders:

| Folder | What it proves |
|--------|----------------|
| `Screenshots/active-light-*.png` | Active light (primary) at 100/125/150% |
| `Screenshots/active-dark-*.png` | Active dark (primary) at 100/125/150% |
| `Screenshots/dashboard/folder-view-light-*.png` | Dashboard light (secondary) |
| `Screenshots/dashboard/folder-view-dark-*.png` | Dashboard dark (secondary) |
| `Screenshots/inactive-view-student/`, `call-cards/`, `mapping/`, `on-air/` | Inactive skins per monitor role |

For acceptance, confirm on Windows that the dashboard window scales independently when moved to monitor 2 with per-monitor DPI.

## Presentation shell scope (M5)

Navigation, START, Restart, and Shutdown controls are **visual only** in this milestone — they render the approved skins but do not launch simulator backend processes. Wiring to production services is out of scope for the XAML handoff unless the SOW explicitly requires functional launcher actions.
