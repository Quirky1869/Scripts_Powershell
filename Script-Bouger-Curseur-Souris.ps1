Add-Type -AssemblyName System.Windows.Forms

while ($true)
{
  $Pos = [System.Windows.Forms.Cursor]::Position
  $x = ($pos.X % 500) + 5
  $y = ($pos.Y % 500) + 5
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  Start-Sleep -Seconds 5
}