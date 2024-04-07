#======================================================== Script pour effectuer la création d'une base ODBC pour Chimed=======================================================#
# Chemin des logs
$destinationLog = (Get-ChildItem Env:\USERPROFILE).value + "\ODBC.log"

Start-Transcript -Path $destinationLog -Append

try {


    reg import '\\sccm2012\SCCM_Repository$\Software\Chimed\odbc.reg'
    reg import '\\sccm2012\SCCM_Repository$\Software\Chimed\dataodbc.reg'


}


catch {


       break


}

Stop-Transcript 