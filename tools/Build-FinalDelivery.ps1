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

Write-Host "`n=== 5/6 Verify ZIP ==="
& (Join-Path $PSScriptRoot "Verify-DeliveryZip.ps1")

Write-Host "`n=== 6/6 Build Windows installer (Windows911-Launcher-Setup.exe) ==="
& (Join-Path $PSScriptRoot "Build-WindowsInstaller.ps1")

Write-Host "`nFINAL DELIVERY READY:" -ForegroundColor Green
Write-Host "  ZIP:       $(Join-Path $root '911XAML-delivery.zip')"
Write-Host "  INSTALLER: $(Join-Path $root 'Windows911-Launcher-Setup.exe')"
Write-Host "Send Windows911-Launcher-Setup.exe to the client (one double-click install, no SDK needed)."
