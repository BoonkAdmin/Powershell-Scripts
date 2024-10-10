$teamsCache = "$env:APPDATA\Microsoft\Teams"

# Check if Teams is running
$teamsProcess = Get-Process | Where-Object { $_.ProcessName -eq "Teams" }

if ($teamsProcess) {
    Write-Host "Microsoft Teams is running. Please close it before clearing the cache."
    exit
}

# Clear the Teams cache
if (Test-Path $teamsCache) {
    try {
        Remove-Item "$teamsCache\*" -Recurse -Force -ErrorAction Stop
        Write-Host "Microsoft Teams cache has been successfully cleared."
    }
    catch {
        Write-Host "An error occurred while clearing the Teams cache: $_"
    }
}
else {
    Write-Host "Microsoft Teams cache directory not found."
}