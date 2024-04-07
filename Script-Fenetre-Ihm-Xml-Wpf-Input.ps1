cls
Add-Type -AssemblyName PresentationFramework

[xml]$XML = @"
        <Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" 
        x:Name="Window" Title="Box Input" Height="121.071" Width="460" ResizeMode="NoResize">

    <Grid x:Name="LayoutRoot" Background="#FFC1C3CB">
    <Button x:Name="Valider" Content="Valider" HorizontalAlignment="Center" Margin="327,10,0,0" VerticalAlignment="bottom" Width="50" Height="25" />
        <Label Name="Label_champ" Content="Entrez le chemin voulu :" HorizontalAlignment="center" Margin="10,10,0,0" VerticalAlignment="top" Width="145"/>
        <TextBox Name="TextBox_Email" HorizontalAlignment="center" Height="23" Margin="0,0,0,0" TextWrapping="Wrap" Text="youremail@domain.fr" VerticalAlignment="center" Width="420"/>
       <!-- <Label Name="Label_Password" Content="Your Password" HorizontalAlignment="Left" Margin="10,41,0,0" VerticalAlignment="Top" Width="130"/> -->
       <!-- <PasswordBox Name="TextBox_Password" HorizontalAlignment="Left" Margin="145,41,0,0" VerticalAlignment="Top" Width="160" Height="23"/> -->
    </Grid>
</Window>
"@

$FormXML = (New-Object System.Xml.XmlNodeReader $XML)
$Window = [Windows.Markup.XamlReader]::Load($FormXML)

<#$Window.FindName("Close").add_click({ 
    $Window.Close() 
}) #>

$Window.ShowDialog() | Out-Null