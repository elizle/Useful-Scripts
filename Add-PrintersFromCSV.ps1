<#This script adds printers from a CSV file.
To create a csv, run "Get-Printer | Export-csv c:\temp\printers.csv" on
a computer that already has the printers added.#>

param($printerlist = "c:\temp\printers.csv")


#Imports Printer List
$printers = Import-Csv $printerlist

#Sets value of $i to 0
$i=0

foreach($printer in $printers)
{
#Increases variable to be used to find percentage of progress
$i++

#Writes percentage of progressed by using the variable $i divided by the total amount of printers
Write-Progress "Installing Printer $($printer.Name)" -PercentComplete (($i / $printers.Count)*100)

#Creates port for printer
Add-PrinterPort -Name $printer.PortName -PrinterHostAddress $printer.PortName

#Adds printer
Add-Printer -DriverName $printer.DriverName -Name $printer.Name -PortName $printer.PortName -Shared:$true -ShareName $printer.ShareName
}


Get-Printer | Select-Object Name,DriverName,PortName,Shared,ShareName | Format-Table

Write-Host "Finished Installing Printers"
