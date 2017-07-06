#This script removes bloatware preinstalled on HP computers.
#It also finds toolbars and Apple products and attempts to remove them.
#It will show you a list that you can select what you would like to remove,
#that way you are able to leave certain HP drivers that it would remove.

#This tests the powershell version to make sure it is 3.0 or newer.
if(($PSVersionTable.PSVersion).Major -lt 3)
{
    Write-Host -ForegroundColor Yellow "This script requires PowerShell 3.0 or higher"
    Start-Sleep -s 5
    break
}

#Changes directory to System32, this fixed issues I was having with MsiExec
Set-Location "C:\Windows\System32"

#This creates a list of programs to uninstall
$programList = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall,
HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall  -ErrorAction SilentlyContinue |
    Get-ItemProperty |
    Where-Object {$_.Publisher -match "Hewlett-Packard" -or $_.Publisher -match "Cyberlink" -or $_.Publisher -match "WinZip" -or $_.Publisher -match "PDF Complete" -or $_.DisplayName -eq "Microsoft Office" -or $_.Publisher -match "Apple" -or $_.DirectoryName -contains "Toolbar" -or $_.Publisher -match "Roxio" } |
    Select-Object -Property DisplayName, UninstallString, DisplayVersion
    [array]$uninstall = $programList | Select DisplayName, UninstallString, DisplayVersion |Out-GridView -Title "Select applications to uninstall" -OutputMode Multiple

    foreach($program in $uninstall)
    {
        #This tries to uninstall programs installed with MSI Installers
        if($program.UninstallString -match "MsiExec")
        {
            if($program.UninstallString -match "/I")
                {
                    $program.UninstallString = ($program.UninstallString).Replace("/I", "/X")
                }

            & cmd /c $program.UninstallString /quiet /norestart
        }
        #This uninstalls programs installed with InstallShield installers.
        if($program.UninstallString -match "InstallShield")
        {
            if($program.UninstallString -match "-runfromtemp -l0x0409 -removeonly")
                {
                    $program.UninstallString = ($program.UninstallString).Replace("-runfromtemp -l0x0409 -removeonly", "/z-uninstall ")
                }

            & cmd /c $program.UninstallString /x /s /v/qn

        }
        #This uninstalls PDF Complete.
        if($program.UninstallString -match "PDF")
            {
                & cmd /c $program.UninstallString
            }
    }

<#This attempts to uninstall HP ProtectTools again because it requires all
ProtectTools components to be removed first. #>
if($uninstall.displayname -contains "HP ProtectTools Security Manager")
{
    & cmd /c $uninstall[$Uninstall.DisplayName.IndexOf("HP ProtectTools Security Manager")].UninstallString /passive /norestart
}
