using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Threading;

namespace NineOneOneReality.Launcher;

public partial class App : Application
{
    // Prototype scope: open the single dark active screen.
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

        new Views.ActiveDarkWindow().Show();
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
