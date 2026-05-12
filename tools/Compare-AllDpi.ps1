<#
.SYNOPSIS
    Builds source-vs-WPF side-by-side composites for 100%, 125%, and 150% DPI.

.DESCRIPTION
    Milestone 2 requires these deliverables under screenshots/:
      side-by-side-100.png
      side-by-side-125.png
      side-by-side-150.png

    For each scale, the script looks for a capture file in this order (first
    match wins):
      1. dpi-{scale}.png          (output of Capture-DpiScreenshot.ps1)
      2. {scale}%.png             (e.g. 100%.png — common when saving manually)
      3. dpi-{scale}percent.png   (optional alternate)

    If you used manual names only, run with -PromoteToCanonical to also copy
    the matched file to dpi-{scale}.png so the repo has one consistent naming
    scheme going forward.

.PARAMETER PromoteToCanonical
    When a non-canonical capture is found (e.g. 100%.png), copy it to
    dpi-100.png after composing (does not delete the original).

.PARAMETER Strict
    Exit with code 1 if any of the three side-by-side outputs could not be
    built (useful for CI / pre-submit checks).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\tools\Compare-AllDpi.ps1 -PromoteToCanonical
#>

[CmdletBinding()]
param(
    [string]$Source         = (Join-Path $PSScriptRoot "..\reference\active-dark-source.png"),
    [string]$ScreenshotsDir = (Join-Path $PSScriptRoot "..\screenshots"),
    [switch]$PromoteToCanonical,
    [switch]$Strict
)

$compareScript = Join-Path $PSScriptRoot "Compare-WithSource.ps1"

if (-not (Test-Path $compareScript)) {
    Write-Error "Compare-WithSource.ps1 not found next to this script."
    exit 1
}

if (-not (Test-Path -LiteralPath $Source)) {
    Write-Error "Source reference PNG not found: $Source"
    exit 1
}

if (-not (Test-Path -LiteralPath $ScreenshotsDir)) {
    New-Item -ItemType Directory -Path $ScreenshotsDir -Force | Out-Null
}

$scales = @(100, 125, 150)
$ran     = 0
$missing = @()

foreach ($scale in $scales) {
    $canonical = Join-Path $ScreenshotsDir ("dpi-{0}.png" -f $scale)
    $candidates = @(
        $canonical,
        (Join-Path $ScreenshotsDir ("{0}%.png" -f $scale)),
        (Join-Path $ScreenshotsDir ("dpi-{0}percent.png" -f $scale))
    )

    $capture = $null
    foreach ($c in $candidates) {
        if (Test-Path -LiteralPath $c) {
            $capture = $c
            break
        }
    }

    $output = Join-Path $ScreenshotsDir ("side-by-side-{0}.png" -f $scale)

    if (-not $capture) {
        $missing += "dpi-$scale.png (or ${scale}%.png)"
        continue
    }

    if ($capture -ne $canonical) {
        Write-Host ("Using capture: {0}" -f $capture) -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "=== Composing side-by-side for $scale% DPI ===" -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File $compareScript `
        -Source $Source -Capture $capture -OutputPath $output
    $ran++

    if ($PromoteToCanonical -and ($capture -ne $canonical)) {
        Copy-Item -LiteralPath $capture -Destination $canonical -Force
        Write-Host ("Promoted copy to: {0}" -f $canonical) -ForegroundColor Green
    }
}

Write-Host ""
if ($missing.Count -gt 0) {
    Write-Host "Skipped (no capture found for):" -ForegroundColor Yellow
    $missing | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
    Write-Host ""
    Write-Host "Run Capture-DpiScreenshot.ps1 at each scale, or save as 100%.png / 125%.png / 150%.png in screenshots\, then re-run." -ForegroundColor Yellow
}

Write-Host ""
Write-Host ("Built {0} / 3 side-by-side composite(s)." -f $ran) -ForegroundColor $(if ($ran -eq 3) { "Green" } else { "Yellow" })

if ($Strict -and $ran -lt 3) {
    exit 1
}
