var csvFinal = "" //on declare la variable csvFinal au format String qui contiendra tout le CSV
var listingTr = document.querySelector("table.matrix").querySelectorAll("tr") // on recupere toutes les balises TR dans la premiere table ayant pour classe matrix
//querySelector : Recherche dans le document a partir de mots clés (Balise HTML, ID, Classes), il renvoi uniquement le 1er resultat sous forme d'objet HTML
//querySelectorAll : Est un querySelector qui renvoi tout les résultats qu'il a trouvés sous forme d'un tableaux d'objets HTML
for(var iTr = 1;iTr < listingTr.length; iTr++)
{
  // on explore le TR 
  var listingTd = listingTr[iTr].querySelectorAll("td") //on recupere tout les TD du TR actuel
  for(var iTd = 0; iTd < listingTd.length; iTd++)
  {
      if(iTd == "0")
      {

        var baliseA = listingTd[0].querySelector("a")

        //console.log(baliseA.innerHTML)

        csvFinal += baliseA.innerHTML + ";"
      }

    
    //pour chaque TD
    else
    {

    csvFinal += listingTd[iTd].innerHTML + ";" // on recupere son contenu que l'on concatene a la suite de la variable csvFinal

    }

  }
  csvFinal += "\n" //a la fin de la ligne, on ajoute un retour a la ligne a la suite du contenu de csvFinal
}

csvFinal = csvFinal.replaceAll("&nbsp;"," ").replaceAll("é","e").replaceAll("è","e")

console.log(csvFinal) //on affiche dans la console le contenu de la variable csvFinal