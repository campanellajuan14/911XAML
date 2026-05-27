# Runs dotnet restore, Release build, and smoke tests; writes a timestamped proof log
# for client acceptance (include in delivery ZIP via Create-DeliveryZip.ps1).

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$project = Join-Path $root "NineOneOneReality.Launcher\NineOneOneReality.Launcher.csproj"
$qaDir = Join-Path $root "NineOneOneReality.Launcher\QA"
$logFile = Join-Path $qaDir "build-and-smoke-proof.txt"

New-Item -ItemType Directory -Path $qaDir -Force | Out-Null

function Write-ProofLine([string]$line) {
    $line | Tee-Object -FilePath $logFile -Append
}

if (Test-Path $logFile) { Remove-Item $logFile -Force }

Write-ProofLine "911 Reality Launcher - build and smoke proof"
Write-ProofLine "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss K')"
Write-ProofLine "Machine: $env:COMPUTERNAME"
Write-ProofLine "OS: $([System.Environment]::OSVersion.VersionString)"
Write-ProofLine ""

Write-ProofLine "=== dotnet --info ==="
dotnet --info 2>&1 | ForEach-Object { Write-ProofLine $_ }
Write-ProofLine ""

Write-ProofLine "=== dotnet restore ==="
dotnet restore $project 2>&1 | ForEach-Object { Write-ProofLine $_ }
if ($LASTEXITCODE -ne 0) { throw "dotnet restore failed" }
Write-ProofLine "restore exit code: $LASTEXITCODE"
Write-ProofLine ""

Write-ProofLine "=== dotnet build -c Release ==="
dotnet build $project -c Release --nologo 2>&1 | ForEach-Object { Write-ProofLine $_ }
if ($LASTEXITCODE -ne 0) { throw "dotnet build failed" }
Write-ProofLine "build exit code: $LASTEXITCODE"
Write-ProofLine ""

Write-ProofLine "=== smoke tests (tools/Run-SmokeTests.ps1) ==="
& (Join-Path $PSScriptRoot "Run-SmokeTests.ps1") 2>&1 | ForEach-Object { Write-ProofLine $_ }
if ($LASTEXITCODE -ne 0) { throw "smoke tests failed" }
Write-ProofLine "smoke exit code: $LASTEXITCODE"
Write-ProofLine ""
Write-ProofLine "PASS - restore, Release build, and smoke matrix completed successfully."

Write-Host "`nProof log: $logFile" -ForegroundColor Green
