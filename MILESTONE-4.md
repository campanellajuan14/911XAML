# Milestone 4 — Inactive monitor skins

**Scope (per client PDF):** three full-screen **inactive** monitor skins aligned
to the hardware model split:

| # | Monitor | Window class | Artwork file (swap PNG, rebuild) |
|---|---------|--------------|-----------------------------------------------------|
| 1 | PLUS / BASIC — **Instructor** inactive | `InactiveInstructorWindow` | `Resources/Images/inactive-viewstudent-source.png` |
| 2 | **BASIC** — Student inactive | `InactiveStudentBasicWindow` | `Resources/Images/inactive-callcards-source.png` |
| 3 | **PROCOM** — Student inactive | `InactiveStudentProcomWindow` | `Resources/Images/inactive-mapping-source.png` |
| 4 | **ON AIR** (optional fourth monitor) | `InactiveOnAirWindow` | `Resources/Images/inactive-onair-source.png` |

**White inactive demo** (same four monitors, white perspective-grid background):

| Monitor | Light artwork file |
|---------|-------------------|
| Instructor | `inactive-viewstudent-light-source.png` |
| BASIC student | `inactive-callcards-light-source.png` |
| PROCOM student | `inactive-mapping-light-source.png` |
| ON AIR | `inactive-onair-light-source.png` |

Open with the M4 picker checkbox **White inactive demo**, or add `--light` to any `--inactive=*` CLI command. Replace the `*-light-source.png` files when final white artwork is delivered — same swap-and-rebuild workflow as dark.

Each screen:

- Merges **`Theme.Dark.xaml`** at the window (inactive lab monitors read as
  dark cinematic shells).
- Reuses **`HeaderBarStyle`** + wordmark + monitor label in the header row
  (aligned with the active console).
- **Body = full-bleed PNG only** — the inactive artwork already includes the
  large titles, ECG line, and layout from the client mockups. No extra XAML
  text, dim layer, or overlay caption is drawn on top (that would
  duplicate or fight the art).

---

## How to run

**Picker (opens a small menu, then one full-screen inactive):**

```powershell
cd NineOneOneReality.Launcher
dotnet run --project NineOneOneReality.Launcher -- --m4
```

**Direct full-screen (for screenshots / QA):**

```powershell
dotnet run --project NineOneOneReality.Launcher -- --inactive=instructor
dotnet run --project NineOneOneReality.Launcher -- --inactive=student-basic
dotnet run --project NineOneOneReality.Launcher -- --inactive=student-procom
dotnet run --project NineOneOneReality.Launcher -- --inactive=onair
dotnet run --project NineOneOneReality.Launcher -- --inactive=instructor --light
```

Aliases: `--inactive=basic` → student BASIC; `--inactive=procom` → student PROCOM.

**Regenerate white placeholder PNGs** (after changing the light inactive layout):

```powershell
dotnet run --project NineOneOneReality.Launcher -- --export-inactive-light-pngs
```

**Active skins unchanged:**

```powershell
dotnet run --project NineOneOneReality.Launcher
dotnet run --project NineOneOneReality.Launcher -- --dark
```

---

## Swapping art when Sue’s team finalizes pixels

For each monitor, edit **one** line in the matching XAML file under
`Views/Inactive/` — the `<Image Source="...">` path — then rebuild. No code
changes required.

---

## Files added (M4 delta)

```
NineOneOneReality.Launcher/
|-- NineOneOneReality.Launcher/
|   |-- App.xaml.cs
|   \-- Views/Inactive/
|       |-- InactiveInstructorWindow.xaml + .cs
|       |-- InactiveStudentBasicWindow.xaml + .cs
|       |-- InactiveStudentProcomWindow.xaml + .cs
|       |-- M4PickerWindow.xaml + .cs
\-- MILESTONE-4.md
```
