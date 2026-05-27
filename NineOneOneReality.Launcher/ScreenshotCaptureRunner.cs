using System;
using System.Collections.Generic;
using System.IO;
using System.Windows;
using NineOneOneReality.Launcher.Views;
using NineOneOneReality.Launcher.Views.Inactive;

namespace NineOneOneReality.Launcher;

internal sealed class ScreenshotCaptureRunner
{
    private readonly string _outputRoot;
    private readonly int _dpiPercent;
    private readonly List<(string RelativePath, Func<Window> Factory)> _targets = new();

    public ScreenshotCaptureRunner(string outputRoot, int dpiPercent)
    {
        if (dpiPercent is not (100 or 125 or 150))
            throw new ArgumentOutOfRangeException(nameof(dpiPercent), "Use 100, 125, or 150.");

        _outputRoot = outputRoot;
        _dpiPercent = dpiPercent;

        Add($"active-light-{_dpiPercent}.png", CreateActiveLight);
        Add($"active-dark-{_dpiPercent}.png", CreateActiveDark);
        Add($"dashboard/folder-view-light-{_dpiPercent}.png", () => CreateDashboard(forceDarkTheme: false));
        Add($"dashboard/folder-view-dark-{_dpiPercent}.png", () => CreateDashboard(forceDarkTheme: true));
        Add($"inactive-view-student/instructor-inactive-{_dpiPercent}.png", () => new InactiveInstructorWindow());
        Add($"call-cards/basic-student-inactive-{_dpiPercent}.png", () => new InactiveStudentBasicWindow());
        Add($"mapping/procom-student-inactive-{_dpiPercent}.png", () => new InactiveStudentProcomWindow());
        Add($"on-air/on-air-inactive-{_dpiPercent}.png", () => new InactiveOnAirWindow());
    }

    public void Run()
    {
        Directory.CreateDirectory(_outputRoot);

        foreach (var (relativePath, factory) in _targets)
        {
            Window? window = null;
            try
            {
                window = factory();
                var path = Path.Combine(_outputRoot, relativePath);
                ScreenshotCapture.SaveWindow(window, path, _dpiPercent);
            }
            finally
            {
                window?.Close();
            }
        }
    }

    private void Add(string relativePath, Func<Window> factory) =>
        _targets.Add((relativePath, factory));

    private static ActiveLightWindow CreateActiveLight()
    {
        var window = new ActiveLightWindow
        {
            WindowState = WindowState.Normal,
            Width = 1920,
            Height = 1080,
        };
        return window;
    }

    private static ActiveDarkWindow CreateActiveDark()
    {
        var window = new ActiveDarkWindow
        {
            WindowState = WindowState.Normal,
            Width = 1920,
            Height = 1080,
        };
        return window;
    }

    private static DashboardWindow CreateDashboard(bool forceDarkTheme)
    {
        var window = new DashboardWindow(forceDarkTheme: forceDarkTheme)
        {
            WindowState = WindowState.Normal,
            Width = 1920,
            Height = 1080,
        };
        return window;
    }
}
