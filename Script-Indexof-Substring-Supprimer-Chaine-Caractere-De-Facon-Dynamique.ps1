$richtextboxNamePrinter = "Copieur - test"

$indexOf = ($richtextboxNamePrinter).IndexOf("-") # -replace ('Copieur - ', "")

$asuppr = $richtextboxNamePrinter.Substring(0 ,$indexOf +2)

$location = $richtextboxNamePrinter -replace($asuppr,"")

$location