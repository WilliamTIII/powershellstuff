$computers=get-adcomputer -Filter * -Properties * | select @{Label="Name";Expression={$_.name}}, @{Label="OS";Expression={$_.operatingsystem}}, @{Label="Distinguishedname";Expression={$_.'distinguishedname'}}, @{Label="Password";Expression={$_.'ms-Mcs-AdmPwd'}}, @{Label="PassLastSet";Expression={$_.PasswordLastSet}}, @{Label="PassExpired";Expression={$_.'PasswordExpired'}}, @{Label="PassRequired";Expression={$_.'PasswordNotRequired'}}, @{Label="Modified";Expression={$_.'Modified'}}, @{Label="LogonCount";Expression={$_.'logonCount'}}, @{Label="LastLogonDate";Expression={$_.'LastLogonDate'}} 

#$Results=@()
foreach($computer in $computers){
    if($computer.lastlogondate -le ((get-date).adddays(-270))){
        Move-ADObject -Identity $computer.distinguishedname -TargetPath "OU=Tombstone,OU=Servers,DC=,DC=com" -WhatIf
        #$results+=$computer.name
    }
}
#$results.count



$delete = $computers | ?{ $_.distinguishedname -notlike "*OU=cluster*" -and $_.os -like "*windows*" -and $_.lastlogondate -le ((get-date).adddays(-365)) } 


