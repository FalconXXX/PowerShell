#===========================================================#
#SW Update \*<*/
#06.02.2023					                            
#by FalconXXX	(Manuel Rieder)                  
#https://github.com/FalconXXX/PowerShell                                                     
#===========================================================#
Write-Host "SW Update possible:`n"
winget upgrade
Write-Host "Perform update? Y or N:"
$inputSW = Read-Host
if($inputSW -eq "Y")
{
    Start-Process powershell -Verb runAs
    winget upgrade -h --all 
    Write-Host "SW update performed"
}
else{
    exit;
}