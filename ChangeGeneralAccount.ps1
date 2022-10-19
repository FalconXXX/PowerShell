#===========================================================#
#Change General Account  FirstName\LastName\UPN\CN  \ </
#09.10.2021 					                            
#by FalconXXX 	(Manuel Rieder)                  
#Build & Tested on:       Windows 10   	          
#https://github.com/FalconXXX/PowerShell                                                     
#===========================================================#


$SamAccount = Read-Host -Prompt "Accountnamen:"
$user = get-aduser $SamAccount -Properties * | select-Object samaccountname, name, mail, userprincipalname, surname, givenname
#$user
$firstname = Read-Host -Prompt "Vorname:"
$lastname = Read-Host -Prompt "Nachname:"
$new_suffix = "YOURSUFFFIX.at"
	$oldupn = $user.userprincipalname
	write-host "Aktuell -> $oldupn" -background black -foreground white 
	$NEWUPN = $firstname.ToLower() +"." + $lastname.ToLower()  +"@" + $new_suffix

		set-aduser $user.samaccountname -UserPrincipalName $NEWUPN
		set-aduser $user.samaccountname -remove @{ProxyAddresses="smtp:$oldUPN"}
		set-aduser $user.samaccountname -add @{ProxyAddresses="SMTP:$NEWUPN"}
		set-aduser $user.samaccountname -add @{ProxyAddresses="smtp:$oldUPN"}
		set-aduser $user.samaccountname -replace  @{targetAddress=$NEWUPN} 
		set-aduser $user.samaccountname -replace  @{mail=$NEWUPN}

		set-aduser -Identity $user.samaccountname -DisplayName ($lastname +", "+$firstname)
		
		set-aduser -Identity $user.samaccountname -GivenName $firstname -Surname $lastname

		$cn_new = $lastname +", "+$firstname
		Get-ADUser $SamAccount | Rename-ADObject -NewName $cn_new
    	write-host "Aktuell -> $NEWUPN" -background black -foreground red
