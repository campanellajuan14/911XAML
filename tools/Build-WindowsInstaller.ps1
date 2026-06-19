# Builds Windows911-Launcher-Setup.exe — one-click client installer (self-contained, no .NET install needed).

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$project = Join-Path $root "NineOneOneReality.Launcher\NineOneOneReality.Launcher.csproj"
$staging = Join-Path $root "_installer-staging"
$iss = Join-Path $root "installer\Windows911-Launcher-Setup.iss"
$outExe = Join-Path $root "Windows911-Launcher-Setup.exe"

$isccCandidates = @(
    "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe"
    "$env:ProgramFiles\Inno Setup 6\ISCC.exe"
)
$iscc = $isccCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $iscc) {
    throw @"
Inno Setup 6 is required to build the installer.
Install it with: winget install --id JRSoftware.InnoSetup -e
Then run this script again.
"@
}

Write-Host "=== 1/3 Publish self-contained Release (win-x64) ==="
if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
dotnet publish $project -c Release -r win-x64 --self-contained true -o $staging --nologo
if ($LASTEXITCODE -ne 0) { throw "dotnet publish failed" }

$publishedExe = Join-Path $staging "NineOneOneReality.Launcher.exe"
if (-not (Test-Path $publishedExe)) { throw "Missing published exe: $publishedExe" }

$stagingMb = [math]::Round((Get-ChildItem $staging -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 1)
Write-Host "Published to $staging ($stagingMb MB, includes .NET runtime)"

Write-Host "`n=== 2/3 Compile Windows911-Launcher-Setup.exe ==="
if (Test-Path $outExe) { Remove-Item $outExe -Force }

& $iscc "/DStagingDir=$staging" "/DRepoRoot=$root" $iss
if ($LASTEXITCODE -ne 0) { throw "Inno Setup compile failed" }
if (-not (Test-Path $outExe)) { throw "Installer not created: $outExe" }

$installerMb = [math]::Round((Get-Item $outExe).Length / 1MB, 1)
Write-Host "`n=== 3/3 Done ==="
Write-Host "CLIENT INSTALLER READY: $outExe ($installerMb MB)" -ForegroundColor Green
Write-Host "Send this single file to the client. They double-click it, click Next, and use Start menu shortcuts."
