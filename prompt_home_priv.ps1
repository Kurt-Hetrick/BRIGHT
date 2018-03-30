#Run this script to create both user and priv folders and set Windows users permissions. 
#This script should be run before the bash script newuser.sh! 
#Run with at least two arguments, Path and user or usergroup(s)

If( $args.count -lt 1 ) {
    write-host "Please enter JHED ID for argument!"
    write-host "Exiting..."
    exit
}

#Variables
$OUTPUT_FILE = "X:\support\Scriptlogs\ResetACE.txt"
$date = get-date -Format g |Out-File -FilePath $OUTPUT_FILE
#$dirPath =  $args[0]
$username = $args[0]
$path = "x:\users\"+$username +"\priv"
$Path1 = "x:\users\"+$username
$path2 = "x:\users\"

#Verify drive path and user
Write-Host "User      : "$username
#Write-Host "Directory : "$dirPath
Write-Host "Directory : "$Path

#iCACLs settings
$Grant = "/grant:r"
$Remove = "/remove"
$Setowner="/setowner"
$replaceInherit = "/inheritance:r"
$disableInherit = "/inheritance:d"
$RemoveACE= "/inheritance:r"
$groupPermissions = ":(OI)(CI)(IO)(RX,W,DC)"
$userPermissions = ":(OI)(CI)(RX,W,DC)"

#Create Folder(s) and sets the Windows ACE the user permission. 
   If(!(test-path $Path  )) {New-Item -ItemType Directory -Force -Path $Path} #| Out-File -FilePath $OUTPUT_FILE -Append
        Invoke-Expression -Command ('icacls $Path1 $Remove ${username}')
        Invoke-Expression -Command ('icacls $Path1 $Grant ${username}${permission1}') | Out-File -FilePath $OUTPUT_FILE -Append 
        Invoke-Expression -Command ('icacls $Path1 $Setowner ${username}')
        Invoke-Expression -Command ('icacls $Path1') | Out-File -FilePath $OUTPUT_FILE -Append
        Invoke-Expression -Command ('icacls $Path') | Out-File -FilePath $OUTPUT_FILE -Append
        Write-Host $Path1 $Grant ${UserName}${permission1}

        #Set priv directory permission, it disables inheritance, removes the jhg_all group.
        Invoke-Expression -Command ('icacls $Path $disableInherit') | Out-File -FilePath $OUTPUT_FILE -Append
        Invoke-Expression -Command ('icacls $Path $RemoveACE') | Out-File -FilePath $OUTPUT_FILE -Append
        Invoke-Expression -Command ('icacls $Path /remove win\jhg_all') | Out-File -FilePath $OUTPUT_FILE -Append
        Invoke-Expression -Command ('icacls $Path $Grant ${username}${permission5}') | Out-File -FilePath $OUTPUT_FILE -Append