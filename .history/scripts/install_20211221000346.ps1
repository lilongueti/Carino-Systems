do
 {
     Show-Menu
     $selection = Read-Host "Please make a selection"
     switch ($selection)
     {
        '1' {
                'You chose option #1'
                winget upgrade --all
                break
            }
        '2' {
                'You chose option #2'
            }
        '3' {
                'You chose option #3'
            }
        '4' {
                'You chose option #4'
            }
     }
     pause
 }
 until ($selection -eq '4')