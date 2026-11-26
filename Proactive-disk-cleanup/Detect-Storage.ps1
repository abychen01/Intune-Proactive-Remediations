# Define thresholds: 30GB in Bytes or less than 10% free space
$MinFreeBytes = 30   * 1024 * 1024 * 1024
$PercentThreshold = 10

try {
    $Drive = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction Stop
    $FreeSpaceGB = [math]::Round($Drive.FreeSpace / 1GB, 2)
    $TotalSpace = $Drive.Size
    $PercentFree = ($Drive.FreeSpace / $TotalSpace) * 100

    if ($Drive.FreeSpace -lt $MinFreeBytes -or $PercentFree -lt $PercentThreshold) {
        Write-Output "Non-Compliant: Drive C: is critically low. Free space: $FreeSpaceGB GB ($([math]::Round($PercentFree,1))% free)."
        exit 1 # Triggers the cleanup script
    } else {
        Write-Output "Compliant: Drive C: has healthy storage headroom. Free space: $FreeSpaceGB GB."
        exit 0
    }
}
catch {
    Write-Error "Failed to evaluate disk metrics: $_"
    exit 0 # Exit 0 to avoid false positives if WMI fails momentarily
}
