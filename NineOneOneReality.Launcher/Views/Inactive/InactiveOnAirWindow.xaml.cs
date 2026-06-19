using System.Windows;

namespace NineOneOneReality.Launcher.Views.Inactive;

public partial class InactiveOnAirWindow : Window
{
    public InactiveOnAirWindow(bool forceLightTheme = false)
    {
        InitializeComponent();

        if (forceLightTheme)
            InactiveWindowTheme.ApplyLight(this, Art, InactiveArt.OnAirLight);
    }
}
