# Verifies the delivery ZIP does not contain .git or .vs folders.

$ErrorActionPreference = "Stop"
$zipPath = Join-Path (Split-Path -Parent $PSScriptRoot) "911XAML-delivery.zip"

if (-not (Test-Path $zipPath)) { throw "Missing: $zipPath" }

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [IO.Compression.ZipFile]::OpenRead($zipPath)
try {
    $git = @($zip.Entries | Where-Object { $_.FullName -match '(^|/)\\.git(/|$)' })
    $vs = @($zip.Entries | Where-Object { $_.FullName -match '(^|/)\\.vs(/|$)' })
    Write-Host "ZIP: $zipPath"
    Write-Host "Total entries: $($zip.Entries.Count)"
    Write-Host ".git entries: $($git.Count)"
    Write-Host ".vs entries: $($vs.Count)"
    if ($git.Count -gt 0 -or $vs.Count -gt 0) {
        $git | Select-Object -First 3 | ForEach-Object { Write-Host "  git: $($_.FullName)" }
        $vs | Select-Object -First 3 | ForEach-Object { Write-Host "  vs: $($_.FullName)" }
        throw "ZIP contains excluded folders"
    }
    Write-Host "OK: no .git or .vs in delivery ZIP" -ForegroundColor Green
}
finally {
    $zip.Dispose()
}
