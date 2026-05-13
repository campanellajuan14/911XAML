using System.Windows;

namespace NineOneOneReality.Launcher.Views;

public partial class ActiveLightWindow : Window
{
    private DashboardWindow? _dashboardWindow;

    public ActiveLightWindow()
    {
        InitializeComponent();
    }

    private void OnDashboardNavChecked(object sender, RoutedEventArgs e)
    {
        if (_dashboardWindow != null)
        {
            _dashboardWindow.Activate();
            return;
        }

        _dashboardWindow = new DashboardWindow { Owner = this };
        _dashboardWindow.Closed += (_, _) => _dashboardWindow = null;
        _dashboardWindow.Show();
    }

    private void OnDashboardNavUnchecked(object sender, RoutedEventArgs e)
    {
        _dashboardWindow?.Close();
    }
}
