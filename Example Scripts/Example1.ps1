cls
Add-Type -AssemblyName PresentationFramework

[xml]$XML = @"
            <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
            Title="WPF Windows" Height="480" Width="640">
            </Window>
"@

$FormXML = (New-Object System.Xml.XmlNodeReader $XML)
$Window = [Windows.Markup.XamlReader]::Load($FormXML)

$Window.ShowDialog()
