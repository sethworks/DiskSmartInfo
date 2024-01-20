$Script:Config = Import-PowerShellDataFile -Path (Join-Path -Path $PSScriptRoot -ChildPath .\DiskSmartInfo.config.psd1)

Export-ModuleMember -Function 'Get-DiskSmartInfo', 'Get-DiskSmartAttributeDescription'