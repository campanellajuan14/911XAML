using System;
using System.Windows;
using System.Windows.Media;

namespace NineOneOneReality.Launcher.Views.Inactive;

internal static class InactiveWindowTheme
{
    public static void ApplyLight(Window window, InactiveScreenView art, string lightArtFileName)
    {
        window.Resources.MergedDictionaries.Insert(
            0,
            new ResourceDictionary
            {
                Source = new Uri("pack://application:,,,/Themes/Theme.Light.xaml", UriKind.Absolute),
            });

        art.UseLightChrome = true;
        art.ArtFileName = lightArtFileName;
        window.Background = Brushes.White;
    }
}
