function New-CodePromo {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)][int]$Length,
        [Parameter(Mandatory=$false)][int]$Uppercase=1,
        [Parameter(Mandatory=$false)][int]$Digits=1,
        [Parameter(Mandatory=$false)][int]$SpecialCharacters=1
    )
    Begin {
        $Lowercase = $Length - $SpecialCharacters - $Uppercase - $Digits
        $ArrayLowerCharacters = @('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z')
        $ArrayUpperCharacters = @('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
        $ArraySpecialCharacters = @('0','1','2','3','4','5','6','7','8','9','0')
    }
    Process {
            [string]$NewPassword = $ArrayLowerCharacters | Get-Random -Count $Lowercase
            $NewPassword += 0..9 | Get-Random -Count $Digits
            $NewPassword += $ArrayUpperCharacters | Get-Random -Count $Uppercase
            $NewPassword += $ArraySpecialCharacters | Get-Random -Count $SpecialCharacters

            $NewPassword = $NewPassword.Replace(' ','')

            $characterArray = $NewPassword.ToCharArray()  
            $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length    
            $NewRandomPassword = -join $scrambledStringArray
    }
    End {
            Return $NewRandomPassword
    }
}

New-CodePromo -Length 15 -Uppercase 3 -Digits 2 -SpecialCharacters 2