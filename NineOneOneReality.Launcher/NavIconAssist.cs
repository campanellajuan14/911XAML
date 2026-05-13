using System.Globalization;
using System.Windows;
using System.Windows.Data;
using System.Windows.Media;

namespace NineOneOneReality.Launcher;

/// <summary>
/// Picks <see cref="Visibility" /> for the vector Path vs bitmap Image slots in <c>NavButtonStyle</c>.
/// ConverterParameter: <c>Bitmap</c> (visible when <see cref="NavIconAssist.BitmapIcon" /> is set) or <c>Vector</c> (visible when unset).
/// </summary>
public sealed class NavIconSlotVisibilityConverter : IValueConverter
{
    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        var hasBitmap = value is string s && !string.IsNullOrWhiteSpace(s);
        var wantBitmap = string.Equals(parameter as string, "Bitmap", StringComparison.OrdinalIgnoreCase);
        var visible = wantBitmap ? hasBitmap : !hasBitmap;
        return visible ? Visibility.Visible : Visibility.Collapsed;
    }

    public object ConvertBack(object value, Type targetType, object? parameter, CultureInfo culture) =>
        throw new NotSupportedException();
}

/// <summary>
/// Optional per-row idle fill for sidebar <see cref="System.Windows.Controls.RadioButton" /> icons
/// (Training Resources + System accents). When unset, <c>NavButtonStyle</c> uses <c>Brush.Theme.IconNeutral</c>.
/// </summary>
public static class NavIconAssist
{
    /// <summary>Optional pack URI for a PNG sidebar icon (e.g. <c>/Resources/Images/nav-sidebar-dashboard.png</c>).</summary>
    public static readonly DependencyProperty BitmapIconProperty = DependencyProperty.RegisterAttached(
        "BitmapIcon",
        typeof(string),
        typeof(NavIconAssist),
        new FrameworkPropertyMetadata(null));

    public static void SetBitmapIcon(DependencyObject element, string? value) => element.SetValue(BitmapIconProperty, value);

    public static string? GetBitmapIcon(DependencyObject element) => (string?)element.GetValue(BitmapIconProperty);

    public static readonly DependencyProperty IdleFillProperty = DependencyProperty.RegisterAttached(
        "IdleFill",
        typeof(Brush),
        typeof(NavIconAssist),
        new FrameworkPropertyMetadata(null));

    public static void SetIdleFill(DependencyObject element, Brush? value) => element.SetValue(IdleFillProperty, value);

    public static Brush? GetIdleFill(DependencyObject element) => (Brush?)element.GetValue(IdleFillProperty);
}

/// <summary>
/// Resolves idle icon fill: attached <see cref="NavIconAssist.IdleFill" /> when set, otherwise
/// <c>Brush.Theme.IconNeutral</c> from the templated parent (window theme). Used so we never put
/// <c>DynamicResource</c> on a <see cref="Binding.FallbackValue" /> (runtime XamlParseException).
/// </summary>
public sealed class NavIconIdleFillConverter : IMultiValueConverter
{
    public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
    {
        if (values is { Length: >= 1 } && values[0] is Brush idle)
            return idle;

        if (values is { Length: >= 2 } && values[1] is FrameworkElement fe)
        {
            if (fe.TryFindResource("Brush.Theme.IconNeutral") is Brush neutral)
                return neutral;
        }

        return SystemColors.ControlDarkBrush;
    }

    public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture) =>
        throw new NotSupportedException();
}
