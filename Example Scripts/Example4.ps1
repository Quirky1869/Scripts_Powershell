Add-Type -AssemblyName PresentationFramework

[xml]$Form = Get-Content .\App.xaml

$FormXML = (New-Object System.Xml.XmlNodeReader $XML)
$Window = [Windows.Markup.XamlReader]::Load($FormXML)
$Window.ShowDialog()