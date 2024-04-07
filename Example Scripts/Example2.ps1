Add-Type -AssemblyName PresentationFramework

[xml]$XML = @"
    <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="WPF Window" Height="480" Width="640">
    <Button Name="MyButton" Width="80" Height="40" Content="OK" />
    </Window>
"@

$FormXML = (New-Object System.Xml.XmlNodeReader $XML)
$Window = [Windows.Markup.XamlReader]::Load($FormXML)
$Window.ShowDialog()