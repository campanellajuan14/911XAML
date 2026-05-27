# Quick smoke test: launch each CLI mode, verify process starts, then exit.
# Checks startup-error.log for new entries after the run batch.

$ErrorActionPreference = "Stop"

$project = Join-Path (Split-Path -Parent $PSScriptRoot) "NineOneOneReality.Launcher\NineOneOneReality.Launcher.csproj"
$exe = Join-Path (Split-Path -Parent $PSScriptRoot) "NineOneOneReality.Launcher\bin\Release\net8.0-windows\NineOneOneReality.Launcher.exe"

Write-Host "Building Release..."
dotnet build $project -c Release --nologo -v q
if ($LASTEXITCODE -ne 0) { throw "Build failed" }

$logPath = Join-Path (Split-Path $exe) "startup-error.log"
$logBefore = if (Test-Path $logPath) { Get-Content $logPath -Raw } else { "" }

$cases = @(
    @(),
    @("--dark"),
    @("--dashboard"),
    @("--dashboard", "--dark"),
    @("--m4"),
    @("--inactive=instructor"),
    @("--inactive=student-basic"),
    @("--inactive=student-procom"),
    @("--inactive=onair")
)

$failures = @()

foreach ($cliArgs in $cases) {
    $label = if ($cliArgs.Count -eq 0) { "(default light active)" } else { ($cliArgs -join " ") }
    Write-Host "Testing: $label"

    if ($cliArgs.Count -eq 0) {
        $p = Start-Process -FilePath $exe -PassThru
    } else {
        $p = Start-Process -FilePath $exe -ArgumentList $cliArgs -PassThru
    }
    Start-Sleep -Seconds 2

    if ($p.HasExited) {
        $failures += "$label - process exited early (code $($p.ExitCode))"
    } else {
        Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
    }
}

$logAfter = if (Test-Path $logPath) { Get-Content $logPath -Raw } else { "" }
if ($logAfter.Length -gt $logBefore.Length) {
    $failures += "startup-error.log grew during smoke tests - check $logPath"
}

if ($failures.Count -gt 0) {
    Write-Host "`nSMOKE TEST FAILED:" -ForegroundColor Red
    $failures | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

Write-Host "`nAll smoke tests passed." -ForegroundColor Green
