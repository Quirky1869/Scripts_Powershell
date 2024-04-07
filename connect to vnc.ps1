Write-Host "Entrée un nom de pc :" -NoNewline -ForegroundColor Green -BackgroundColor Black
$richTextBox1 = Read-Host
cd 'C:\Program Files\uvnc bvba\UltraVNC\'
.\vncviewer.exe $richTextBox1 /password 'Guinness'