function Get-CPUFanSpeed {

[CmdletBinding()]

param([Parameter(Mandatory=$True)][string]$ComputerName)

BEGIN{}

PROCESS{

$cpufanspeed = Get-WmiObject -computername $ComputerName -Class HP_BIOSSensor -Namespace Root\HP\InstrumentedBIOS
$cpufanspeed = $cpufanspeed[0].CurrentReading
write-output "CPU Fan: $cpufanspeed RPMs"
}

END{}
}