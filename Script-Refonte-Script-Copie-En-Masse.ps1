############################################################
# Fabrication de la fenetre de choix multiple
# $tableau = "fichier1","fichier2","fichier3"
# write-host $tableau.length
# write-host $tableau
#
# $arrayList = [System.Collections.ArrayList]@("fichier1","fichier2","fichier3")    Initialisation de $arrayList en tant que liste 
# write-host $arrayList.count
# write-host $arrayList.add("fichier4")
# write-host $arrayList.remove("fichier3")
# write-host $arrayList
#
# pause

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Selection fichier(s) à copier'
$form.Size = New-Object System.Drawing.Size(500, 400)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(135, 328)
$OKButton.Size = New-Object System.Drawing.Size(75, 24)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(250, 328)
$CancelButton.Size = New-Object System.Drawing.Size(75, 24)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = 'Veuillez faire une sélection dans la liste ci-dessous :'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10, 40)
$listBox.Size = New-Object System.Drawing.Size(463, 20)
$listBox.Height = 280
$listBox.SelectionMode = 'MultiExtended'

#################################################################################################################################

$destinationLog = (Get-ChildItem Env:\USERPROFILE).value + "\copiemassive.log"    #Chemin de destination des log

Start-Transcript -Path $destinationLog -Append    #Démmarage de l'enregistrement des logs

Get-Date -format 'dd/MM/yyyy HH:mm:ss'    #Obtention de la date et l'heure pour les logs

### Partie 1 ###
$rep1 = "0"                          #Initialisation de la variable $rep1 à 0

While ($rep1 -ne "y")                       #Tant que la variable $rep1 n'est pas égal a "y" alors tu entre dans la boucle
{
    cls                             #Tu efface tout le contenu sur l'écran

    $quelChemin = ""                        #Initialisation de la variable $quelChemin à Rien/Vide

    $quelChemin = Read-Host "Quel chemin voulez-vous ?"             #Demande à l'utilisateur de rentré le chemin voulu

    $afficheChemin = Get-ChildItem $quelChemin -Force                    #La variable $afficheChemin contient un dir de la variable $quelChemin

    Write-Host "Le chemin saisi est :" $quelChemin                    #On affiche le contenu de la variable
    Write-Host "Et comporte :"
    $afficheChemin                                 #On affiche içi le contenu de la variable $afficheChemin, qui liste l'entiereté de la variable $quelChemin

    $rep1 = Read-Host "Est-ce le bon chemin ? [y] ou [n]"                       #On demande à l'utilisateur de confirmer par "y" son chemin ou de l'infirmer par "n"

}

Write-Host "Le chemin sélectionner est donc :" $quelChemin              #On affiche le contenu de la variable $quelChemin

#Si le chemin se termine par un "\" ou un "/", alors il sera supprimer dans le code
$quelCheminLastCharIsABackSlashOrSlash = $quelChemin.Substring($quelChemin.Length - 1, 1)

if ($quelCheminLastCharIsABackSlashOrSlash -eq "\" -or $quelCheminLastCharIsABackSlashOrSlash -eq "/")
{
    $quelChemin = $quelChemin.Substring(0, $quelChemin.Length - 1)
}

### Partie 2 ###

foreach ($elements in $afficheChemin)         #Pour tout élément se trouvant dans la variable $afficheChemin
{

    [void]$listbox.Items.Add($elements)       #Tu ajoute à la liste $listbox ces éléments

}

$rep2 = "n"         #Initialisation de la vaiable $rep2 à "n"

While ($rep2 -ne "y")     #Tant que la variable $rep2 n'est pas égale à "y" alors tu entre dans la boucle
{
    $form.Controls.Add($listBox)
    $form.Topmost = $true                #Génération de l'IHM

    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)      #Si le résultat de l'IHM est "OK" alors tu entre dnas la boucle
    {
        $cheminFinal = [System.Collections.ArrayList]@()      #On initialise $cheminFinal en tant que liste
        for ($i = 0; $i -lt $listBox.SelectedItems.count; $i++)        #Pour $i allant de 0 jusqu'a la taille de $listBox.SelectedItems, $i s'incrémente de 1
        {

          [void]$cheminFinal.Add($quelChemin + "\" + $listBox.SelectedItems[$i])     #La liste $cheminFinal contient la variable $quelChemin + un "\" + tout les éléments séléctionner dans l'IHM

        }

        for ($i = 0; $i -lt $cheminFinal.Count; $i++)       #Pour $i allant de 0 jusqu'a la taille de la liste $cheminFinal, $i s'incrémente de 1
        {

          Write-Host $cheminFinal[$i]     #Affiche le contenu de $cheminFinal

        }

        $rep2 = Read-Host "Est ce que c'est bon chemin ? [y] ou [n]"    #On demande à l'utilisateur si le chemin séléctionner est le bon sinon on retourne ligne 90 dans la boucle While
    }
}

    ### Partie 3 ###

    $cheminTestCopie = $false     #On initialise la variable $cheminTestCopie à la valeur $false (faux)

    while ($cheminTestCopie -eq $false)       #Tant que la valeur de la variable $CheminTestCopie est égal à $False (faux), alors tu entre dans la boucle
      {

          $cheminCopie = Read-Host "Où voulez vous copier ce(s) fichier(s) ?"     #On demande à l'utisateur où il souhaite copier ses fichiers
          $cheminTestCopie = Test-Path $cheminCopie       #La variable $cheminTestCopie test si le chemin rentré par l'utilisateur via la variable $cheminCopie existe

          if ($cheminTestCopie -eq $false)        #Si le chemin rentré par l'utilisateur n'existe pas alors
        {
          $repTestPath = "3"        #On initialise la variable $repTestPath à "3"

          while($repTestPath -ne "1" -and $repTestPath -ne "2")       #Tant que la variable $repTestPath n'est pas égale soit à "1" soit à "2", alors tu entre dans la boucle
          {

            $repTestPath = Read-Host "1 Creation ou 2 erreur"     #On demande à l'utilisateur si le chemin qu'il a rentré et qui n'existe pas est une erreur "2" de sa part -> on revient ligne 124 dans la boucle While ou si il veut créer "1" ce chemin -> on entre ligne 139 dans la condition if

            if ($repTestPath -eq 1)     #Si l'utilisateur répond "1", la variable $repTestPath est donc égale à "1", alors

            {
              mkdir $cheminCopie -Force           #Le chemin rentré part l'utilisateur est créer
              $cheminTestCopie = Test-Path $cheminCopie         #On test maintenant si le chemin créer existe bien, si oui on sors de la boucle pour aller copier le fichier, si non on reviens ligne 124 dans la boucle While
            }

          }

        }

      }

      Write-Host "Copie en cours ..." -foregroundcolor green        #Affiche le texte "Copie en cours ..."

      for ($i = 0; $i -lt $cheminFinal.count; $i++)       #Pour $i égal à 0, jusqu'a la longueur de $cheminFinal, $i s'incrémente de 1
      {

        Copy-Item -Path $cheminFinal[$i]  -Destination $cheminCopie -Force -Recurse    #On copie le contenu de la liste $cheminFinal vers la valeur de la variable $cheminCopie rentré par l'utilisateur

      }


Stop-Transcript         #Arret des logs