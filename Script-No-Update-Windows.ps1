#========================================================Empecher les mises a jour de se télécharger et de s'installer=======================================================#
# Chemin des logs
$destinationLog = (Get-ChildItem Env:\USERPROFILE).value + "\NoWindowsUpdate.log"

Start-Transcript -Path $destinationLog -Append

    reg import '\\sccm2012\SCCM_Repository$\Software\Scripts\WindowsUpdate\NoUpdateWindows.reg'


Stop-Transcript 