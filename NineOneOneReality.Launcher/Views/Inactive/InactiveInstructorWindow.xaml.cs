using System.Windows;



namespace NineOneOneReality.Launcher.Views.Inactive;



public partial class InactiveInstructorWindow : Window

{

    public InactiveInstructorWindow(bool forceLightTheme = false)

    {

        InitializeComponent();



        if (forceLightTheme)

            InactiveWindowTheme.ApplyLight(this, Art, InactiveArt.ViewStudentLight);

    }

}

