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
    //   --m4                → M4 picker (three inactive placeholders)
    //   --inactive=<name>   → one inactive window directly:
    //                           instructor | student-basic | student-procom
    //                         (aliases: basic, procom)
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
        var m4Picker = false;
        string? inactive = null;

        if (e.Args != null)
        {
            foreach (var a in e.Args)
            {
                if (string.Equals(a, "--dark", StringComparison.Ordinal))
                    dark = true;
                else if (string.Equals(a, "--m4", StringComparison.Ordinal))
                    m4Picker = true;
                else if (a.StartsWith("--inactive=", StringComparison.Ordinal))
                    inactive = a.Substring("--inactive=".Length).Trim();
            }
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
