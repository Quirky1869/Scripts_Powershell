[void] [System.Reflection.Assembly]::LoadWithPartialName("'System.Windows.Forms")

function Down{

    Start-Sleep -Seconds 2

    
    [System.Windows.Forms.SendKeys]::SendWait("{Down}")

}
while($true)
{
    $i=0
    for($i=0;$i -lt 5;$i++)
    {

        down

    }

    [System.Windows.Forms.SendKeys]::SendWait("{F5}")

}