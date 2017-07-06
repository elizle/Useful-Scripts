#Uninstall .NET 3.5 with DISM.
Start-Process Dism.exe -ArgumentList '/online /disable-feature /FeatureName:NetFx3' -Wait

#Wait 5 seconds
Start-Sleep -Seconds 5

<#This uses DISM to reinstall .NET 3.5. You will have to copy the sxs folder
from the Windows 10 install media to local or network folder.
Replace \\FileServer\sxs with the location of the sxs folder.
Also, you will need the x86 disk for 32-bit and x64 for 64-bit#>
Start-Process Dism.exe -ArgumentList '/online /enable-feature /featurename:NetFX3 /All /Source:\\FileServer\sxs /LimitAccess' -Wait
