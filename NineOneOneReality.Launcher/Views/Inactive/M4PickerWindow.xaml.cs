using System.Windows;

namespace NineOneOneReality.Launcher.Views.Inactive;

public partial class M4PickerWindow : Window
{
    public M4PickerWindow()
    {
        InitializeComponent();
    }

    private bool UseLightTheme => LightThemeCheckBox.IsChecked == true;

    private void OnOpenInstructor(object sender, RoutedEventArgs e)
    {
        new InactiveInstructorWindow(forceLightTheme: UseLightTheme).Show();
        Close();
    }

    private void OnOpenStudentBasic(object sender, RoutedEventArgs e)
    {
        new InactiveStudentBasicWindow(forceLightTheme: UseLightTheme).Show();
        Close();
    }

    private void OnOpenStudentProcom(object sender, RoutedEventArgs e)
    {
        new InactiveStudentProcomWindow(forceLightTheme: UseLightTheme).Show();
        Close();
    }

    private void OnOpenOnAir(object sender, RoutedEventArgs e)
    {
        new InactiveOnAirWindow(forceLightTheme: UseLightTheme).Show();
        Close();
    }
}
