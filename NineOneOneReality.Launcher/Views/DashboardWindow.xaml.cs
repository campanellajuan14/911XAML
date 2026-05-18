using System;
using System.Windows;
using System.Windows.Controls;

namespace NineOneOneReality.Launcher.Views;

public partial class DashboardWindow : Window
{
    public DashboardWindow(Window owner)
    {
        ArgumentNullException.ThrowIfNull(owner);
        Owner = owner;

        // Merge theme after InitializeComponent: LoadComponent can replace/reorder
        // window merged dictionaries. Brush.Dashboard.* in template triggers use DynamicResource
        // so resolution walks merged dictionaries (StaticResource often yields Unset from triggers).
        InitializeComponent();

        Resources.MergedDictionaries.Insert(
            0,
            new ResourceDictionary
            {
                Source = new Uri(
                    owner is ActiveDarkWindow
                        ? "pack://application:,,,/Themes/Theme.Dark.xaml"
                        : "pack://application:,,,/Themes/Theme.Light.xaml",
                    UriKind.Absolute),
            });

        // Default-checked folder-scope chip: IsChecked must be set after the theme dictionary is merged.
        // Otherwise ControlTemplate.Triggers that use StaticResource(Brush.Dashboard.*) run during
        // InitializeComponent before those brushes exist → BorderBrush = UnsetValue and layout crashes.
        FolderScopeInstructorChip.IsChecked = true;
    }

    private void ModelInputTextBox_Loaded(object sender, RoutedEventArgs e)
    {
        ModelInputTextBox.Text = string.Empty;
        SyncModelPlaceholderVisibility();
    }

    private void ModelInputTextBox_TextChanged(object sender, TextChangedEventArgs e) =>
        SyncModelPlaceholderVisibility();

    private void SyncModelPlaceholderVisibility()
    {
        ModelInputPlaceholder.Visibility = string.IsNullOrWhiteSpace(ModelInputTextBox.Text)
            ? Visibility.Visible
            : Visibility.Collapsed;
    }
}
