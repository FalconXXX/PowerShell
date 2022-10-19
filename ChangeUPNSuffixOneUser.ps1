#===========================================================#
#Change UPN Suffix  SMTP (one Account\User) \ *<*/
#24.07.2021 					                            
#by FalconXXX  Manuel Rieder)                  
#Build & Tested on:       Windows 10   	          
#https://github.com/FalconXXX                     
#add -> #####                                     
#===========================================================#

$account = Read-Host -Prompt "Account\User:"
$user = get-aduser $account | select-Object samaccountname, name, mail, userprincipalname

foreach ($users in $user) {
	$oldupn = $users.userprincipalname
	write-host "Aktuell -> $oldupn" -background black -foreground white
	$new_suffix = "#####.at"
	$userName = $users.userprincipalname.Split('@')[0]  
	$NEWUPN = $userName +"@" + $new_suffix
	set-aduser $users.samaccountname -UserPrincipalName $NEWUPN
	set-aduser $users.samaccountname -add @{ProxyAddresses="SMTP:$NEWUPN"}
	set-aduser $users.samaccountname -remove @{ProxyAddresses="smtp:$oldUPN"}
	set-aduser $users.samaccountname -add @{ProxyAddresses="smtp:$oldUPN"}
	set-aduser $users.samaccountname -replace  @{targetAddress=$NEWUPN} 
	set-aduser $users.samaccountname -replace  @{mail=$NEWUPN}
	write-host "Geändert -> $NEWUPN" -background green -foreground red
}
