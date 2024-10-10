$usersFolder = "C:\Users"

# Get the current date
$currentDate = Get-Date

# Calculate the date 3 months ago
$threeMonthsAgo = $currentDate.AddMonths(-3)

# Get all user folders
$userFolders = Get-ChildItem -Path $usersFolder -Directory

# Initialize a counter for deleted accounts
$deletedAccountsCount = 0


foreach ($userFolder in $userFolders) {
    $lastAccessTime = $userFolder.LastAccessTime

  
    if ($lastAccessTime -lt $threeMonthsAgo) {
        $username = $userFolder.Name

     
        if ($username -notin @("Public", "Default", "All Users", "Default User")) {
            Write-Host "User account '$username' hasn't been accessed since $lastAccessTime"
            $confirmation = Read-Host "Do you want to remove this user account? (Y/N)"

            if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
                Write-Host "Removing user account: $username"

                
                Remove-LocalUser -Name $username -ErrorAction SilentlyContinue

                
                Remove-Item -Path $userFolder.FullName -Recurse -Force -ErrorAction SilentlyContinue

                Write-Host "User account $username has been removed."
                $deletedAccountsCount++
            } else {
                Write-Host "Skipping user account: $username"
            }
        }
    }
}


if ($deletedAccountsCount -gt 0) {
    Write-Host "User account cleanup completed. $deletedAccountsCount account(s) were deleted."
} else {
    Write-Host "User account cleanup completed. No accounts were deleted."
}