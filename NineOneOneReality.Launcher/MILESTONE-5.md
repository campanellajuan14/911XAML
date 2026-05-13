# Milestone 5 — Final QA, cleanup, and handoff

**Goal:** close the project loop with a repeatable QA pass, a single **CLI /
entry-point reference** for whoever runs the launcher next, and a clean
handoff package for the client or the next developer.

---

## 1. Pre-handoff build (required)

On **Windows** with .NET 6 SDK or Visual Studio 2022:

```powershell
cd NineOneOneReality.Launcher
dotnet build -c Release
```

Expect **0 errors**. `NETSDK1138` (net6.0 EOL warning) is expected until the
solution is retargeted to net8.0-windows in a future maintenance pass.

---

## 2. Smoke test matrix (required)

Run each row once after a **Release** build. Confirm no unhandled exception
dialog (DEBUG) and no new lines in `startup-error.log` next to the exe.

| # | Command | Expected |
|---|---------|----------|
| 1 | `dotnet run --project NineOneOneReality.Launcher` | Light **active** screen (M3), maximized |
| 2 | `dotnet run --project NineOneOneReality.Launcher -- --dark` | Dark **active** screen (M2) |
| 3 | `dotnet run --project NineOneOneReality.Launcher -- --m4` | M4 picker; each button opens correct inactive full-screen |
| 4 | `dotnet run --project NineOneOneReality.Launcher -- --inactive=instructor` | Instructor inactive; body = PNG only under header |
| 5 | `dotnet run --project NineOneOneReality.Launcher -- --inactive=student-basic` | BASIC student inactive |
| 6 | `dotnet run --project NineOneOneReality.Launcher -- --inactive=student-procom` | PROCOM student inactive |

**DPI:** With `PerMonitorV2` in `app.manifest`, repeat a subset at **125%** and
**150%** display scale (sign out/in after each change) if the contract still
requires multi-scale sign-off.

---

## 3. Evidence bundle (if still collecting for contract)

From earlier milestones:

- `screenshots/side-by-side-100.png` … `150.png` — active screen vs reference
  (`tools/Publish-M2Evidence.ps1` — see `MILESTONE-2-QA.md`)
- Optional: `screenshots/interactions/*.png` for button states

Inactive monitors: one full-window capture per `--inactive=*` is enough for
documentation unless the client asks for DPI triplets on those too.

---

## 4. Repository hygiene checklist

- [ ] No `TODO` / `FIXME` left in committed XAML/C# that block release.
- [ ] `bin/` and `obj/` not committed (`.gitignore` already covers them).
- [ ] No secrets (tokens, passwords) in history or config.
- [ ] Zip for delivery = solution root **without** `bin`/`obj` (or publish
      `dotnet publish -c Release` and hand off the publish folder).

---

## 5. Handoff notes for the client

| Topic | Detail |
|-------|--------|
| **Themes** | Dark = `Theme.Dark.xaml`, Light = `Theme.Light.xaml`; same `Brush.Theme.*` keys; swap merged dictionary on the window. |
| **Active screens** | `ActiveDarkWindow.xaml`, `ActiveLightWindow.xaml` — keep structurally in sync when changing layout. |
| **Cityscape** | `Resources/Images/citymap_dark_4k.png` — replace file for sharper 4K; `Active*Window` layer L5 unchanged. |
| **Inactive art** | `Views/Inactive/*.xaml` — change `<Image Source>` only when final PNGs arrive. |
| **Optional asset** | `inactive-onair-source.png` — not wired; reserve for a fourth monitor if needed. |
| **Retarget** | Consider `net8.0-windows` when ready to clear EOL SDK warnings. |

---

## 6. Milestone index (repo)

| Doc | Milestone |
|-----|-----------|
| `MILESTONE-1.md` | M1 — Alignment proof |
| `MILESTONE-2.md` / `MILESTONE-2-QA.md` | M2 — Active pixel-perfect + evidence |
| `MILESTONE-3.md` | M3 — Light active skin |
| `MILESTONE-4.md` | M4 — Three inactive placeholders |
| `MILESTONE-5.md` | M5 — This QA / handoff |

---

## 7. Definition of done (M5)

M5 is complete when:

1. Release build passes on a clean Windows machine.  
2. Smoke matrix (section 2) is executed with no functional regressions.  
3. Handoff zip or repo link is delivered with this document and `README.md`
   build instructions.  
4. Client sign-off received (or internal sign-off if acting as final gate).
