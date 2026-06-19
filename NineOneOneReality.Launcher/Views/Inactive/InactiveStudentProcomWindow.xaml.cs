using System.Windows;



namespace NineOneOneReality.Launcher.Views.Inactive;



public partial class InactiveStudentProcomWindow : Window

{

    public InactiveStudentProcomWindow(bool forceLightTheme = false)

    {

        InitializeComponent();



        if (forceLightTheme)

            InactiveWindowTheme.ApplyLight(this, Art, InactiveArt.MappingLight);

    }

}

