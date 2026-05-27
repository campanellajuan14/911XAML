# Builds a double-click-ready Launcher-Run folder (Release publish + starter .bat files).

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$project = Join-Path $root "NineOneOneReality.Launcher\NineOneOneReality.Launcher.csproj"
$runDir = Join-Path $root "Launcher-Run"

Write-Host "Publishing Release to Launcher-Run..."
if (Test-Path $runDir) { Remove-Item $runDir -Recurse -Force }

dotnet publish $project -c Release -r win-x64 --self-contained false -o $runDir --nologo
if ($LASTEXITCODE -ne 0) { throw "dotnet publish failed" }

$bat = @(
    @{ Name = "START - Active Light.bat"; Args = "" }
    @{ Name = "START - Active Dark.bat"; Args = "--dark" }
    @{ Name = "START - Dashboard Light.bat"; Args = "--dashboard" }
    @{ Name = "START - Dashboard Dark.bat"; Args = "--dashboard --dark" }
    @{ Name = "START - Inactive Picker (M4).bat"; Args = "--m4" }
    @{ Name = "START - Inactive Instructor.bat"; Args = "--inactive=instructor" }
    @{ Name = "START - Inactive CALL CARDS.bat"; Args = "--inactive=student-basic" }
    @{ Name = "START - Inactive MAPPING.bat"; Args = "--inactive=student-procom" }
    @{ Name = "START - Inactive ON AIR.bat"; Args = "--inactive=onair" }
)

foreach ($item in $bat) {
    $path = Join-Path $runDir $item.Name
    @"
@echo off
cd /d "%~dp0"
start "" "%~dp0NineOneOneReality.Launcher.exe" $($item.Args)
"@ | Set-Content -Path $path -Encoding ASCII
}

@"
911 Reality Simulator - Launcher (Milestone 5)
============================================

DOUBLE-CLICK ONE OF THE "START - ..." FILES IN THIS FOLDER.

For plain-English instructions, open:
  ..\docs\QUICK-START.md

Requires .NET 8 Desktop Runtime:
  https://dotnet.microsoft.com/download/dotnet/8.0
"@ | Set-Content -Path (Join-Path $runDir "READ ME FIRST.txt") -Encoding UTF8

Write-Host "Created: $runDir"
