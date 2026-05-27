using System;
using System.IO;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace NineOneOneReality.Launcher;

internal static class ScreenshotCapture
{
    public static void SaveWindow(Window window, string filePath, int dpiPercent = 100)
    {
        if (dpiPercent is not (100 or 125 or 150))
            throw new ArgumentOutOfRangeException(nameof(dpiPercent), "Use 100, 125, or 150.");

        var scale = dpiPercent / 100.0;
        var dpi = 96.0 * scale;

        window.WindowState = WindowState.Normal;
        window.ShowInTaskbar = false;
        window.Show();
        window.UpdateLayout();

        var width = (int)Math.Ceiling(window.ActualWidth * scale);
        var height = (int)Math.Ceiling(window.ActualHeight * scale);
        if (width < 1 || height < 1)
            throw new InvalidOperationException($"Window '{window.Title}' has no measurable size ({window.ActualWidth}x{window.ActualHeight}).");

        var bitmap = new RenderTargetBitmap(width, height, dpi, dpi, PixelFormats.Pbgra32);
        bitmap.Render(window);

        var encoder = new PngBitmapEncoder();
        encoder.Frames.Add(BitmapFrame.Create(bitmap));

        var directory = Path.GetDirectoryName(filePath);
        if (!string.IsNullOrEmpty(directory))
            Directory.CreateDirectory(directory);

        using var stream = File.Create(filePath);
        encoder.Save(stream);
    }
}
