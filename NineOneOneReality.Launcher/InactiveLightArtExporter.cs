using System;
using System.Collections.Generic;
using System.IO;
using System.Windows;
using NineOneOneReality.Launcher.Views.Inactive;

namespace NineOneOneReality.Launcher;

/// <summary>
/// Bakes programmatic white inactive layouts into full-bleed PNGs so light
/// inactive monitors use the same swap-and-rebuild workflow as dark.
/// </summary>
internal sealed class InactiveLightArtExporter
{
    private const int DesignWidth = 1366;
    private const int DesignHeight = 768;

    private readonly string _outputDirectory;

    public InactiveLightArtExporter(string outputDirectory) =>
        _outputDirectory = outputDirectory;

    public void Run()
    {
        Directory.CreateDirectory(_outputDirectory);

        // MAPPING uses client-supplied inactive-mapping-light-source.png — do not overwrite.
        var targets = new (string Headline, string FileName)[]
        {
            ("VIEW STUDENT", InactiveArt.ViewStudentLight),
            ("CALL CARDS", InactiveArt.CallCardsLight),
            ("ON AIR", InactiveArt.OnAirLight),
        };

        foreach (var (headline, fileName) in targets)
        {
            var window = CreateExportWindow(headline);
            try
            {
                var path = Path.Combine(_outputDirectory, fileName);
                ScreenshotCapture.SaveWindow(window, path, dpiPercent: 100);
            }
            finally
            {
                window.Close();
            }
        }
    }

    private static Window CreateExportWindow(string headline)
    {
        var view = new InactiveScreenLightView
        {
            Headline = headline,
            SkipHostWindowFit = true,
            Width = DesignWidth,
            Height = DesignHeight,
        };

        view.ArtHost.MaxWidth = DesignWidth;
        view.ArtHost.MaxHeight = DesignHeight;

        var window = new Window
        {
            Title = $"Export inactive light — {headline}",
            Content = view,
            Width = DesignWidth,
            Height = DesignHeight,
            SizeToContent = SizeToContent.Manual,
            WindowStartupLocation = WindowStartupLocation.Manual,
            Left = -10000,
            Top = -10000,
            ShowInTaskbar = false,
            Background = System.Windows.Media.Brushes.White,
            ResizeMode = ResizeMode.NoResize,
            SnapsToDevicePixels = true,
            UseLayoutRounding = true,
        };

        window.Show();
        window.UpdateLayout();
        return window;
    }
}
