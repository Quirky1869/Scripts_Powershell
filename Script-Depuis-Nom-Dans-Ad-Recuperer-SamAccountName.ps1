$fichier = 'Mjacotet','JLArmonico','TArasse' #Get-Content -Path 'C:\Users\048710\Desktop\Liste-nom.txt'

foreach($elements in $fichier)
{

    $asuppr = $elements.Substring(0 , +2)

    $justeLeNom = $elements -replace($asuppr,"")

    #$location

    foreach($elements2 in $justeLeNom)
    {

        $samaccount = (Get-ADUser -Filter * | ? name -Match $elements2).samaccountname

        $samaccount

    }

}