<#
.SYNOPSIS
    Runs the source-vs-WPF side-by-side composer for every DPI screenshot in
    the screenshots/ folder. Use after capturing dpi-100.png / dpi-125.png /
    dpi-150.png with Capture-DpiScreenshot.ps1.

.DESCRIPTION
    Milestone 2 ("Active Screen Pixel-Perfect Completion") requires alignment
    proofs at all three DPI scales (100 %, 125 %, 150 %), not just the M1
    100 % proof. This wrapper just calls Compare-WithSource.ps1 once for each
    screenshot that exists, so the M2 deliverable is one command after the
    captures are done.

    Expected file naming (matches Capture-DpiScreenshot.ps1 output):
      .\screenshots\dpi-100.png
      .\screenshots\dpi-125.png
      .\screenshots\dpi-150.png

    Output (one per input):
      .\screenshots\side-by-side-100.png
      .\screenshots\side-by-side-125.png
      .\screenshots\side-by-side-150.png

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\tools\Compare-AllDpi.ps1
#>

[CmdletBinding()]
param(
    [string]$Source         = (Join-Path $PSScriptRoot "..\reference\active-dark-source.png"),
    [string]$ScreenshotsDir = (Join-Path $PSScriptRoot "..\screenshots")
)

$compareScript = Join-Path $PSScriptRoot "Compare-WithSource.ps1"

if (-not (Test-Path $compareScript)) {
    Write-Error "Compare-WithSource.ps1 not found next to this script."
    exit 1
}

if (-not (Test-Path $Source)) {
    Write-Error "Source reference PNG not found: $Source"
    exit 1
}

$scales = @(100, 125, 150)
$ran    = 0
$missing = @()

foreach ($scale in $scales) {
    $capture = Join-Path $ScreenshotsDir "dpi-$scale.png"
    $output  = Join-Path $ScreenshotsDir "side-by-side-$scale.png"

    if (-not (Test-Path $capture)) {
        $missing += "dpi-$scale.png"
        continue
    }

    Write-Host ""
    Write-Host "=== Composing side-by-side for $scale% DPI ===" -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File $compareScript `
        -Source $Source -Capture $capture -OutputPath $output
    $ran++
}

Write-Host ""
if ($missing.Count -gt 0) {
    Write-Host "Skipped (capture missing):" -ForegroundColor Yellow
    $missing | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
    Write-Host ""
    Write-Host "Run Capture-DpiScreenshot.ps1 after switching Windows display scale to the missing values, then re-run this script." -ForegroundColor Yellow
}
Write-Host ""
Write-Host ("Built {0} side-by-side composite(s)." -f $ran) -ForegroundColor Green
