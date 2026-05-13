# Milestone 2 — Formal QA & evidence checklist

Use this document to **close the milestone contractually**: engineering was
already reviewed; this list is the **verification package** the client asked
for (side-by-side DPI composites + explicit interaction evidence).

---

## A. Required — DPI alignment (100 % / 125 % / 150 %)

### A1. Raw full-window captures

Produce **one PNG per scale** using either:

- `tools/Capture-DpiScreenshot.ps1` (writes `screenshots/dpi-100.png`, etc.), **or**
- Any full-window capture tool, saved manually as `screenshots/100%.png`,
  `125%.png`, `150%.png` (exact names — the percent sign is part of the filename).

After each Windows scale change: **sign out and sign back in**, then re-run the
launcher before capturing.

### A2. Side-by-side composites (contract deliverables)

These three files are what MILESTONE-2.md calls out explicitly:

| Output file | Meaning |
|-------------|---------|
| `screenshots/side-by-side-100.png` | Reference PNG (left) vs WPF (right) @ 100 % |
| `screenshots/side-by-side-125.png` | Same @ 125 % |
| `screenshots/side-by-side-150.png` | Same @ 150 % |

**One command** after captures exist (accepts **either** `dpi-*.png` **or**
`100%.png` style names):

```powershell
cd <solution root>
powershell -ExecutionPolicy Bypass -File .\tools\Compare-AllDpi.ps1 -PromoteToCanonical
```

`-PromoteToCanonical` copies e.g. `100%.png` → `dpi-100.png` so the repo keeps
one consistent naming scheme.

**Full evidence bundle + text report** (attach to milestone):

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Publish-M2Evidence.ps1 -PromoteToCanonical
```

Produces `screenshots/M2-evidence-report.txt` listing OK / MISSING for each
required file.

---

## B. Required — interaction states (hover / pressed / disabled)

Templates live in:

- `Controls/PrimaryButton.xaml` — START (hover opacity, pressed scale, disabled visuals)
- `Controls/NavButton.xaml` — sidebar rows (hover background, checked/selected, disabled)

The client asked for **screenshot evidence** of each state. Capture into:

```
screenshots/interactions/
```

Suggested filenames (PNG):

| # | Control | State | How to capture | Suggested filename |
|---|---------|-------|----------------|-------------------|
| 1 | START | Default | Launcher idle, pointer away from START | `start-default.png` |
| 2 | START | Hover | Pointer over START (use Snipping Tool **delay 3–5 s**, start timer, then hover) | `start-hover.png` |
| 3 | START | Pressed | Pointer down on START while capturing (delay snip, click and hold, release after capture starts) | `start-pressed.png` |
| 4 | START | Disabled | Temporarily set `IsEnabled="False"` on the START `Button` in `ActiveDarkWindow.xaml`, rebuild, capture, **revert** before commit | `start-disabled.png` |
| 5 | Sidebar nav | Hover | Hover a **non-selected** row (e.g. "Dashboard") | `nav-hover-dashboard.png` |
| 6 | Sidebar nav | Selected | Default screen already has "Start Simulation" selected — capture | `nav-selected-start.png` |
| 7 | Sidebar nav | Disabled | Temporarily set `IsEnabled="False"` on one `RadioButton`, rebuild, capture, **revert** | `nav-disabled-sample.png` |

Rows 4 and 7 require a **one-line XAML toggle** for the shot only — do not
leave the control disabled in the delivered product unless the spec requires
it.

---

## C. Storyboard micro-interactions

Already implemented (ECG opacity pulse + button transitions). Optional
evidence: short screen recording (MP4) or a single PNG showing the ECG at a
visible pulse frame — not strictly required if the client accepts code review
of `Animations/MicroInteractions.xaml` + `ActiveDarkWindow.xaml` ECG block.

---

## D. Zip checklist before re-submitting M2

Include in the delivery zip / repo:

- [ ] `screenshots/side-by-side-100.png`
- [ ] `screenshots/side-by-side-125.png`
- [ ] `screenshots/side-by-side-150.png`
- [ ] `screenshots/M2-evidence-report.txt` (from `Publish-M2Evidence.ps1`)
- [ ] `screenshots/interactions/*.png` (at least START default / hover / pressed / disabled)
- [ ] `MILESTONE-2.md` + this file `MILESTONE-2-QA.md`

---
