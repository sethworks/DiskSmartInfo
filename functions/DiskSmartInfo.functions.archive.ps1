function inUpdateArchive
{
    Param (
        $hostSmartData
    )

    $archiveData = [System.Collections.Generic.List[PSCustomObject]]::new()
    $dateTime = Get-Date

    foreach ($diskSmartData in $hostSmartData.DisksSmartData)
    {
        $hash = [ordered]@{}
        $hash.Add('ComputerName', [string]$hostSmartData.ComputerName)
        $hash.Add('DiskNumber', [uint32]$diskSmartData.DiskNumber)
        $hash.Add('DiskModel', [string]$diskSmartData.DiskModel)
        $hash.Add('PNPDeviceId', [string]$diskSmartData.PNPDeviceID)
        $hash.Add('PredictFailure', [bool]$diskSmartData.PredictFailure)
        $hash.Add('ArchiveDate', [datetime]$dateTime)

        $attributes = @()

        foreach ($attributeSmartData in $diskSmartData.SmartData)
        {
            $attribute = [ordered]@{}
            $attribute.Add('ID', $attributeSmartData.ID)
            $attribute.Add('IDHex', $attributeSmartData.IDHex)
            $attribute.Add('Name', $attributeSmartData.Name)
            $attribute.Add('Threshold', $attributeSmartData.Threshold)
            $attribute.Add('Value', $attributeSmartData.Value)
            $attribute.Add('Worst', $attributeSmartData.Worst)
            $attribute.Add('Data', $attributeSmartData.Data)
            $attributes += [PSCustomObject]$attribute
        }

        if ($attributes)
        {
            $hash.Add("SmartData", $attributes)
            $archiveData.Add([PSCustomObject]$hash)
        }
    }

    if ($archiveData.Count)
    {
        # $dateTime = Get-Date
        # $fullname = inComposeArchiveDataFileName -computerName $hostSmartData.computerName
        $fullname = inComposeArchiveDataFileName -computerName $hostSmartData.computerName -dateTime $dateTime

        # $hostArchiveData = @{
            # TimeStamp = Get-Date
            # TimeStamp = $dateTime
            # ArchiveData = $archiveData
        # }

        inEnsureFolderExists -folder (Split-Path -Path $fullname -Parent)

        # Set-Content -Path $fullname -Value (ConvertTo-Json -InputObject $hostArchiveData -Depth 5)
        Set-Content -Path $fullname -Value (ConvertTo-Json -InputObject $archiveData -Depth 5)
    }
}

function inComposeArchiveDataFileName
{
    Param (
        [string]$computerName,
        [datetime]$dateTime
    )

    if ($computerName)
    {
        $hostfolder = $computerName
        # $filename = "$computerName.json"
        # $filename = "$computerName$((Get-Date).ToString('_yyyy-MM-dd_HH-mm-ss')).json"
        $filename = "$computerName$($dateTime.ToString('_yyyy-MM-dd_HH-mm-ss')).json"
    }
    else
    {
        $hostfolder = 'localhost'
        # $filename = 'localhost.json'
        # $filename = "localhost$((Get-Date).ToString('_yyyy-MM-dd_HH-mm-ss')).json"
        $filename = "localhost$($dateTime.ToString('_yyyy-MM-dd_HH-mm-ss')).json"
    }

    if ($IsCoreCLR)
    {
        if ([System.IO.Path]::IsPathFullyQualified($Config.ArchivePath))
        {
            $folder = $Config.ArchivePath
        }
        else
        {
            $folder = Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath $Config.ArchivePath
        }
    }
    # .NET Framework version 4 and lower does not have [System.IO.Path]::IsPathFullyQualified method
    else
    {
        $pathroot = [System.IO.Path]::GetPathRoot($Config.ArchivePath)

        # not '\folder' or 'c:folder'
        if ($pathroot -and $pathroot -ne '\' -and $pathroot -notlike "?:")
        {
            $folder = $Config.ArchivePath
        }
        else
        {
            $folder = Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath $Config.ArchivePath
        }
    }

    $folder = Join-Path -Path $folder -ChildPath $hostfolder
    $fullname = Join-Path -Path $folder -ChildPath $filename

    return $fullname
}
