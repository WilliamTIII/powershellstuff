#look for stuff in termindations
#get rid of old stuff, make new folder structure


$lostusers=Get-ADObject -SearchBase 'OU=Terminations,DC=Shamrockfoods,DC=COM' -filter {ObjectClass -ne "organizationalUnit"} -searchscope 1
$3months =  "{0:MM}" -f (get-date).AddMonths(3) + "01" +  "{0:yy}" -f (get-date).AddMonths(3) 
$fullpath = "OU=$3months,OU=Terminations,DC=Shamrockfoods,DC=COM"
if(!([adsi]::Exists("LDAP://$fullpath"))){New-ADOrganizationalUnit "$3months" -Path "OU=Terminations,DC=Shamrockfoods,DC=COM"}

foreach($user in $lostusers){
    Move-ADObject -Identity $user.DistinguishedName -TargetPath  "OU=$3months,OU=Terminations,DC=Shamrockfoods,DC=COM"
}

############################################################################################################################

$thismonth = "{0:MM}" -f (get-date) + "01" +  "{0:yy}" -f (get-date)
$fullpath2 = "OU=$thismonth,OU=Terminations,DC=Shamrockfoods,DC=COM"
$readytodelete = Get-ADObject -SearchBase $fullpath2  -filter *
1..10 | % { foreach($object in $readytodelete){$object;Remove-ADObject $object -Confirm:$false }}
