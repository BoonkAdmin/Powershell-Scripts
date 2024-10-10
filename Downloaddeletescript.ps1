$folderPath = "$env:USERPROFILE\Downloads"

$fileList = Get-ChildItem -Path $folderPath -File

$hashTable = @{}

foreach ($file in $fileList) {
    $hash = Get-FileHash -Path $file.FullName -Algorithm MD5

    if ($hashTable.ContainsKey($hash.Hash)) {
        Remove-Item -Path $file.FullName -Force
        Write-Output "Deleted duplicate file: $($file.Name)"
    } else {
        $hashTable[$hash.Hash] = $file.FullName
    }
}

