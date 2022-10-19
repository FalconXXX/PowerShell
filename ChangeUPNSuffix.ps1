#===========================================================#
#Change UPN Suffix SMTP  all users in the selected OU \ *<*/
#05.08.2021 					                            
#by FalconXXX	(Manuel Rieder)                  
#Build & Tested on:       Windows 10   	          
#https://github.com/FalconXXX/PowerShell                 
#add -> #####                                     
#===========================================================#

$ou = Read-Host -Prompt "OU:"
$user = get-aduser  -Filter * -Properties * | where {$_.distinguishedName -like "*OU=$ou,DC=#####,DC=local"} | select-Object samaccountname, name, mail, userprincipalname
foreach ($users in $user) 
{
		$new_suffix = "#####.at"
		$checkRexel = $users.userprincipalname.Split('@')[1]
		$UserXX =   $users.userprincipalname
	if($checkRexel -eq $new_suffix)
	{
		write-host "keine Änderung nötig -> $UserXX" -background green -foreground black
	}
	else
	{
		$oldupn = $users.userprincipalname
		write-host "Aktuell -> $oldupn" -background black -foreground white
		$userName = $users.userprincipalname.Split('@')[0]  
		$NEWUPN = $userName +"@" + $new_suffix
		Set-ADUser $users.samaccountname -UserPrincipalName $NEWUPN
		set-aduser $users.samaccountname -remove @{ProxyAddresses="smtp:$oldUPN"}
		set-aduser $users.samaccountname -add @{ProxyAddresses="SMTP:$NEWUPN"}
		set-aduser $users.samaccountname -add @{ProxyAddresses="smtp:$oldUPN"}
		set-aduser $users.samaccountname -replace  @{targetAddress=$NEWUPN} 
		set-aduser $users.samaccountname -replace  @{mail=$NEWUPN}
		write-host "Geändert -> $NEWUPN" -background green -foreground black
	}
}
