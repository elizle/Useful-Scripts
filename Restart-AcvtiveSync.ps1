#Gets the PID of WcesComm because it is running as svchost
#Stop-Process svchost is not something you want to run.
$WcesCommPID = (get-wmiobject win32_service | where { $_.name -eq 'WcesComm'}).processID
Stop-Process $WcesCommPID -Force

#Stop Windows Mobile-based device connectivity services
Get-Service -Name WcesComm | Stop-Service -Force
Get-Service -Name RapiMgr | Stop-Service -Force

#Restart Windows Mobile services
Get-Service -Name RapiMgr | Start-Service
Get-Service -Name WcesComm | Start-Service

#Shows if the services have started correctly
Get-Service -Name RapiMgr
Get-Service -Name WcesComm
