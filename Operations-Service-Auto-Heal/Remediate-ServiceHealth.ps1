
$ServiceName = "wuauserv"

try {
    Set-Service -Name $ServiceName -StartupType Automatic -ErrorAction Stop
    Start-Service -Name $ServiceName -ErrorAction Stop
    Write-Output "REMEDIATED: Set $ServiceName to Automatic and started the service."
    exit 0
}
catch {
    Write-Error "Failed to start ${ServiceName}: $_"
    exit 1
}
