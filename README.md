# 9-1-1 Reality Simulator — Active Skin (Milestone 1: Alignment Proof)

WPF / .NET 6 implementation of the dark **active screen** for the 9-1-1 Reality
Simulator instructor console. Built strictly in XAML using `Grid`, `Style`,
`ControlTemplate`, and `ResourceDictionary` — no third-party UI framework, no
code-behind visual logic, no WinForms, no HTML/CSS.

## Milestone 1 — what this delivery contains

The four post-prototype polish directions are all wired in:

| # | Direction | Implementation |
|---|-----------|----------------|
| 1 | Cinematic depth | Layered hero background: tiled vector grid → warm bottom horizon glow → diagonal atmospheric haze → multi-stop radial spotlight → scanline overlay → vignette. A commented-out slot for the artist's `citymap_dark_4k.png` is reserved at layer L5. |
| 2 | Glow layering | Multi-pass effects: warm halo behind the wordmark, two-effect title (wide orange `DropShadow` + tight dark ink shadow), 20-blur ECG bloom, 50-radius floor glow beneath the START button, orange halo behind the sidebar role badge. |
| 3 | Sidebar spacing | Hairline `Sidebar.Divider` style sits between the five sidebar zones (brand / primary nav / training / system / model input). Nav rows lifted from 42 → 44 px with a 6 px row gap. Section headers carry a 10 px bottom gutter. |
| 4 | Hero scale | Wordmark logo at 560×220 replaces the placeholder badge; title rebalanced to 88/76 pt (vs. 96/84 in the prototype); ECG widened 540 → 620 px; vertical rhythm tightened around the START block. |

The client's actual brand wordmark
(`Resources/Images/911-reality-logo.png`, from `new-requirement/911 reality/`)
is now wired into:

- the header (left side, 52 px tall)
- the hero panel (560 px wide, centered, with an orange `RadialGradientBrush`
  halo behind it and a 22-blur `DropShadowEffect` glow on the image itself)

The SVG version (`911-reality-logo.svg`) is also included in the same folder
for future vectorization (WPF needs a separate conversion pass; the PNG is
sized for crisp on-screen rendering at every used display size).

Other prototype features that remain in M1:

