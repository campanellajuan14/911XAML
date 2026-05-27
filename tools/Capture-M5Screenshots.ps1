# Regenerates M5 QA screenshots from the CURRENT Release build (correct window per folder).
# Replaces stale "side-by-side-*.png" files that may show wrong screens or old light-active citymap.

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$project = Join-Path $root "NineOneOneReality.Launcher\NineOneOneReality.Launcher.csproj"
$exe = Join-Path $root "NineOneOneReality.Launcher\bin\Release\net8.0-windows\NineOneOneReality.Launcher.exe"
$outRoot = Join-Path $root "NineOneOneReality.Launcher\Screenshots"

Write-Host "Building Release..."
dotnet build $project -c Release --nologo -v q
if ($LASTEXITCODE -ne 0) { throw "Build failed" }

# Remove legacy side-by-side captures (wrong naming / wrong content risk).
Get-ChildItem -Path $outRoot -Recurse -Filter "side-by-side*.png" -ErrorAction SilentlyContinue |
    Remove-Item -Force

foreach ($dpi in @(100, 125, 150)) {
    Write-Host "Capturing at ${dpi}% (logical DPI scale in render)..."
    & $exe --capture-screenshots=$outRoot --screenshot-dpi=$dpi
    if ($LASTEXITCODE -ne 0) { throw "Capture failed at ${dpi}%" }
}

Write-Host "`nDone. PNGs written under: $outRoot"
Get-ChildItem -Path $outRoot -Recurse -Filter "*.png" | Select-Object FullName, Length
