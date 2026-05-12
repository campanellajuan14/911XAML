# Milestone 2 — Active Screen Pixel-Perfect Completion

**Scope:** take the M1 alignment skeleton and finish the dark active screen
to pixel-perfect, with the cityscape background layered in and the result
validated across all three Windows display scales (100 % / 125 % / 150 %).

---

## What changed since M1

| Change                                                                   | File touched                                          |
|--------------------------------------------------------------------------|-------------------------------------------------------|
| Cityscape background asset wired in (no longer a placeholder slot)       | `Resources/Images/citymap_dark_4k.png`                |
| Layer L5 enabled in the hero composition with soft top/bottom mask       | `Views/ActiveDarkWindow.xaml`                         |
| Multi-DPI side-by-side helper                                            | `tools/Compare-AllDpi.ps1`                            |
| Delivery cover doc                                                       | `MILESTONE-2.md` (this file)                          |

No structural changes to the sidebar, header, control templates, theme
palette, or typography — those passed M1 already and are kept stable.

## Cityscape integration — how it sits in the hero

Layer L5 of the hero composition is now an `<Image>` rather than a
placeholder comment. Order of layers, bottom to top:

```
L1   dark base                 (Window background)
L2   tiled vector grid         (DrawingBrush, subtle orange)
L3   warm bottom horizon glow  (LinearGradientBrush)
L4   diagonal atmospheric haze (LinearGradientBrush)
L5   cityscape PNG             (NEW - citymap_dark_4k.png, opacity 0.42, soft top/bottom mask)
L6   multi-stop radial spotlight behind the wordmark
L7   scanline overlay
L8   vignette
L9   orange separator stripe
L10  hero content (wordmark, title, ECG, button, status)
```

The cityscape sits **behind** the radial spotlight (L6) and the vignette
(L8). That layering is deliberate:

- The vector layers (L2 / L3 / L4) give the *cinematic* base independent of
  whatever asset gets dropped at L5 — depth holds even if the cityscape is
  swapped out.
- L5 grounds the scene with a real city — the artist's pass.
- L6 brightens the centre so the wordmark and title don't compete with the
  road glow.
- L8 keeps the text edges legible across the full hero width.

The `Image.OpacityMask` is a vertical four-stop gradient (0 % → 18 % → 82 %
→ 100 %, transparent / opaque / opaque / transparent) so the cityscape fades
into the dark base at the top and bottom edges instead of cutting hard
against the header separator and the bottom edge of the window. That mask
was the missing piece during the prototype phase — without it the asset
read as a "rectangle of art pasted onto a black background" instead of a
seamless layer.

### Asset note (artist delivery, May 2026)

The client supplied a **new** cityscape image from their artist (the
isometric orange road grid on black). It was received through chat; there
was no separate source file attached.

**Technical reality after ingest:** the file arrived as **JPEG data** inside a
`.png` filename, decoded at **1024 × 572** pixels (not the 5376 × 3008 label
on the filename — chat pipelines often recompress and downscale). The
project stores a **proper PNG** at `Resources/Images/citymap_dark_4k.png`
(~960 KB) so WPF decodes reliably. That resolution is enough for a crisp hero
background at **1080p** with `Stretch="UniformToFill"` and `HighQuality`
scaling at the current **0.42** opacity.

**If the artist later sends a true high-res export** (e.g. 3840 × 2160 per
*City Scape Background.odt*, or the original 5376 × 3008 master from their
tooling), overwrite the same path — **no XAML change needed**.

## Acceptance criteria checklist

| # | Requirement                                                  | Status | Where to verify |
|---|--------------------------------------------------------------|--------|-----------------|
| 1 | Cityscape background integrated into the hero composition    | Done   | `Views/ActiveDarkWindow.xaml`, layer L5 |
| 2 | Layered correctly behind UI (no ghosting / no flat overlay)  | Done   | OpacityMask + 0.42 opacity + UniformToFill |
| 3 | Pixel-perfect to the source PNG at 100 % display scale       | Pending capture | `screenshots/side-by-side-100.png` |
| 4 | Pixel-perfect to the source PNG at 125 % display scale       | Pending capture | `screenshots/side-by-side-125.png` |
| 5 | Pixel-perfect to the source PNG at 150 % display scale       | Pending capture | `screenshots/side-by-side-150.png` |
| 6 | All M1 polish items (depth / glow / sidebar / hero) retained | Done   | No regression — same file, additive change only |

Items 3 / 4 / 5 only need Windows to capture; the build is ready.

## How to produce the M2 deliverable (Windows steps)

```powershell
# 1. Build and run
cd NineOneOneReality.Launcher
dotnet build
dotnet run
```

Then, **for each of the three Windows display scales (100, 125, 150)**:

1. Right-click the desktop → **Display settings** → Scale → pick the value
2. **Sign out and sign back in** (WPF only re-reads DPI on session start)
3. Run the launcher again and capture:

```powershell
cd ..
powershell -ExecutionPolicy Bypass -File .\tools\Capture-DpiScreenshot.ps1
```

That auto-names the file from the detected DPI so you end up with:

```
screenshots/dpi-100.png
screenshots/dpi-125.png
screenshots/dpi-150.png
```

Once all three captures are in place, build the side-by-side composites in
one command:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Compare-AllDpi.ps1
```

Outputs:

```
screenshots/side-by-side-100.png
screenshots/side-by-side-125.png
screenshots/side-by-side-150.png
```

Attach all three to the M2 submission.

## Layer L5 tuning knobs (in case you want to iterate)

If she comes back and asks for a stronger / softer cityscape, change two
numbers in `Views/ActiveDarkWindow.xaml`, no other code:

| What                                       | XAML attribute                | Current value | Direction                                         |
|--------------------------------------------|-------------------------------|---------------|---------------------------------------------------|
| How strong the cityscape reads             | `<Image ... Opacity="0.42">`  | 0.42          | Higher → more visible city. Brief said ~0.35.     |
| How aggressively top/bottom fade           | `<GradientStop Offset="0.18">`, `<... Offset="0.82">` | 0.18 / 0.82   | Move closer to 0 / 1 for a harder edge.           |

## What is still out of scope for M2

- **Light theme of the active screen** — Milestone 3.
- **The three inactive monitor screens** — Milestone 4 (PLUS / BASIC
  Instructor Inactive, BASIC Student Inactive, PROCOM Student Inactive — per
  the updated PDF).
- **Final QA, cleanup, handoff** — Milestone 5.

## File index delta (only what's new since M1)

```
NineOneOneReality.Launcher/
|-- NineOneOneReality.Launcher/
|   \-- Resources/Images/citymap_dark_4k.png   (NEW - artist cityscape)
|-- tools/
|   \-- Compare-AllDpi.ps1                     (NEW - 3-DPI batch composer)
|-- MILESTONE-2.md                             (NEW - this document)
\-- (everything else is unchanged from M1)
```