- **Sidebar** — top role/computer label, primary navigation, Training Resources
  section, System section (Restart / Shutdown), and a **free-form MODEL input**
  at the bottom (per the SOW's "fillable space - BASIC PLUS PROCOMM")
- **Hover / pressed / disabled** states on the START button and sidebar items
- **Storyboard animation** — looping 2.4 s opacity pulse on the ECG waveform
  (`SineEase` in/out)
- **DPI awareness** — `PerMonitorV2` declared in `app.manifest`,
  `UseLayoutRounding="True"` and `SnapsToDevicePixels="True"` on the window
- The window opens **maximized** so screenshots fill the available canvas at
  every DPI scale.

Explicitly **out of scope for M1**:

- Light theme of the active screen (Milestone 3)
- The four inactive-monitor screens (Milestone 4)
- Any backend wiring (start / restart / shutdown are inert)

## Milestone 1 deliverable: side-by-side proof

1. Build and run the project (instructions below).
2. With the window open at **100% display scale**, run:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\tools\Capture-DpiScreenshot.ps1
   ```
   That produces `screenshots\dpi-100.png` — the full WPF window at 100% DPI.
3. Produce the side-by-side comparison:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\tools\Compare-WithSource.ps1
   ```
   That reads `reference\active-dark-source.png` (the client's reference PNG)
   plus `screenshots\dpi-100.png` and writes
   `screenshots\side-by-side-100.png` — that file is the M1 alignment proof.

## How to build & run

Requires Visual Studio 2022 (17.4+) **or** the .NET 6 SDK on Windows.

```powershell
cd NineOneOneReality.Launcher
dotnet build
dotnet run --project NineOneOneReality.Launcher
```

Or just open `NineOneOneReality.Launcher.sln` in Visual Studio and press F5.

## File organization

```
NineOneOneReality.Launcher/
|-- NineOneOneReality.Launcher.sln
\-- NineOneOneReality.Launcher/
    |-- App.xaml                 # merges all global resource dictionaries
    |-- App.xaml.cs              # startup + global exception logging
    |-- app.manifest             # PerMonitorV2 DPI awareness
    |
    |-- Themes/
    |   |-- Brushes.Brand.xaml   # theme-independent brand colors (orange, etc.)
    |   |-- Theme.Dark.xaml      # dark palette (merged into the active window)
    |   |-- Theme.Light.xaml     # parallel light palette (kept for future use)
    |   |-- Typography.xaml      # Montserrat font + text styles
    |   \-- Effects.xaml         # reusable DropShadowEffects
    |
    |-- Controls/                # ControlTemplate + Style for each component
    |   |-- HeaderBar.xaml
    |   |-- NavButton.xaml       # sidebar item template w/ hover/pressed/selected/disabled
    |   |-- PrimaryButton.xaml   # START button template w/ hover/pressed/disabled
    |   \-- StatusPill.xaml      # SYSTEM STATUS / SIMULATION READY pills
    |
    |-- Animations/
    |   \-- MicroInteractions.xaml  # shared Duration + EasingFunction resources
    |
    |-- Resources/
    |   |-- Icons.xaml           # vector Geometry resources for every icon
    |   |-- Fonts/Montserrat-*.ttf
    |   \-- Images/              # source-of-truth design references and reserved
    |                            # slot for a future cityscape-silhouette.png
    |
    \-- Views/
        |-- ActiveDarkWindow.xaml      # the prototype screen
        \-- ActiveDarkWindow.xaml.cs   # only InitializeComponent()
```

The split is deliberate: theme palette, brand color, typography, control
template, and animation parameters can each be edited in isolation without
touching the view, and every key the view consumes is exposed via
`StaticResource` / `DynamicResource` lookups.

## Theming

The dark palette is merged at the **window** level
(`ActiveDarkWindow.xaml.Window.Resources`), not at App level. To produce a
light variant of the same screen, a sibling window swaps `Theme.Dark.xaml`
for `Theme.Light.xaml` and reuses every other dictionary unchanged. Both
theme files declare the same set of keys (e.g. `Brush.Theme.Background`,
`Brush.Theme.Sidebar.ItemHover`) so control templates that bind via
`DynamicResource` re-resolve automatically.

Brand colors that must remain constant across themes (e.g. the safety orange
`#FFFF7A00`, "system READY" green) live in `Brushes.Brand.xaml`.

## Animations

| Element        | Trigger                | Animation                                      |
| -------------- | ---------------------- | ---------------------------------------------- |
| ECG pulse line | `Loaded` event         | `Opacity` 0.55 → 1.0, 1.2s, `SineEase`, loop, auto-reverse |
| START button   | `IsMouseOver`          | `Opacity` 1.0 → 0.92 over 120ms                |
| START button   | `IsPressed`            | `RenderTransform` scale 1.0 → 0.97 over 80ms   |
| START button   | `IsEnabled = False`    | static disabled brush + reduced opacity        |
| Sidebar item   | `IsMouseOver`          | background swap to `Brush.Theme.Sidebar.ItemHover` |
| Sidebar item   | `IsChecked` (selected) | left orange indicator + filled background      |

The ECG pulse is the hero animation called out in the SOW ("ECG opacity pulse
**or** button hover transition" — both are present).

## DPI verification

The application targets the 1920×1080 design canvas and is `PerMonitorV2`
DPI-aware. To capture the three required scaling screenshots on Windows:

1. Right-click the desktop → **Display settings**
2. Set **Scale** to `100%`. **Sign out and sign back in** (required - WPF will
   otherwise report the previous DPI).
3. Run the launcher (`dotnet run` or the published exe), then either:
   - press `Win`+`Shift`+`S`, choose **Window snip**, paste into Paint,
     save as `screenshots/dpi-100.png`, **or**
   - run the bundled helper:
     `powershell -ExecutionPolicy Bypass -File .\tools\Capture-DpiScreenshot.ps1`
     which auto-names the file from the detected DPI.
4. Repeat for `125%` and `150%`.

Because the layout uses logical pixels with `UseLayoutRounding="True"` and
`SnapsToDevicePixels="True"`, the layout grid stays identical at every scale —
only text and icon glyph rasterization re-renders for the new device pixel
density. No "blurry text" or layout shift is expected.

## Known notes for the reviewer

- `App.xaml.cs` attaches dispatcher / domain / task-scheduler exception handlers
  that always write to `startup-error.log` next to the executable; in `DEBUG`
  builds they additionally surface a `MessageBox` so a developer can see the
  stack trace immediately. This guards against silent failures of `WinExe`
  apps and is intentional for the prototype phase.
- `Theme.Light.xaml` is included to demonstrate the parallel-key theming
  contract; the Milestone 3 light variant of the active screen will consume it.
- The hero panel background is built from **vector XAML only** — a tiled
  `DrawingBrush` grid, a warm bottom horizon `LinearGradientBrush`, a diagonal
  haze `LinearGradientBrush`, a multi-stop `RadialGradientBrush` spotlight,
  a 1×3 scanline `DrawingBrush`, and a vignette. The reserved L5 slot is
  ready for the artist's **background-only derivative** of
  `cityscape-active-source.png` (transparent city skyline + orange road glow
  only — no UI, no text). Drop that file at
  `Resources/Images/citymap_dark_4k.png` and uncomment the `<Image>` at L5 to
  layer it in at the recommended 0.35 opacity with a top/bottom soft mask.
