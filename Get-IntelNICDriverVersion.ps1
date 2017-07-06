<#Gets a list of computers from a CSV file.
The CSV originally used was created by a Spiceworks report which had a list of all of the
computers with an Intel 82579lm NIC. There was a specific driver version that
was causing random disconnects on a computers. This was created to help identify
which computers potentially had the issue.
The Name column of the CSV should have a list of computer names.#>
$computerlist = Import-Csv #NAMEANDPATHOFCSV


#This gets the driver version from all computers in the arrary, filters out only the devices that are like 82579LM
Get-WmiObject -ComputerName $computerlist.Name -Class win32_PnPSignedDriver -Filter "Description LIKE '%82579LM%'" |
#This selects the properties that we need and exports them to the desktop.
Select-Object PSComputerName, DeviceName, DriverDate, DriverVersion, InfName, Manufacturer, Signer | Export-Csv $env:USERPROFILE\desktop\Drivers.csv
