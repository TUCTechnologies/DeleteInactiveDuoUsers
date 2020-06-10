$DuoUsers = Import-CSV ".\users-2020-06-10.csv" -Header Username,Name,Email,Status,Created,"Last Login","Synced From Directory",alias1,alias2,alias3,alias4,"Phone 1","Phone 1 platform"
$Groups = 'DUO_User', 'DUO_VPN', 'Duo_Admin_User'

# Perform this actions on specified groups
ForEach($Group in $Groups) {
$Members = Get-ADGroupMember -Identity $Group -Recursive | Select -ExpandProperty SamAccountName

	# Loops through Duo users
	ForEach($DuoUser in $DuoUsers) {
		$User = ($DuoUser.Username)
		$LastLogin = ($DuoUser."Last Login")
		
		# If user hasn't logged into Duo
		If($LastLogin -eq "") {
			
			# If user is a member of the group in question
			If ($Members -contains $User) {
				Write-Host "$User is a member of $Group and has not logged into Duo, removing..."
				Remove-ADGroupMember -Identity $Group -Members $User -Confirm:$False
			} 
		}
	}
}
