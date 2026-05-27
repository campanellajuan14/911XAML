# Creates the Milestone 5 client delivery ZIP:
#   source + assets + docs + screenshots + Launcher-Run (published exe)
# Excludes IDE cache and project bin/obj (use Launcher-Run to run).

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$outZip = Join-Path $root "911XAML-delivery.zip"
$staging = Join-Path $env:TEMP "911XAML-delivery-staging"
$runDir = Join-Path $root "Launcher-Run"

if (-not (Test-Path (Join-Path $runDir "NineOneOneReality.Launcher.exe"))) {
    Write-Host "Launcher-Run missing; running Prepare-ClientRunFolder.ps1..."
    & (Join-Path $PSScriptRoot "Prepare-ClientRunFolder.ps1")
}

if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
if (Test-Path $outZip) { Remove-Item $outZip -Force }

New-Item -ItemType Directory -Path $staging | Out-Null

$excludeDirs = @('bin', 'obj', '.vs', '.git', 'node_modules', '_build_verify_out')
$excludeTopLevel = @('icon', 'new icon')

Get-ChildItem -Path $root -Force | Where-Object {
    $name = $_.Name
    if ($excludeTopLevel -contains $name) { return $false }
    if ($name -eq '911XAML-delivery.zip') { return $false }
    return $true
} | ForEach-Object {
    $dest = Join-Path $staging $_.Name
    if ($_.PSIsContainer) {
        robocopy $_.FullName $dest /E /XD $excludeDirs /NFL /NDL /NJH /NJS /NC /NS | Out-Null
        if ($LASTEXITCODE -ge 8) { throw "robocopy failed for $($_.Name)" }
    } else {
        Copy-Item $_.FullName $dest
    }
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($staging, $outZip)

Remove-Item $staging -Recurse -Force

$sizeMb = [math]::Round((Get-Item $outZip).Length / 1MB, 2)
Write-Host "Created: $outZip ($sizeMb MB)"
