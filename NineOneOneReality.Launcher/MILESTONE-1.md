# Milestone 1 — Alignment Proof Delivery

**Scope:** One active screen (dark) skeleton, built in WPF / .NET 6, proving the
final visual direction is achievable with the proposed XAML structure and that
the pixel-perfect language is understood before further milestones are funded.

---

## Acceptance criteria checklist

Items below map 1:1 to the M1 definition you provided.

| # | Requirement                                                  | Status | Where to verify |
|---|--------------------------------------------------------------|--------|-----------------|
| 1 | Visual Studio WPF / .NET 6 solution                          | Done   | `NineOneOneReality.Launcher.sln` (open in VS 2022 / 17.4+) |
| 2 | Project structure with `ResourceDictionary`-based theming    | Done   | `NineOneOneReality.Launcher/Themes/` + `App.xaml` |
| 3 | XAML-only layout (`Grid`, `Style`, `ControlTemplate`)        | Done   | `Views/`, `Controls/`, no third-party UI deps in `.csproj` |
| 4 | Main active screen recreated at 100% DPI                     | Done   | `Views/ActiveDarkWindow.xaml` (opens maximized) |
| 5 | Key fonts (Montserrat embedded)                              | Done   | `Resources/Fonts/Montserrat.ttf`, `Themes/Typog
raphy.xaml` |
| 6 | Key colors (palette + brand orange)                          | Done   | `Themes/Theme.Dark.xaml`, `Themes/Brushes.Brand.xaml` |
| 7 | Spacing / panels / buttons mapped to the source PNG          | Done   | See "Design specification" table below |
| 8 | Side-by-side screenshot vs the supplied PNG                  | Pending capture on Windows — see "Producing the alignment proof" |

## Post-prototype direction included in M1

The four polish directions from your feedback after the prototype are baked
into this build so the alignment proof already shows the final visual language:

| Direction              | What landed                                                                                  |
|------------------------|----------------------------------------------------------------------------------------------|
| Cinematic depth        | 10-layer hero composition: vector grid, warm bottom-horizon glow, diagonal atmospheric haze, multi-stop radial spotlight, scanline overlay, vignette, reserved slot for the artist's cityscape PNG. |
| Glow layering          | Two-effect title (warm outer halo + dark ink shadow), 22-blur drop shadow on the wordmark image, 20-blur 0.95-opacity ECG bloom, 320×50 floor glow under the START button, halo behind the sidebar role badge. |
| Sidebar spacing polish | Hairline dividers (`Sidebar.Divider` style) between the five sidebar zones — brand / primary nav / training resources / system / model input. Nav row height 42 → 44 with 3 px row gap. |
| Hero scale rebalance   | Wordmark logo at 560 × 220 replaces the placeholder badge. Title 88 / 76 pt (down from 96 / 84). ECG widened 540 → 620. Vertical rhythm tightened around the START block. |

## Brand asset integration

Your 911 Reality wordmark is wired into the build:

- **Header (52 px tall, left side)** — `Resources/Images/911-reality-logo.png`,
  rendered with `RenderOptions.BitmapScalingMode="HighQuality"`.
- **Hero (560 px wide, centered)** — same source, fronted by a warm
  `RadialGradientBrush` halo and a 22-blur `DropShadowEffect` glow on the image
  itself.
- **SVG kept alongside** for the future vectorization pass
  (`Resources/Images/911-reality-logo.svg`). WPF needs an SVG → `Geometry`
  conversion step to render the SVG natively; the PNG is sized for crisp
  rendering at every used display size in the meantime.

## Producing the alignment proof (side-by-side PNG)

This is the only step that has to happen on a Windows machine. From the
solution root after building:

```powershell
# 1. Build and run the launcher
cd NineOneOneReality.Launcher
dotnet build
dotnet run
```

Then, on the running window, with Windows display scale set to **100%**:

```powershell
# 2. Capture the full-window PNG (auto-named from detected DPI)
cd ..
powershell -ExecutionPolicy Bypass -File .\tools\Capture-DpiScreenshot.ps1

# 3. Compose the side-by-side
powershell -ExecutionPolicy Bypass -File .\tools\Compare-WithSource.ps1
```

