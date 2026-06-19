using System.Windows;



namespace NineOneOneReality.Launcher.Views.Inactive;



public partial class InactiveStudentBasicWindow : Window

{

    public InactiveStudentBasicWindow(bool forceLightTheme = false)

    {

        InitializeComponent();



        if (forceLightTheme)

            InactiveWindowTheme.ApplyLight(this, Art, InactiveArt.CallCardsLight);

    }

}

