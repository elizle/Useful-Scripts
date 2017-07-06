<#The script finds all of the MAC addresses of the Wireless Adapters that belong
#to laptops on the Domain. The original purpose of this was to determine the
MAC addresses that should be on the network so we would have a better idea of
which MAC addresses should be whitelisted when turning on MAC filtering.#>

#This makes sure the variables $test and $wifi are empty.
$test = ''
$wifi = ''

#This gets a list of all laptops on the domain.
$laptops = Get-ADComputer -Filter * | Where-Object {$_.DistinguishedName -like "*Laptop*"}

#This defines that $maclist is an array.
$maclist = @()

#This tries to delete the previous list of computers not on the network.
Remove-Item $env:USERPROFILE\Desktop\MACListNotConnected.csv -ErrorAction SilentlyContinue


#Loops through all of the laptops in the list.
foreach($laptop in $laptops)
{
    #This tries to ping a computer in the loop, then stores the results in a variable.
    try
    {
        Write-Host -ForegroundColor Yellow "Getting MAC address of $($laptop.Name)"
        $test = Test-Connection $laptop.Name -Count 2 -ErrorAction Stop
    }
    #If the computer isn't able to ping, it adds it to a CSV.
    catch
    {
        Write-Host "$($laptop.Name) not connected" -ForegroundColor Red
        $laptop.Name | Export-Csv $env:USERPROFILE\Desktop\MACListNotConnected.csv -Append
    }
    #If the ping was successful, the script finds the MAC address of the wireless adapter.
    if($test)
    {
        $wifi = Get-WmiObject -ComputerName $laptop.Name win32_networkadapter | Where-Object {$_.Name -Like "*WiFi*" -or $_.Name -like "*Wi-fi*" -or $_.Name -like "*Wireless*" -or $_.Name -like "*Centrino*" -or $_.Name -like "*802.11n" -and $_.Name -notlike "*Virtual*"}
        #This is a loop to remove dummy network devices without a MAC address.
        foreach($wi in $wifi)
        {
            if($wi.MACAddress)
            {
                $properties = @{'Computer Name'=$wi.PSComputerName; 'Adapter Name'=$wi.Name; 'MAC Address'=$wi.MACAddress}
                $NewObject = New-Object PSObject -Property $properties
                $maclist += $NewObject
            }

        }
    }
    #This makes the $test variable empty again.
    $test = ''
}
#This exports the list to a CSV file.
$maclist | Export-Csv $env:USERPROFILE\Desktop\MACAddresses.csv