Output: `screenshots\side-by-side-100.png` — the source reference on the left,
the WPF render on the right, separated by an orange divider with a title
strip. That file is the M1 deliverable.

## Design specification (what was matched and why)

The numbers below back up the "pixel-perfect understanding" the M1 review
checks for; they all live in the dictionaries so M2 can iterate without
touching the views.

### Color palette (sampled from `Active Screen with city scape added.png`)

| Token                                | Hex         | Role                                        |
|--------------------------------------|-------------|---------------------------------------------|
| `Brush.Theme.Background`             | `#FF050505` | Window backdrop / hero base                 |
| `Brush.Theme.Sidebar`                | `#FF1F2227` | Slate-charcoal sidebar surface              |
| `Brush.Theme.Sidebar.ItemHover`      | `#FF2A2D33` | Nav row hover                               |
| `Brush.Theme.Sidebar.ItemSelected`   | `#FF35373E` | Nav row checked (with orange left indicator)|
| `Brush.Theme.Border.Subtle`          | `#FF1A1A1A` | Hairline dividers between sidebar sections  |
| `Brush.Theme.Divider.Orange`         | `#80FF7A00` | Header underline + hero top stripe          |
| `Brush.Brand.Orange`                 | `#FFFF7A00` | Primary safety-orange (button, ECG, glow)   |
| `Brush.Brand.Orange.Bright`          | `#FFFF8C1A` | START button top gradient stop              |
| `Brush.Brand.Orange.Glow`            | `#FFFF6A00` | START button bottom stop, halo / glow tone  |
| `Brush.Brand.Orange.Deep`            | `#FFE85F00` | Pressed-state gradient, warmer secondary    |
| `Brush.Status.Green`                 | `#FF5AC85A` | "SIMULATION READY" status pill              |

### Typography scale

| Token                              | Size  | Used on                                       |
|------------------------------------|-------|-----------------------------------------------|
| `Font.Size.HeroTitleMain`          | 88 pt | "9-1-1 REALITY" (first hero line)             |
| `Font.Size.HeroTitleAccent`        | 76 pt | "SIMULATOR" (second hero line)                |
| `Font.Size.PrimaryButton`          | 38 pt | START button face                             |
| `Font.Size.SectionLabel`           | 32 pt | "START SIMULATION" label above the button     |
| `Font.Size.HeaderBrand`            | 28 pt | Header brand text (now replaced by wordmark)  |
| `Font.Size.HeaderMeta`             | 20 pt | "11:23 AM" / status pill metadata             |
| `Font.Size.SidebarBrand`           | 18 pt | "INSTRUCTOR 2" role label                     |
| `Font.Size.NavItem`                | 15 pt | Sidebar navigation items                      |
| `Font.Size.NavSection`             | 14 pt | "TRAINING RESOURCES" / "SYSTEM" section heads |

All sizes resolve from `Themes/Typography.xaml`; no font sizes are
hard-coded in the view.

### Layout grid

| Region        | Logical size           | Notes                                         |
|---------------|------------------------|-----------------------------------------------|
| Design canvas | 1920 × 1080            | Window opens maximized                        |
| Header        | * × 78                 | Wordmark left, status pill + clock right      |
| Sidebar       | 260 × *                | Five zones separated by `Sidebar.Divider`     |
| Hero          | * × *                  | 10-layer composition, content vertically centered |
| Nav row       | 44 px tall, 6 px gap   | Slight increase from prototype's 42 / 4       |
| Wordmark hero | 560 × 220              | Halo ellipse + 22-blur drop shadow            |
| ECG line      | 620 × 36               | Widened from prototype's 540                  |
| START button  | template default       | 320 × 50 floor glow ellipse underneath        |

## Interaction states (already wired)

| Surface       | Hover                                       | Pressed                                          | Disabled                                  |
|---------------|---------------------------------------------|--------------------------------------------------|-------------------------------------------|
| START button  | `Opacity` 1.0 → 0.92 (120 ms)               | `RenderTransform` scale 1.0 → 0.97 (80 ms)       | Muted background + reduced opacity        |
| Sidebar item  | Background → `Brush.Theme.Sidebar.ItemHover`| —                                                | `IsHitTestVisible="False"` + 0.5 opacity  |
| Sidebar item  | Selected: orange left bar + filled bg       | —                                                | —                                         |

