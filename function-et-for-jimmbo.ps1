function affichage 
{

        for ( $i = 0 ; $i -lt $tableau.Length ; $i ++ )
    {

        # affiche la valeur i du tableau
        Write-Host $tableau[$i] -ForegroundColor Red

    }

}

function choixValeur

{

  $valeur = Read-Host 'entrez valeur'

  Write-Host $tableau[$valeur-1] -ForegroundColor Green

}

# best function ever for this bastard
function enculerDeJimmbo

{

  $changeValue1 = Read-Host 'entrez valeur une'
  $changevalue2 = Read-Host 'entrez valeur deux'

  $tableau[$changevalue1-1] = $changevalue2 


}



$tableau = @(1,2,3,4,5,6)

affichage
enculerDeJimmbo
#choixValeur
affichage