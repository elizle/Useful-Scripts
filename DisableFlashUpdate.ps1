param([Parameter(Mandatory=$True)][string]$hostname)

#Flash Auto Update Disabler/Enabler
#By: Eli Ratcliff
#Last edited 4/28/2014

#get system architecture
$arch = getArchitecture -hostname $hostname

if($arch -eq "64-bit"){$filepath="SysWOW64"}
else{$filepath="System32"}

$path="\\$hostname\c$\Windows\$filepath\Macromed\Flash\mms.cfg"

if(Test-Connection -Quiet -Count 1 -ComputerName $hostname)
{
    if($hostname -eq $env:COMPUTERNAME){$path="C:\Windows\System32\Macromed\Flash\mms.cfg"}
    if(Test-Path -Path $path)
    {
        cls
        $flashUpdate = Read-Host "Enable or Disable Flash auto updates? (E/D)"
        if($flashUpdate -eq "E")
        {
            #Enable Flash Auto Updates
            Get-Content $path | % { $_ -replace "AutoUpdateDisable=1","AutoUpdateDisable=0" } > "$path.new"
            Remove-Item $path
            Rename-Item "$path.new" $path

            Write-Host "Flash updates enabled"
        }


        if($flashUpdate -eq "D")
        {
            #Disable Flash Auto Updates
            Get-Content $path | % { $_ -replace "AutoUpdateDisable=0","AutoUpdateDisable=1" } > "$path.new"
            Remove-Item $path
            Rename-Item "$path.new" $path
            Write-Host "Flash updates disabled"
        }
    }#end test-path
    else{Write-Warning "mms.cfg Not Found!"}
}#end if(conn)
else{Write-Warning "Could not connect to $hostname"}

pause

