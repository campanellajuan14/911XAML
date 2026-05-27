using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Threading;

namespace NineOneOneReality.Launcher;

public partial class App : Application
{
    // Default: M3 light active screen. CLI switches:
    //   --dark              → ActiveDarkWindow
    //   --dashboard         → DashboardWindow (light; pair with --dark for dark theme)
    //   --m4                → M4 picker (four inactive monitor skins)
    //   --inactive=<name>   → one inactive window directly:
    //                           instructor | student-basic | student-procom | onair
    //                         (aliases: basic, procom, on-air, air)
    //   --capture-screenshots[=<folder>]  → export M5 QA PNGs from current build, then exit
    //   --screenshot-dpi=100|125|150      → optional with --capture-screenshots (default 100)
    //
    // OutputType=WinExe means stdout/stderr are detached, so any exception
    // raised during InitializeComponent() or at runtime would otherwise
    // exit the process silently. We log every exception to a file next to
    // the exe (startup-error.log) and, in DEBUG builds only, also surface
    // it as a MessageBox so a developer can see the stack trace without
    // hunting for the log.
    protected override void OnStartup(StartupEventArgs e)
    {
        AppDomain.CurrentDomain.UnhandledException += OnDomainUnhandledException;
        DispatcherUnhandledException += OnDispatcherUnhandledException;
        TaskScheduler.UnobservedTaskException += OnUnobservedTaskException;

        base.OnStartup(e);

        var dark = false;
        var dashboard = false;
        var m4Picker = false;
        var captureScreenshots = false;
        var screenshotDpi = 100;
        string? inactive = null;
        string? captureOutputDir = null;

        if (e.Args != null)
        {
            foreach (var a in e.Args)
            {
                if (string.Equals(a, "--dark", StringComparison.Ordinal))
                    dark = true;
                else if (string.Equals(a, "--dashboard", StringComparison.Ordinal))
                    dashboard = true;
                else if (string.Equals(a, "--m4", StringComparison.Ordinal))
                    m4Picker = true;
                else if (string.Equals(a, "--capture-screenshots", StringComparison.Ordinal))
                {
                    captureScreenshots = true;
                    captureOutputDir = Path.Combine(AppContext.BaseDirectory, "Screenshots");
                }
                else if (a.StartsWith("--capture-screenshots=", StringComparison.Ordinal))
                {
                    captureScreenshots = true;
                    captureOutputDir = a.Substring("--capture-screenshots=".Length).Trim();
                }
                else if (a.StartsWith("--screenshot-dpi=", StringComparison.Ordinal)
                         && int.TryParse(a.Substring("--screenshot-dpi=".Length), out var dpi)
                         && dpi is 100 or 125 or 150)
                    screenshotDpi = dpi;
                else if (a.StartsWith("--inactive=", StringComparison.Ordinal))
                    inactive = a.Substring("--inactive=".Length).Trim();
            }
        }

        if (captureScreenshots)
        {
            ShutdownMode = ShutdownMode.OnExplicitShutdown;

            var outputDir = string.IsNullOrWhiteSpace(captureOutputDir)
                ? Path.Combine(AppContext.BaseDirectory, "Screenshots")
                : Path.GetFullPath(captureOutputDir);

            Dispatcher.Invoke(() => new ScreenshotCaptureRunner(outputDir, screenshotDpi).Run());
            Shutdown();
            return;
        }

        if (dashboard)
        {
            new Views.DashboardWindow(forceDarkTheme: dark).Show();
            return;
        }

        if (!string.IsNullOrEmpty(inactive))
        {
            switch (inactive.ToLowerInvariant())
            {
                case "instructor":
                    new Views.Inactive.InactiveInstructorWindow().Show();
                    return;
                case "student-basic":
                case "basic":
                    new Views.Inactive.InactiveStudentBasicWindow().Show();
                    return;
                case "student-procom":
                case "procom":
                    new Views.Inactive.InactiveStudentProcomWindow().Show();
                    return;
                case "onair":
                case "on-air":
                case "air":
                    new Views.Inactive.InactiveOnAirWindow().Show();
                    return;
            }
        }

        if (m4Picker)
        {
            new Views.Inactive.M4PickerWindow().Show();
            return;
        }

        if (dark)
            new Views.ActiveDarkWindow().Show();
        else
            new Views.ActiveLightWindow().Show();
    }

    private void OnDomainUnhandledException(object sender, UnhandledExceptionEventArgs e)
    {
        ReportFatal("AppDomain.UnhandledException", e.ExceptionObject as Exception);
    }

    private void OnDispatcherUnhandledException(object sender, DispatcherUnhandledExceptionEventArgs e)
    {
        ReportFatal("Dispatcher.UnhandledException", e.Exception);
        e.Handled = true;
    }

    private void OnUnobservedTaskException(object? sender, UnobservedTaskExceptionEventArgs e)
    {
        ReportFatal("TaskScheduler.UnobservedTaskException", e.Exception);
        e.SetObserved();
    }

    private static void ReportFatal(string source, Exception? ex)
    {
        var sb = new StringBuilder();
        sb.AppendLine($"[{DateTime.Now:HH:mm:ss.fff}] {source}");
        sb.AppendLine();
        sb.AppendLine(ex?.ToString() ?? "(null exception)");

        var report = sb.ToString();

        try
        {
            var logPath = Path.Combine(AppContext.BaseDirectory, "startup-error.log");
            File.AppendAllText(logPath, report + Environment.NewLine + new string('-', 80) + Environment.NewLine);
        }
        catch
        {
        }

#if DEBUG
        MessageBox.Show(report, "9-1-1 Reality Launcher - error", MessageBoxButton.OK, MessageBoxImage.Error);
#endif
    }
}
