using System.Windows;

namespace NineOneOneReality.Launcher.Views.Inactive;

public partial class M4PickerWindow : Window
{
    public M4PickerWindow()
    {
        InitializeComponent();
    }

    private void OnOpenInstructor(object sender, RoutedEventArgs e)
    {
        new InactiveInstructorWindow().Show();
        Close();
    }

    private void OnOpenStudentBasic(object sender, RoutedEventArgs e)
    {
        new InactiveStudentBasicWindow().Show();
        Close();
    }

    private void OnOpenStudentProcom(object sender, RoutedEventArgs e)
    {
        new InactiveStudentProcomWindow().Show();
        Close();
    }
}
