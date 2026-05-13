<#
.SYNOPSIS
    Builds M2 DPI side-by-side composites and writes an evidence report for the client.

.DESCRIPTION
    1. Runs Compare-AllDpi.ps1.
    2. Writes screenshots/M2-evidence-report.txt listing which required and
       optional evidence files exist.

    Attach the report plus the three side-by-side PNGs when submitting M2.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\tools\Publish-M2Evidence.ps1 -PromoteToCanonical
#>

[CmdletBinding()]
param(
    [string]$Source         = (Join-Path $PSScriptRoot "..\reference\active-dark-source.png"),
    [string]$ScreenshotsDir = (Join-Path $PSScriptRoot "..\screenshots"),
    [switch]$PromoteToCanonical,
    [switch]$Strict
)

$allDpi = Join-Path $PSScriptRoot "Compare-AllDpi.ps1"

$splat = @{
    Source         = $Source
    ScreenshotsDir = $ScreenshotsDir
}
if ($PromoteToCanonical) { $splat['PromoteToCanonical'] = $true }
if ($Strict) { $splat['Strict'] = $true }

& $allDpi @splat

$reportPath = Join-Path $ScreenshotsDir "M2-evidence-report.txt"
$lines = @()
$lines += "M2 evidence report — generated $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += ""
$lines += "=== Required DPI composites (contract) ==="
foreach ($s in 100, 125, 150) {
    $p = Join-Path $ScreenshotsDir ("side-by-side-{0}.png" -f $s)
    $ok = Test-Path -LiteralPath $p
    $lines += ("  {0,-40} {1}" -f (Split-Path $p -Leaf), ($(if ($ok) { "OK" } else { "MISSING" })))
}
$lines += ""
$lines += "=== Raw DPI captures (Compare-AllDpi accepts either name per scale) ==="
foreach ($s in 100, 125, 150) {
    $a = Join-Path $ScreenshotsDir ("dpi-{0}.png" -f $s)
    $b = Join-Path $ScreenshotsDir ("{0}%.png" -f $s)
    $lines += ("  dpi-{0}.png     : {1}" -f $s, ($(if (Test-Path -LiteralPath $a) { "present" } else { "absent" })))
    $lines += ("  {0}%.png        : {1}" -f $s, ($(if (Test-Path -LiteralPath $b) { "present" } else { "absent" })))
}
$lines += ""
$lines += "=== Optional interaction-state evidence (see MILESTONE-2-QA.md) ==="
$interactionDir = Join-Path $ScreenshotsDir "interactions"
if (Test-Path -LiteralPath $interactionDir) {
    $items = Get-ChildItem -LiteralPath $interactionDir -Filter "*.png" -ErrorAction SilentlyContinue
    if ($items) {
        $items | ForEach-Object { $lines += ("  interactions/{0}  OK" -f $_.Name) }
    } else {
        $lines += "  (interactions folder empty — add PNGs per MILESTONE-2-QA.md)"
    }
} else {
    $lines += "  (no screenshots/interactions/ folder yet)"
}

$reportText = ($lines -join [Environment]::NewLine)
if (-not (Test-Path -LiteralPath $ScreenshotsDir)) {
    New-Item -ItemType Directory -Path $ScreenshotsDir -Force | Out-Null
}
Set-Content -LiteralPath $reportPath -Value $reportText -Encoding UTF8
Write-Host ""
Write-Host ("Wrote {0}" -f $reportPath) -ForegroundColor Cyan
Write-Host ""
Write-Host $reportText
