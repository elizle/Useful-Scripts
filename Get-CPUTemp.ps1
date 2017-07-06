function Get-CPUTemp {

[CmdletBinding()]

param([Parameter(Mandatory=$True)][string]$ComputerName)

BEGIN{}

PROCESS{

$cputemp = Get-WmiObject -computername $ComputerName -Class HP_BIOSSensor -Namespace Root\HP\InstrumentedBIOS
$cputemp = $((1.8 * $cputemp[4].CurrentReading) + 32)
write-output "CPU Temperature: $cputemp°F"
}

END{}
}