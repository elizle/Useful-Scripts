function Get-PSUFanSpeed {

[CmdletBinding()]

param([Parameter(Mandatory=$True)][string]$ComputerName)

BEGIN{}

PROCESS{

$psufanspeed = Get-WmiObject -computername $ComputerName -Class HP_BIOSSensor -Namespace Root\HP\InstrumentedBIOS
$psufanspeed = $psufanspeed[3].CurrentReading
write-output "Power Supply Fan: $psufanspeed RPMs"
}

END{}
}