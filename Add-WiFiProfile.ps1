Param(
#Parameter to define a specific computer to run this script on.
[string]$computerName
)

#This checks to see if a computer was specified.
if($computerName)
{
    $computers = Get-ADComputer $computerName
}
<#If no computer is specified, the script will run on all computers in any OU
containing the word "Laptop"#>
else
{
$computers = Get-ADComputer -Filter * | Where-Object {$_.DistinguishedName -like "*Laptop*"}
}



#Copy Profile
foreach($computer in $computers)
{
    $testnet = ''
    #Tries to ping the computer, then stores results in variable $testnet
    try
    {
        Write-Host -ForegroundColor Yellow "Copying wireless profile to $($computer.Name)"
        $testnet = Test-Connection $computer.Name -Count 2 -ErrorAction Stop
    }
    #If unable to ping the computer, it displays that it is not connected.
    catch
    { Write-Host -ForegroundColor Red "$($computer.Name) not connected" }

    #If ping was successful, the script moves on, if not it loops back to the next computer
    if($testnet)
    {
        #This copies the wireless profile from a specified location to C:\Temp on the remote computer.
        $testdir = Test-Path "\\$($computer.name)\c$\Temp"
        if(!$testdir)
        {
            New-Item -Path "\\$($computer.name)\c$\Temp" -ItemType Directory -Force
        }
        <#Replace these with actual wireless profiles exported from netsh.
        To export a WiFi profiles run the following commands:
          netsh wlan show profiles
          netsh wlan export profile name="Profile Name" key=clear
        Replace "Profile Name" with the actual name.#>
        Copy-Item \\fileserver\share\WirelessProfiles\Profile1.xml "\\$($computer.name)\c$\Temp"
        Copy-Item \\fileserver\share\WirelessProfiles\Profile2.xml "\\$($computer.name)\c$\Temp"
        Copy-Item \\fileserver\share\WirelessProfiles\Profile3.xml "\\$($computer.name)\c$\Temp"
        Copy-Item \\fileserver\share\WirelessProfiles\Profile4.xml "\\$($computer.name)\c$\Temp"


        Invoke-Command -ComputerName $computer.Name -ScriptBlock {
            #Remove Guest WLAN Profile
            Start-Process netsh -ArgumentList 'wlan delete profile name="GuestNetwork1"' -wait
            Start-Process netsh -ArgumentList 'wlan delete profile name="GuestNetwork2"' -wait
            }
        Invoke-Command -ComputerName $computer.Name -ScriptBlock {
            #Import WLAN Profile
            Start-Process netsh -ArgumentList 'wlan add profile filename="C:\Temp\Profile1.xml"' -wait
            Start-Process netsh -ArgumentList 'wlan add profile filename="C:\Temp\Profile2.xml"' -wait
            Start-Process netsh -ArgumentList 'wlan add profile filename="C:\Temp\Profile3.xml"' -wait
            Start-Process netsh -ArgumentList 'wlan add profile filename="C:\Temp\Profile4.xml"' -wait
            }
        Invoke-Command -ComputerName $computer.Name -ScriptBlock {
            #Remove Profile from Temp
            Remove-Item C:\Temp\Profile1.xml
            Remove-Item C:\Temp\Profile2.xml
            Remove-Item C:\Temp\Profile3.xml
            Remove-Item C:\Temp\Profile4.xml
        }

        Invoke-Command -ComputerName $computer.Name -ScriptBlock {
        #This lists the profiles to verify that they were imported correctly.
        netsh wlan show profiles
        }
    }
}
