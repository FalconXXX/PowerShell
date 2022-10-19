#===========================================================#
#Create\Copy new User *<*/
#12.10.2021 					                            
#by FalconXXX	(Manuel Rieder)                  
#Build & Tested on:       Windows 11   	          
#https://github.com/FalconXXX/PowerShell                                                     
#===========================================================#


$ReferenzU = Read-Host -Prompt "ReferenzU:"
$ou = Read-Host -Prompt "OU:"
$firstname = Read-Host -Prompt "Vorname:"
$lastname = Read-Host -Prompt "Nachname:"
$suffix = "FILL IN"
$dc = "FILL IN"
$dc1 = "FILL IN"

$displayName = $lastname +", "+$firstname
$UPN = $firstname.toLower() +"." + $lastname.toLower()  +"@" + $suffix
$AccountName = $lastname.toLower()

#create account
New-ADUser -Name $displayName -GivenName $firstname -Surname $lastname -SamAccountName $AccountName -UserPrincipalName $UPN  -Path "OU=$ou,DC=$dc,DC=$dc1" -AccountPassword(Read-Host -AsSecureString "Input Password") -Enabled $true
	
 #copy info	
	$copyInfo = Get-ADUser -Identity $ReferenzU -Properties StreetAddress,City,Title,PostalCode,Office,Department,Manager, State, Country, Company
  
        Set-ADUser  $lastname -add @{Department=$copyInfo.Department}  -erroraction 'silentlycontinue'
        Set-ADUser  $lastname -add @{Manager=$copyInfo.Manager} -erroraction 'silentlycontinue'
        Set-ADUser  $lastname -add @{Office=$copyInfo.Office}  -erroraction 'silentlycontinue'
        Set-ADUser  $lastname -add @{PostalCode=$copyInfo.PostalCode} -erroraction 'silentlycontinue'
        Set-ADUser  $lastname -add @{Title=$copyInfo.Title} -erroraction 'silentlycontinue'
        Set-ADUser -identity $lastname -City $copyInfo.City -erroraction 'silentlycontinue'
        Set-ADUser  $lastname -add @{StreetAddress=$copyInfo.StreetAddress} -erroraction 'silentlycontinue'
        Set-ADUser -identity $lastname -State $copyInfo.State -erroraction 'silentlycontinue'
        Set-ADUser -identity $lastname -Country $copyInfo.Country -erroraction 'silentlycontinue'
        Set-ADUser -identity $lastname -Company $copyInfo.Company -erroraction 'silentlycontinue'
        Set-ADUser $lastname -UserPrincipalName $UPN
        Set-ADUser $lastname -add  @{targetAddress=$UPN}  
        Set-ADUser $lastname -add  @{mail=$UPN} 
        Set-ADUser $lastname -DisplayName ($lastname +", "+$firstname)
     
  #copy groups
      $GroupList = Get-ADPrincipalGroupMembership -Identity $ReferenzU 
      Add-ADPrincipalGroupMembership -Identity $lastname -MemberOf $GroupList
   

	#del  Group WIP
	#Remove-AdGroupMember -Identity Group" -members $lastname
