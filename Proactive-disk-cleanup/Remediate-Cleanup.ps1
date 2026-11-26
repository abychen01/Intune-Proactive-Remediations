try {
    Write-Output "Initiating deep storage recovery processes..."

    # 1. Clean up the Windows Component Store (WinSxS) - Purges superseded updates
    Write-Output "Compressing and purging superseded Windows Update components via DISM..."
    $DismArgs = "/Online /Cleanup-Image /StartComponentCleanup /ResetBase"
    Start-Process -FilePath "dism.exe" -ArgumentList $DismArgs -NoNewWindow -Wait -ErrorAction SilentlyContinue

    # 2. Quietly run the built-in Windows Disk Cleanup tool state manager
    # Pre-sets standard temp/log clean targets in the registry so cleanmgr can run headless
    $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
    Get-ChildItem -Path $Path | ForEach-Object {
        Set-ItemProperty -Path $_.PsPath -Name "StateFlags0001" -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue
    }
    Write-Output "Executing cleanmgr engine..."
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait -ErrorAction SilentlyContinue

    # 3. Empty global System Temp directories
    Write-Output "Clearing system telemetry caches and temporary files..."
    $SysTemp = "$env:SystemRoot\Temp"
    if (Test-Path $SysTemp) {
        Get-ChildItem -Path $SysTemp -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    }

    # Re-evaluate space recovered
    $Drive = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"
    $FinalFreeGB = [math]::Round($Drive.FreeSpace / 1GB, 2)
    
    Write-Output "Remediation Completed. Available system storage is now at: $FinalFreeGB GB."
    exit 0
}
catch {
    Write-Error "Storage recovery process encountered a termination error: $_"
    exit 1
}
