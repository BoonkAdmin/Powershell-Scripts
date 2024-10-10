# Function to empty the recycle bin for a specific user
function EmptyRecycleBin {
    param(
        [string]$userFolderPath
    )

    $recycleBinPath = Join-Path -Path $userFolderPath -ChildPath "AppData\Local\Microsoft\Windows\Explorer"
    
    # Check if the Recycle Bin exists for the user
    if (Test-Path -Path $recycleBinPath) {
        $shell = New-Object -ComObject Shell.Application
        $recycleBin = $shell.Namespace(0xa)
        
        # Loop through each item in the Recycle Bin and delete it
        foreach ($item in $recycleBin.Items()) {
            $recycleBin.InvokeVerb("Delete")
        }
        Write-Host "Recycle bin emptied for $($userFolderPath)"
    } else {
        Write-Host "Recycle bin not found for $($userFolderPath)"
    }
}

# Get all user directories under C:\Users, excluding Default and folders with the name "Admin"
$users = Get-ChildItem -Path "C:\Users" | Where-Object { $_.Name -ne "Default" -and $_.Name -notlike "*Admin*" }

# Loop through each user directory
foreach ($user in $users) {
    $userFolderPath = Join-Path -Path "C:\Users" -ChildPath $user.Name
    
    $outlookFolderPath = Join-Path -Path $userFolderPath -ChildPath "AppData\Local\Microsoft\Outlook"

    # Check if Outlook folder exists
    if (Test-Path -Path $outlookFolderPath) {
        # Remove Outlook folder
        Remove-Item -Path $outlookFolderPath -Recurse -Force
        Write-Host "Outlook folder deleted for $($user.Name)"
    } else {
        Write-Host "Outlook folder not found for $($user.Name)"
    }

    # Empty the recycle bin for each user
    EmptyRecycleBin -userFolderPath $userFolderPath
}