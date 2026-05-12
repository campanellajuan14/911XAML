# Milestone 3 — Dark + Light (Active Screen)

**Scope:** ship the **same active screen layout** (header, sidebar, hero,
cityscape layer, START, status) in the **light theme** palette, using the
parallel `Brush.Theme.*` keys already defined in `Themes/Theme.Light.xaml`
(sampled from the client’s light instructor reference). Brand colors stay on
`Brushes.Brand.xaml` unchanged.

---

## What was implemented

| Item | Detail |
|------|--------|
| Light window | `Views/ActiveLightWindow.xaml` + `.xaml.cs` — structural copy of the dark screen with `Theme.Light.xaml` merged at `Window.Resources` instead of `Theme.Dark.xaml`. |
| Light-only tuning | Softer hero title shadows (white “ink” halo for dark text on a bright hero), slightly stronger orange grid pen, cityscape opacity 0.36 vs 0.42, sidebar headset chip uses `Brush.Theme.UserAvatar.Bg` instead of hard black. |
| Hero vignette (theme) | `Theme.Light.xaml` — `Brush.Theme.HeroVignette` updated from a no-op to a soft vertical wash so the wordmark and title stay legible over the cityscape on a pale canvas. |
| Startup | `App.xaml.cs` — **default = light**. Run with `--dark` to open the dark skin for A/B comparison or DPI captures. |

## How to run

```powershell
cd NineOneOneReality.Launcher
dotnet run --project NineOneOneReality.Launcher
```

Opens **Active - Light**.

```powershell
dotnet run --project NineOneOneReality.Launcher -- --dark
```

Opens **Active - Dark** (unchanged M2 screen).

---

## Acceptance checklist (typical M3 contract)

Confirm with the client if their M3 wording differs; this is the usual bundle:

- [ ] Light active screen matches their light reference (layout, spacing, typography).
- [ ] Sidebar + header read correctly on white / pale gray (contrast).
- [ ] Hero + cityscape + orange accents feel intentional (not “dark skin on a white page”).
- [ ] `100%` / `125%` / `150%` DPI captures for **light** (same `Capture-DpiScreenshot.ps1` workflow — window title still contains `9-1-1 Reality Simulator`).
- [ ] Optional: if they supply a **light active** reference PNG, add
      `reference/active-light-source.png` and extend the compare script the
      same way as M2 for side-by-side proofs.

---

## File index (M3 delta)

```
NineOneOneReality.Launcher/
|-- NineOneOneReality.Launcher/
|   |-- App.xaml.cs                    # --dark switch; default light
|   |-- Themes/Theme.Light.xaml        # HeroVignette tuned for active hero
|   \-- Views/
|       |-- ActiveLightWindow.xaml
|       \-- ActiveLightWindow.xaml.cs
\-- MILESTONE-3.md                     # this document
```

`ActiveDarkWindow.xaml` is unchanged — both screens stay in sync structurally;
merge **Dark** vs **Light** at the window is the entire theming contract.
