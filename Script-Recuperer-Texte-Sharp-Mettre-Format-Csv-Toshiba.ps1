# fichier.csv -> la liste bla bla bla
# lire le fichier -> get-content -> on le stocke dans une PUTAIN DE VAAAAARIIAABLE !!!
$cheminFichierCsv = read-host "chemin du fichier "
$contenu = get-content $cheminFichierCsv

# lire chaque ligne du fichier

for($iContenu = 0; $iContenu -lt $contenu.length;$iContenu++)
{
  # -> trier chaque ligne a partir du caractere ";" -> split
  # split renvoi -> tableau
  $contenu[$iContenu] = $contenu[$iContenu] -split ";"
}
# -> savoir si c est un fax ou un Cour.Elect
# write-host $contenu[1][1]
# for($iContenu = 0; $iContenu -lt $contenu.length ;$iContenu++)
# {
#   write-host $contenu[$iContenu]
# }

$csv = '"First Name","Last Name","Email Address","Tel Number","2nd Fax Number","IPFax Destination","Facsimile Mode","Company","Department","Keyword","Furigana","SUB","SID","SEP","PWD","ECM","Line Select","Quality Transmit","Transmission Type","Attenuation","FavoriteFax","FavoritEmail"'
$csv += "`n"
for($iContenu=0; $iContenu -lt $contenu.length; $iContenu++)
{
  #-> laBaliseA -> atterit dans 2 eme colonne
  #     -> "","laBaliseA"
  $csv += '"","'+ $contenu[$iContenu][0]+'",'


  # -> si fax
  if($contenu[$iContenu][1] -eq "fax")
  {


    for($index = 0;$index -lt 20; $index++)
    {


      # -> 4 -> 7
      if($index -eq 1)
      {
        #   -> le numero (colonne 3) -> atterit colonne 4
        $csv += '"'+ $contenu[$iContenu][2]+'",'
      }
      elseif($index -eq 4)
      {
        #   -> 7eme colonne du final -> "G3"
        $csv += '"G3",'
      }
      elseif($index -eq 8)
      {
        #-> laBaliseA -> atterit dans la 11 eme colonne
        $csv += '"'+ $contenu[$iContenu][0]+'",'
      }
      else
      {
        $csv += '""'
        if($index -ne 19)
        {
          $csv += ','
        }
      }


    }


  }
  #-> sinon
  else
  {
    #   -> l adresse mail (3 eme colonne) -> atterit 3 eme colonne
    #-> laBaliseA -> atterit dans la 11 eme colonne
    # -> definir tes cibles -> "", -> si c est pas une cible -> 3eme colone -> 11 eme -> tout le reste -> "",
    # -> parcourir le csvFinal pour le remplir -> for
    for($index =0;$index -lt 20;$index++)
    {

      # -> 3eme colone
      if($index -eq 0)
      {
        $csv += '"'+$contenu[$iContenu][2]+'",'
      }
      # -> tout le reste -> "",
      elseif($index -eq 8)
      {
        $csv += '"'+ $contenu[$iContenu][0] +'",'
      }
      else
      {
        $csv += '""'
        if($index -ne 19)
        {
          $csv += ','
        }
      }


    }



  }
  $csv +=  "`n"
}
write-host $csv

#$csv | Out-File -FilePath C:\Users\048710\desktop\conf-192.168.11.69.csv -Append