# Milestone 5 — Final QA, cleanup, and handoff

**Goal:** Deliver a buildable, documented, client-ready package with all screens functioning, QA evidence collected, and no broken resource references.

---

## 1. Pre-handoff build (required)

On **Windows** with .NET 8 SDK or Visual Studio 2022:

```powershell
cd NineOneOneReality.Launcher
dotnet build -c Release
```

Expect **0 errors, 0 warnings**. Target framework: `net8.0-windows`.

---

## 2. Smoke test matrix (required)

Run each row once after a **Release** build. Confirm no unhandled exception dialog (DEBUG) and no new lines in `startup-error.log` next to the exe.

| # | Command | Expected |
|---|---------|----------|
| 1 | `dotnet run -c Release --project NineOneOneReality.Launcher` | Light **active** screen, maximized |
| 2 | `dotnet run -c Release --project NineOneOneReality.Launcher -- --dark` | Dark **active** screen |
| 3 | `dotnet run -c Release --project NineOneOneReality.Launcher -- --dashboard` | Dashboard (light theme) |
| 4 | `dotnet run -c Release --project NineOneOneReality.Launcher -- --dashboard --dark` | Dashboard (dark theme) |
| 5 | `dotnet run -c Release --project NineOneOneReality.Launcher -- --m4` | M4 picker; each button opens correct inactive screen |
| 6 | `dotnet run -c Release --project NineOneOneReality.Launcher -- --inactive=instructor` | Instructor inactive; full-bleed PNG |
| 7 | `dotnet run -c Release --project NineOneOneReality.Launcher -- --inactive=student-basic` | BASIC student inactive |
| 8 | `dotnet run -c Release --project NineOneOneReality.Launcher -- --inactive=student-procom` | PROCOM student inactive |
| 9 | `dotnet run -c Release --project NineOneOneReality.Launcher -- --inactive=onair` | ON AIR inactive |

**Dashboard from UI:** Start default active screen → click **Dashboard** in sidebar → dashboard opens; uncheck to close.

**DPI:** With `PerMonitorV2` in `app.manifest`, verification screenshots at **100%, 125%, and 150%** are in `NineOneOneReality.Launcher/Screenshots/`.

Automated smoke helper:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Run-SmokeTests.ps1
```

Full acceptance proof (restore + build + smoke, writes a log file):

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Run-BuildProof.ps1
```

Output: `NineOneOneReality.Launcher/QA/build-and-smoke-proof.txt` — include in the delivery ZIP.

---

## 3. Active instructor screens (M5 — required)

Client-approved behavior (do not regress):

| Screen | Window | Citymap under hero | CLI |
|--------|--------|-------------------|-----|
| **Active dark** | `ActiveDarkWindow` | **Yes** — `Resources/Images/citymap_dark_4k.png` (L5) | `--dark` |
| **Active light** | `ActiveLightWindow` | **No** — white hero only (agreed exception) | default |

Both share the same layout (sidebar, ECG trace, START, status). Keep `ActiveLightWindow.xaml` and `ActiveDarkWindow.xaml` structurally in sync when changing layout.

