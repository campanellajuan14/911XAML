; 9-1-1 Reality Simulator Launcher — client installer
; Build with: tools\Build-WindowsInstaller.ps1

#ifndef StagingDir
  #define StagingDir "..\_installer-staging"
#endif

#ifndef RepoRoot
  #define RepoRoot ".."
#endif

#define MyAppName "9-1-1 Reality Simulator Launcher"
#define MyAppShortName "911 Reality Launcher"
#define MyAppPublisher "911 Career Training"
#define MyAppExeName "NineOneOneReality.Launcher.exe"
#define MyAppVersion "1.0.0"

[Setup]
AppId={{A7C4E2B1-8F3D-4A91-9C6E-1B2D3E4F5A6B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\911 Reality\Launcher
DefaultGroupName={#MyAppShortName}
DisableProgramGroupPage=yes
OutputDir={#RepoRoot}
OutputBaseFilename=Windows911-Launcher-Setup
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#MyAppExeName}
SetupLogging=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut for the main instructor screen (Active Light)"; GroupDescription: "Additional shortcuts:"; Flags: checkedonce
Name: "launchapp"; Description: "Launch the main instructor screen when setup finishes"; GroupDescription: "After installation:"; Flags: checkedonce

[Files]
Source: "{#StagingDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#RepoRoot}\docs\QUICK-START.md"; DestDir: "{app}\docs"; Flags: ignoreversion
Source: "{#RepoRoot}\docs\EMERGENCY-RECOVERY.md"; DestDir: "{app}\docs"; Flags: ignoreversion
Source: "{#RepoRoot}\docs\MULTI-MONITOR.md"; DestDir: "{app}\docs"; Flags: ignoreversion

[Icons]
Name: "{group}\Active Light (main screen)"; Filename: "{app}\{#MyAppExeName}"; Comment: "Main instructor screen — normal daily use"
Name: "{group}\Active Dark"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--dark"
Name: "{group}\Dashboard Light"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--dashboard"
Name: "{group}\Dashboard Dark"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--dashboard --dark"
Name: "{group}\Inactive Picker (M4)"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--m4"
Name: "{group}\Inactive Instructor"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--inactive=instructor"
Name: "{group}\Inactive CALL CARDS"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--inactive=student-basic"
Name: "{group}\Inactive MAPPING"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--inactive=student-procom"
Name: "{group}\Inactive ON AIR"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--inactive=onair"
Name: "{group}\Quick Start Guide"; Filename: "{app}\docs\QUICK-START.md"
Name: "{group}\Emergency Recovery"; Filename: "{app}\docs\EMERGENCY-RECOVERY.md"
Name: "{autodesktop}\911 Reality Launcher"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; Comment: "Main instructor screen"
Name: "{group}\Uninstall {#MyAppShortName}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppShortName}"; Flags: nowait postinstall skipifsilent; Tasks: launchapp

[Messages]
FinishedLabel=Setup has finished installing %1 on your computer.%n%nNo extra software is required — just open "911 Reality Launcher" from the Start menu or desktop shortcut.
