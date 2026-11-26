
$ServiceName = "wuauserv"
$Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($Service -and $Service.Status -eq "Running") {
    Write-Output "COMPLIANT: $ServiceName is running."
    exit 0
}

Write-Output "NON-COMPLIANT: $ServiceName is $($Service.Status)."
exit 1
