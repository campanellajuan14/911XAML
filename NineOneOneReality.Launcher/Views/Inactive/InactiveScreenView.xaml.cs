using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace NineOneOneReality.Launcher.Views.Inactive;

public partial class InactiveScreenView : UserControl
{
    public static readonly DependencyProperty ArtFileNameProperty = DependencyProperty.Register(
        nameof(ArtFileName),
        typeof(string),
        typeof(InactiveScreenView),
        new PropertyMetadata(string.Empty, OnArtFileNameChanged));

    public static readonly DependencyProperty ArtBitmapScalingModeProperty = DependencyProperty.Register(
        nameof(ArtBitmapScalingMode),
        typeof(BitmapScalingMode),
        typeof(InactiveScreenView),
        new PropertyMetadata(BitmapScalingMode.NearestNeighbor, OnArtBitmapScalingModeChanged));

    public InactiveScreenView()
    {
        InitializeComponent();
        ApplyArtBitmapScalingMode();
        Loaded += (_, _) => FitHostWindow();
    }

    public string ArtFileName
    {
        get => (string)GetValue(ArtFileNameProperty);
        set => SetValue(ArtFileNameProperty, value);
    }

    public BitmapScalingMode ArtBitmapScalingMode
    {
        get => (BitmapScalingMode)GetValue(ArtBitmapScalingModeProperty);
        set => SetValue(ArtBitmapScalingModeProperty, value);
    }

    private static void OnArtBitmapScalingModeChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
    {
        if (d is InactiveScreenView view)
            view.ApplyArtBitmapScalingMode();
    }

    private void ApplyArtBitmapScalingMode()
    {
        var mode = ArtBitmapScalingMode;
        RenderOptions.SetBitmapScalingMode(ArtImage, mode);
        RenderOptions.SetEdgeMode(ArtImage, mode == BitmapScalingMode.HighQuality ? EdgeMode.Unspecified : EdgeMode.Aliased);
    }

    private static void OnArtFileNameChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
    {
        if (d is not InactiveScreenView view)
            return;

        var name = (string?)e.NewValue;
        if (string.IsNullOrWhiteSpace(name))
        {
            view.ArtImage.Source = null;
            return;
        }

        var uri = new Uri($"pack://application:,,,/Resources/Images/{name.TrimStart('/')}", UriKind.Absolute);
        var bmp = new BitmapImage();
        bmp.BeginInit();
        bmp.UriSource = uri;
        bmp.CacheOption = BitmapCacheOption.OnLoad;
        bmp.CreateOptions = BitmapCreateOptions.IgnoreImageCache;
        bmp.EndInit();
        bmp.Freeze();

        view.ArtImage.Source = bmp;
        view.ApplyWorkAreaCap();
        view.FitHostWindow();
    }

    private void ApplyWorkAreaCap()
    {
        var work = SystemParameters.WorkArea;
        ArtHost.MaxWidth = work.Width;
        ArtHost.MaxHeight = work.Height;
    }

    private void FitHostWindow()
    {
        var window = Window.GetWindow(this);
        if (window is null)
            return;

        window.SizeToContent = SizeToContent.WidthAndHeight;
        window.WindowState = WindowState.Normal;
        window.ResizeMode = ResizeMode.NoResize;
        window.Background = Brushes.Black;
        window.UpdateLayout();
    }
}
