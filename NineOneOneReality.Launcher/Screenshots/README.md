# Milestone 5 QA screenshots

**Important:** Do not ship old `side-by-side-*.png` files. Earlier deliveries used comparison captures that were mislabeled, showed the wrong screen in some folders, or showed the **light active** screen with a citymap (reverted — light active must be **white hero only**).

## Regenerate from the current build

From the repository root on Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Capture-M5Screenshots.ps1
```

This runs the Release app with `--capture-screenshots` and writes **full-window WPF captures** (not reference side-by-sides) for each screen at **100%, 125%, and 150%** logical DPI scale.

## File naming (current)

| File | Screen | Launch equivalent |
|------|--------|-------------------|
| `active-light-{dpi}.png` | Active instructor — **light** (no citymap under hero) | `dotnet run` |
| `active-dark-{dpi}.png` | Active instructor — **dark** (citymap L5 visible) | `dotnet run -- --dark` |
| `dashboard/folder-view-light-{dpi}.png` | Dashboard / folder view — light | `dotnet run -- --dashboard` |
| `dashboard/folder-view-dark-{dpi}.png` | Dashboard / folder view — dark | `dotnet run -- --dashboard --dark` |
| `inactive-view-student/instructor-inactive-{dpi}.png` | VIEW STUDENT inactive | `--inactive=instructor` |
| `call-cards/basic-student-inactive-{dpi}.png` | CALL CARDS (BASIC) inactive | `--inactive=student-basic` |
| `mapping/procom-student-inactive-{dpi}.png` | MAPPING (PROCOM) inactive | `--inactive=student-procom` |
| `on-air/on-air-inactive-{dpi}.png` | ON AIR inactive | `--inactive=onair` |

`{dpi}` is `100`, `125`, or `150`.

## Active screen acceptance (client agreement)

| Theme | Citymap under hero | Notes |
|-------|-------------------|--------|
| **Dark active** | **Yes** — `citymap_dark_4k.png` at L5 | Matches approved dark instructor console |
| **Light active** | **No** — solid white hero (`Brush.Theme.Background`) | Only agreed exception vs dark |

Verify `active-light-*.png` has **no** orange road/city texture behind the logo. Verify `active-dark-*.png` shows the cityscape layer.

## Manual capture (optional)

If you prefer OS display-scale QA: set Windows scale to 100% / 125% / 150%, sign out and back in, run one screen, Win+Shift+S the window, and save using the names above.
