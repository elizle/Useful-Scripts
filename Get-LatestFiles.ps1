#Replace C:\Users with the path of a folder you would frequently scan.
#Otherwise, you can call the script name and specify the folder using:
#Get-LatestFiles.ps1 -folder 'Folder You Want To Scan'
param($folder = 'c:\users')

#This brings up the .NET Date and Time selection. Select the date and close it.
[datetime] $DT = DateTimePicker
#This will find all files newer than the date you selected and display it in Gridview.
Get-ChildItem -Recurse -Force -ErrorAction SilentlyContinue -path $folder | where {!$_.psiscontainer} | where {$_.LastWriteTime -gt $dt} | select name, creationTime, LastWriteTime, LastAccessTime, Length, FullName | Sort-Object -Property Length -Descending | out-gridview
