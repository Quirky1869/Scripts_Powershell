cls
Add-Type -AssemblyName PresentationFramework

[xml]$XML = @"
        <Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" 
        x:Name="Window" Title="Test Connection Window" Height="121.071" Width="460" ResizeMode="NoResize">

    <Grid x:Name="LayoutRoot" Background="#FFC1C3CB">
        <Button x:Name="Close" Content="Close" HorizontalAlignment="Left" Margin="327,10,0,0" VerticalAlignment="Top" Width="100" Height="54" />
        <Label Name="Label_Email" Content="Your email:" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="130"/>
        <TextBox Name="TextBox_Email" HorizontalAlignment="Left" Height="23" Margin="145,10,0,0" TextWrapping="Wrap" Text="youremail@domain.fr" VerticalAlignment="Top" Width="160"/>
        <Label Name="Label_Password" Content="Your Password" HorizontalAlignment="Left" Margin="10,41,0,0" VerticalAlignment="Top" Width="130"/>
        <PasswordBox Name="TextBox_Password" HorizontalAlignment="Left" Margin="145,41,0,0" VerticalAlignment="Top" Width="160" Height="23"/>
    </Grid>
</Window>
"@

$FormXML = (New-Object System.Xml.XmlNodeReader $XML)
$Window = [Windows.Markup.XamlReader]::Load($FormXML)

$Window.FindName("Close").add_click({ 
    $Window.Close() 
}) 

$Window.ShowDialog() | Out-Null


