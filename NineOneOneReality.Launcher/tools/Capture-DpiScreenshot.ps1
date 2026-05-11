<#
.SYNOPSIS
    Captures a full-window PNG of the running 9-1-1 Reality launcher, named
    after the current Windows display scale (dpi-100.png, dpi-125.png,
    dpi-150.png, ...).

.DESCRIPTION
    Run AFTER setting the desired Windows display scale and signing back in.
    The launcher must already be running.

    Uses the Win32 PrintWindow API (PW_RENDERFULLCONTENT flag) so the entire
    window is captured at its real size even if part of it extends below the
    taskbar / off the visible monitor. This avoids the "bottom of the hero
    panel is cut off" problem you'd get with a screen-region capture at 125%
    or 150% scaling on a 1080p monitor.

.PARAMETER WindowTitle
    Substring to match against MainWindowTitle. Default catches the launcher.

.PARAMETER OutputDir
    Where to write the PNG. Default is .\screenshots relative to this script.

.PARAMETER WaitMs
    How long to wait after foregrounding the window before capturing.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\tools\Capture-DpiScreenshot.ps1
#>

[CmdletBinding()]
param(
    [string]$WindowTitle = "9-1-1 Reality Simulator",
    [string]$OutputDir   = (Join-Path $PSScriptRoot "..\screenshots"),
    [int]$WaitMs         = 1200
)

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$signature = @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")]
    public static extern uint GetDpiForWindow(IntPtr hwnd);
    [DllImport("user32.dll")]
    public static extern bool PrintWindow(IntPtr hWnd, IntPtr hdcBlt, uint nFlags);
    [StructLayout(LayoutKind.Sequential)]
    public struct RECT { public int Left, Top, Right, Bottom; }
}
"@
if (-not ([System.Management.Automation.PSTypeName]'Win32').Type) {
    Add-Type -TypeDefinition $signature
}

# 1. Find the launcher window
$proc = Get-Process |
        Where-Object { $_.MainWindowTitle -like "*$WindowTitle*" } |
        Select-Object -First 1

if (-not $proc) {
    Write-Error "No window with title containing '$WindowTitle' is running. Launch the application first."
    exit 1
}
$hwnd = $proc.MainWindowHandle

# 2. Foreground + paint settle
[Win32]::ShowWindowAsync($hwnd, 9) | Out-Null   # SW_RESTORE
[Win32]::SetForegroundWindow($hwnd) | Out-Null
Start-Sleep -Milliseconds $WaitMs

# 3. DPI for this window (PerMonitorV2 honoured)
$dpi   = [Win32]::GetDpiForWindow($hwnd)
$scale = [int][Math]::Round(($dpi / 96.0) * 100)

# 4. Window rectangle in physical pixels
$rect = New-Object Win32+RECT
[Win32]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
$width  = $rect.Right  - $rect.Left
$height = $rect.Bottom - $rect.Top
if ($width -le 0 -or $height -le 0) {
    Write-Error "Window has zero size - is it minimized?"
    exit 1
}

# 5. Capture via PrintWindow with PW_RENDERFULLCONTENT (0x00000002).
#    This renders the window into our bitmap at its full size regardless of
#    monitor visibility, which is exactly what we need for DPI captures of
#    a 1920x1080 logical window scaled to 2880x1620 device pixels at 150%.
$bmp      = New-Object System.Drawing.Bitmap $width, $height
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$hdc      = $graphics.GetHdc()
try {
    $ok = [Win32]::PrintWindow($hwnd, $hdc, 0x00000002)
    if (-not $ok) {
        Write-Warning "PrintWindow returned false - falling back to screen copy."
        $graphics.ReleaseHdc($hdc)
        $hdc = [IntPtr]::Zero
        $graphics.CopyFromScreen($rect.Left, $rect.Top, 0, 0, $bmp.Size)
    }
}
finally {
    if ($hdc -ne [IntPtr]::Zero) { $graphics.ReleaseHdc($hdc) }
}

# 6. Save
$resolvedDir = Resolve-Path -LiteralPath $OutputDir -ErrorAction SilentlyContinue
if (-not $resolvedDir) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    $resolvedDir = (Resolve-Path -LiteralPath $OutputDir).Path
}
$out = Join-Path $resolvedDir ("dpi-{0}.png" -f $scale)
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose()
$bmp.Dispose()

Write-Host ("Saved {0}  ({1} x {2} px @ {3} DPI / {4}%)" -f $out, $width, $height, $dpi, $scale)
