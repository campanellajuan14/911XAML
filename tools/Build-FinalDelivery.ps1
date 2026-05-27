# One-command final Milestone 5 package: screenshots, proof, runnable folder, ZIP.

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

Write-Host "=== 1/5 Regenerate QA screenshots ==="
& (Join-Path $PSScriptRoot "Capture-M5Screenshots.ps1")

Write-Host "`n=== 2/5 Build + smoke proof log ==="
& (Join-Path $PSScriptRoot "Run-BuildProof.ps1")

Write-Host "`n=== 3/5 Prepare Launcher-Run (published exe) ==="
& (Join-Path $PSScriptRoot "Prepare-ClientRunFolder.ps1")

Write-Host "`n=== 4/5 Create delivery ZIP ==="
& (Join-Path $PSScriptRoot "Create-DeliveryZip.ps1")

Write-Host "`n=== 5/5 Verify ZIP ==="
& (Join-Path $PSScriptRoot "Verify-DeliveryZip.ps1")

Write-Host "`nFINAL DELIVERY READY: $(Join-Path $root '911XAML-delivery.zip')" -ForegroundColor Green
Write-Host "Send with docs/QUICK-START.md and DELIVERY-CONTENTS.md to the client."
