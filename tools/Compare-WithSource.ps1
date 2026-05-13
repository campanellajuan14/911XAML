<#
.SYNOPSIS
    Build a side-by-side PNG comparing the latest WPF screenshot with the
    original source reference, for M1 alignment proof deliverables.

.DESCRIPTION
    The Milestone 1 acceptance criteria asks for a screenshot of the active
    screen delivered "side-by-side with PNG". This script composes:

        [ Source reference PNG ]   |   [ Latest WPF screenshot ]

    into one image so the reviewer can compare alignment without manually
    arranging the two files.

    By default it reads:
      * source:     .\reference\active-dark-source.png
      * screenshot: .\screenshots\dpi-100.png  (use Capture-DpiScreenshot.ps1
                                                to produce this first)

    Output: .\screenshots\side-by-side-100.png

.PARAMETER Source
    Path to the source reference PNG.

.PARAMETER Capture
    Path to the WPF screenshot to compare.

.PARAMETER OutputPath
    Path to the side-by-side composite PNG to produce.

.PARAMETER LabelHeight
    Height in pixels of the title strip drawn above each image.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\tools\Compare-WithSource.ps1
#>

[CmdletBinding()]
param(
    [string]$Source     = (Join-Path $PSScriptRoot "..\reference\active-dark-source.png"),
    [string]$Capture    = (Join-Path $PSScriptRoot "..\screenshots\dpi-100.png"),
    [string]$OutputPath = (Join-Path $PSScriptRoot "..\screenshots\side-by-side-100.png"),
    [int]$LabelHeight   = 48
)

Add-Type -AssemblyName System.Drawing

function Resolve-OrFail([string]$path, [string]$role) {
    $full = Resolve-Path -LiteralPath $path -ErrorAction SilentlyContinue
    if (-not $full) {
        Write-Error "$role not found: $path"
        exit 1
    }
    return $full.Path
}

$srcPath = Resolve-OrFail $Source  "Source reference PNG"
$capPath = Resolve-OrFail $Capture "WPF screenshot"

$src = [System.Drawing.Image]::FromFile($srcPath)
$cap = [System.Drawing.Image]::FromFile($capPath)

# Normalize both images to the same display height (the smaller of the two)
$targetH = [Math]::Min($src.Height, $cap.Height)
$srcW    = [int]($src.Width  * ($targetH / $src.Height))
$capW    = [int]($cap.Width  * ($targetH / $cap.Height))

$gutter  = 24
$padding = 32
$totalW  = $padding + $srcW + $gutter + $capW + $padding
$totalH  = $LabelHeight + $padding + $targetH + $padding

$out = New-Object System.Drawing.Bitmap $totalW, $totalH
$g   = [System.Drawing.Graphics]::FromImage($out)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

# Dark background
$g.Clear([System.Drawing.Color]::FromArgb(255, 12, 12, 14))

# Title strip
$title    = "Active Dark Screen - Source (left)   vs   WPF Implementation (right) - 100% DPI"
$font     = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$orange   = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 122, 0))
$titleRect = New-Object System.Drawing.RectangleF 0, 0, $totalW, $LabelHeight
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment     = [System.Drawing.StringAlignment]::Center
$sf.LineAlignment = [System.Drawing.StringAlignment]::Center
$g.DrawString($title, $font, $orange, $titleRect, $sf)

# Source image
$srcRect = New-Object System.Drawing.Rectangle $padding, ($LabelHeight + $padding), $srcW, $targetH
$g.DrawImage($src, $srcRect)

# Capture image
$capX = $padding + $srcW + $gutter
$capRect = New-Object System.Drawing.Rectangle $capX, ($LabelHeight + $padding), $capW, $targetH
$g.DrawImage($cap, $capRect)

# Orange divider between the two
$pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(180, 255, 122, 0)), 2
$divX = $padding + $srcW + ($gutter / 2)
$g.DrawLine($pen, $divX, ($LabelHeight + $padding - 6), $divX, ($LabelHeight + $padding + $targetH + 6))

# Save
$dir = Split-Path -Parent $OutputPath
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
$out.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose(); $out.Dispose(); $src.Dispose(); $cap.Dispose(); $font.Dispose(); $orange.Dispose(); $pen.Dispose()

Write-Host ("Saved {0}  ({1} x {2} px)" -f $OutputPath, $totalW, $totalH)
