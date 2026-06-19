# Final delivery ZIP — contents checklist

**Package names:** `Windows911-Launcher-Setup.exe` (client installer) · `911XAML-delivery.zip` (full handoff)  
**Milestone:** 5 — Final QA, cleanup, and handoff  
**Confirmation:** This is the **final complete production delivery** for the WPF **skin and dashboard** (presentation UI). Backend simulator integration is out of scope unless separately contracted.

---

## What is inside the ZIP

| Item | Location | Purpose |
|------|----------|--------|
| **Client installer** | `Windows911-Launcher-Setup.exe` | **Send this to Sue** — one double-click install, Start menu shortcuts, no .NET download |
| **Runnable application (ZIP)** | `Launcher-Run\` | Double-click `.bat` or exe — no build required |
| **Source code** | `NineOneOneReality.Launcher\` | Full WPF project (.NET 8) |
| **Solution file** | `NineOneOneReality.Launcher.sln` | Open in Visual Studio if IT rebuilds |
| **Images / assets** | `NineOneOneReality.Launcher\Resources\Images\` | PNG, SVG, fonts |
| **Themes / XAML** | `NineOneOneReality.Launcher\Themes\`, `Views\`, `Controls\` | UI layout and styling |
| **Documentation** | `README.md`, `USER_MANUAL.md`, `DELIVERY.md`, `MILESTONE-5.md`, `docs\` | Technical + non-technical guides |
| **QA screenshots** | `NineOneOneReality.Launcher\Screenshots\` | 100% / 125% / 150% proof per screen |
| **Build proof log** | `NineOneOneReality.Launcher\QA\build-and-smoke-proof.txt` | Restore + build + smoke test log |
| **Configuration** | `app.manifest`, `.csproj`, `Themes\`, `.editorconfig` | DPI, framework, project settings |
| **Packaging tools** | `tools\` | Regenerate ZIP, screenshots, proof (for developer/IT) |

**Excluded (intentionally):** `.git`, `.vs`, `bin`, `obj` inside the project (use `Launcher-Run` instead of `bin`).

---

## Screens included

| Screen | How to open (from `Launcher-Run`) |
|--------|-----------------------------------|
| Active light (default) | `START - Active Light.bat` |
| Active dark | `START - Active Dark.bat` |
| Dashboard light / dark | `START - Dashboard Light.bat` / `Dark` or sidebar on active screen |
| Instructor inactive | `START - Inactive Instructor.bat` |
| BASIC / PROCOM / ON AIR inactive | Matching `START - Inactive *.bat` files |
| Inactive picker menu | `START - Inactive Picker (M4).bat` |

---

## Non-technical start guide

**Start here:** [docs/QUICK-START.md](docs/QUICK-START.md)  
**One-page recovery:** [docs/EMERGENCY-RECOVERY.md](docs/EMERGENCY-RECOVERY.md)

---

## Prerequisites on each PC

- Windows 10/11 (64-bit)
- No separate .NET Desktop Runtime install (bundled in installer and `Launcher-Run`)

---

## Regenerate package (developer)

**Installer only (what the client needs):**

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Build-WindowsInstaller.ps1
```

**Full ZIP + installer:**

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Build-FinalDelivery.ps1
```

Creates `Windows911-Launcher-Setup.exe` and `911XAML-delivery.zip` at the repository root.