**QA screenshots must show the current build.** Regenerate — do not reuse old `side-by-side-*.png` files (they were mislabeled or captured before the light-active citymap was removed).

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Capture-M5Screenshots.ps1
```

Output naming: see `NineOneOneReality.Launcher/Screenshots/README.md` (`active-light-{dpi}.png`, `active-dark-{dpi}.png`, etc.).

---

## 4. Evidence bundle

Collected under `NineOneOneReality.Launcher/Screenshots/`:

| File pattern | Screen |
|--------------|--------|
| `active-light-100.png` … `active-light-150.png` | Active light |
| `active-dark-100.png` … `active-dark-150.png` | Active dark |
| `dashboard/folder-view-light-*.png` | Dashboard light |
| `dashboard/folder-view-dark-*.png` | Dashboard dark |
| `inactive-view-student/instructor-inactive-*.png` | Instructor inactive |
| `call-cards/basic-student-inactive-*.png` | BASIC student inactive |
| `mapping/procom-student-inactive-*.png` | PROCOM student inactive |
| `on-air/on-air-inactive-*.png` | ON AIR inactive |

Each screen has 100%, 125%, and 150% captures. See `Screenshots/README.md`.

---

## 5. Repository hygiene checklist

- [x] No blocking `TODO` / `FIXME` in committed XAML/C#.
- [x] `bin/` and `obj/` excluded via `.gitignore`.
- [x] No secrets (tokens, passwords) in config.
- [x] No hardcoded machine-specific paths.
- [x] All referenced PNG/SVG assets present under `Resources/Images/`.
- [x] Delivery ZIP excludes `bin/`, `obj/`, `.vs/` (`tools/Create-DeliveryZip.ps1`).

---

## 6. Documentation delivered

| Document | Contents |
|----------|----------|
| `README.md` | Project overview, structure, theming, build/deploy, asset map |
| `USER_MANUAL.md` | Admin/IT manual — install, launch, multi-monitor, troubleshooting, artwork replacement |
| `DELIVERY.md` | Quick reference — build, run, CLI flags, ZIP instructions |
| `MILESTONE-4.md` | Inactive monitor scope and art swap notes |
| `MILESTONE-5.md` | This QA / handoff checklist |

---

## 7. Handoff notes for the client

| Topic | Detail |
|-------|--------|
| **Themes** | Dark = `Theme.Dark.xaml`, Light = `Theme.Light.xaml`; same `Brush.Theme.*` keys; merged per window. |
| **Active screens** | `ActiveDarkWindow.xaml`, `ActiveLightWindow.xaml` — keep structurally in sync when changing layout. |
| **Cityscape** | `Resources/Images/citymap_dark_4k.png` — dark active L5 only; light active has no citymap. |
| **Inactive art** | `Resources/Images/inactive-*-source.png` — replace file and rebuild; or change `ArtFileName` in `Views/Inactive/*.xaml`. |
| **ON AIR** | Wired via `--inactive=onair`; art at `inactive-onair-source.png`. |
| **Dashboard** | `DashboardWindow.xaml` — theme from owner active window or `--dark` with `--dashboard`. |
| **Nav icons** | `SidebarNav/` and `DashboardNav/` SVG folders; tinted via `NavIconAssist.cs`. |

---

## 8. Acceptance scope (presentation shell)

This milestone delivers **skin and window presentation** for all monitor roles. Sidebar navigation, START, Restart, and Shutdown render correctly but are **not** wired to simulator backend processes unless a separate SOW item requires it. See `USER_MANUAL.md` §1 and `docs/MULTI-MONITOR.md`.

The **secondary active dashboard** is `DashboardWindow` (folder view), opened as an owned window from the active screen — not a duplicate XAML file per theme. Monitor mapping is documented in `docs/MULTI-MONITOR.md`.

---

## 9. Definition of done (M5)

M5 is complete when:

1. Release build passes on a clean Windows machine with .NET 8.
2. Smoke matrix (section 2) executes with no functional regressions.
3. DPI verification screenshots regenerated via `tools/Capture-M5Screenshots.ps1` (current build; active light without citymap).
4. Documentation (`README.md`, `USER_MANUAL.md`, `DELIVERY.md`) delivered.
5. Delivery ZIP created via `tools/Build-FinalDelivery.ps1` (includes `Launcher-Run` published exe + `docs/QUICK-START.md`).
6. Client sign-off received (or internal sign-off as final gate).

---

## 10. Milestone index (repo)

| Doc | Milestone |
|-----|-----------|
| `README.md` | M1–M3 consolidated + full project reference |
| `MILESTONE-4.md` | M4 — Inactive monitor skins |
| `docs/MULTI-MONITOR.md` | Secondary dashboard + lab monitor map |
| `MILESTONE-5.md` | M5 — Final QA / handoff (this document) |

Historical per-milestone files (M1–M3) were consolidated into `README.md` and `USER_MANUAL.md` for the final delivery package.
