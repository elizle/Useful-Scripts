<#
.SYNOPSIS
Gets the temperature information from the hardware sensors
on HP computers that support HP CMI.
.PARAMETER ComputerName
One or more computer names or IP addresses to query.

.EXAMPLE
.\Get-TemperatureInfo -ComputerName 'computername'
#>
function Get-TemperatureInfo{

[CmdletBinding()]

param([Parameter(Mandatory=$True)][string]$ComputerName)

BEGIN{}

PROCESS{
#Gets the WMI Object containing all of the sensor data on HP computers that support CMI.
$hpbiossensor = Get-WmiObject -computername $ComputerName -Class HP_BIOSSensor -Namespace Root\HP\InstrumentedBIOS
#Sets the variable $cputemp to the temperature in degrees fahrenheit.
$cputemp = $((1.8 * $hpbiossensor[4].CurrentReading) + 32)
#Sets the variables $cpufanspeed and $psufanspeed to the current values in RPM.
$cpufanspeed = $hpbiossensor[0].CurrentReading
$psufanspeed = $hpbiossensor[3].CurrentReading

$obj = New-Object psobject

$obj |
    Add-Member -MemberType NoteProperty -Name "CPUTemp" -Value $cputemp -PassThru |
    Add-Member -MemberType NoteProperty -Name "CPUFanSpeed" -Value $cpufanspeed -PassThru |
    Add-Member -MemberType NoteProperty -Name "PSUFanSpeed" -Value $psufanspeed

Write-Output $obj
}
}