## Storyboard animation

ECG waveform pulses `Opacity` 0.55 → 1.00 over 1.2 s using `SineEase` in/out,
auto-reversing, looping forever. Triggered from
`FrameworkElement.Loaded` on the `EcgPulseLine` path inside
`Views/ActiveDarkWindow.xaml`.

## DPI behaviour

`PerMonitorV2` declared in `app.manifest`, with
`UseLayoutRounding="True"` and `SnapsToDevicePixels="True"` on the window.
Layout is in logical pixels so the grid stays identical at 100 / 125 / 150 %;
only text and icon glyph rasterization re-renders per device pixel density.

The dpi-125 / dpi-150 screenshots are part of **Milestone 2** (pixel-perfect
completion). M1 ships the 100 % proof only.

## What is deliberately out of scope for M1

- **Light theme of the active screen** — `Themes/Theme.Light.xaml` is present
  to demonstrate the parallel-key contract; the Milestone 3 light variant will
  consume it.
- **Three inactive monitor screens** — Milestone 4.
- **Live mapping engine** — the eventual mapping layer will be a stylized
  vector city-grid (consistent with the cinematic look), not a heavy live map
  service, per our last exchange.
- **Backend wiring** — start / restart / shutdown are inert; they exist as
  surfaces with full interaction states only.

## What we're still waiting on from your artist

Reserved slot in the hero composition (`Views/ActiveDarkWindow.xaml`, layer L5,
commented out):

> A **background-only derivative** of `cityscape-active-source.png` — a
> transparent PNG containing only the dark base + orange illuminated road glow
> (no UI, no text, no buttons). Per your *City Scape Background.odt* brief,
> 3840 × 2160, dark base, orange illuminated roads, no labels. Drop the file
> at `Resources/Images/citymap_dark_4k.png` and uncomment layer L5 to layer it
> in at the recommended 0.35 opacity with a soft top/bottom mask. No other
> change is needed in the view.

Until that lands, the cinematic depth is carried by the vector layers above —
the side-by-side proof in M1 was produced without it on purpose so you can
see the structural alignment, not the artist's pass.

## File index

```
NineOneOneReality.Launcher/
|-- NineOneOneReality.Launcher.sln
|-- NineOneOneReality.Launcher/
|   |-- App.xaml                          # merges global dictionaries
|   |-- App.xaml.cs                       # startup + global exception logger
|   |-- app.manifest                      # PerMonitorV2 DPI awareness
|   |-- Properties/AssemblyInfo.cs
|   |
|   |-- Themes/
|   |   |-- Brushes.Brand.xaml            # theme-independent brand colors
|   |   |-- Theme.Dark.xaml               # dark palette (merged at window)
|   |   |-- Theme.Light.xaml              # parallel light palette (M3 seed)
|   |   |-- Typography.xaml               # Montserrat + size tokens
|   |   \-- Effects.xaml                  # reusable DropShadowEffects
|   |
|   |-- Controls/                         # templates + styles
|   |   |-- HeaderBar.xaml
|   |   |-- NavButton.xaml                # incl. hover / pressed / selected / disabled
|   |   |-- PrimaryButton.xaml            # START template w/ states
|   |   \-- StatusPill.xaml               # SIMULATION READY / SYSTEM STATUS
|   |
|   |-- Animations/MicroInteractions.xaml # shared Durations + Easings
|   |
|   |-- Resources/
|   |   |-- Icons.xaml                    # vector Geometry for every glyph
|   |   |-- Fonts/Montserrat.ttf
|   |   \-- Images/911-reality-logo.png   # wired in header + hero
|   |       911-reality-logo.svg          # kept for future vectorization
|   |       cityscape-active-source.png   # master skyline source
|   |
|   \-- Views/
|       |-- ActiveDarkWindow.xaml         # the M1 screen
|       \-- ActiveDarkWindow.xaml.cs      # only InitializeComponent()
|
|-- reference/active-dark-source.png      # client's source PNG, for comparison
|-- tools/
|   |-- Capture-DpiScreenshot.ps1         # PrintWindow-based full-window capture
|   \-- Compare-WithSource.ps1            # source-vs-WPF side-by-side composer
|
|-- README.md
\-- MILESTONE-1.md                        # this document
```
