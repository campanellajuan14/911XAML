using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace NineOneOneReality.Launcher.Views.Inactive;

public partial class InactiveScreenLightView : UserControl
{
    public static readonly DependencyProperty HeadlineProperty = DependencyProperty.Register(
        nameof(Headline),
        typeof(string),
        typeof(InactiveScreenLightView),
        new PropertyMetadata(string.Empty, OnHeadlineChanged));

    public InactiveScreenLightView()
    {
        InitializeComponent();
        Loaded += (_, _) => FitHostWindow();
    }

    public string Headline
    {
        get => (string)GetValue(HeadlineProperty);
        set => SetValue(HeadlineProperty, value);
    }

    /// <summary>When true, skip resizing the host window (used by PNG export).</summary>
    public bool SkipHostWindowFit { get; set; }

    private static void OnHeadlineChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
    {
        if (d is InactiveScreenLightView view)
            view.HeadlineText.Text = (string?)e.NewValue ?? string.Empty;
    }

    private void ApplyWorkAreaCap()
    {
        var work = SystemParameters.WorkArea;
        ArtHost.MaxWidth = work.Width;
        ArtHost.MaxHeight = work.Height;
    }

    private void FitHostWindow()
    {
        if (SkipHostWindowFit || Visibility != Visibility.Visible)
            return;

        ApplyWorkAreaCap();

        var window = Window.GetWindow(this);
        if (window is null)
            return;

        window.SizeToContent = SizeToContent.WidthAndHeight;
        window.WindowState = WindowState.Normal;
        window.ResizeMode = ResizeMode.NoResize;
        window.Background = Brushes.White;
        window.UpdateLayout();
    }
}
