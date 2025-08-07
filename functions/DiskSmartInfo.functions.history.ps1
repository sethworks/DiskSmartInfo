function inUpdateHistoricalData
{
    Param (
        $hostSmartData
    )

    $historicalData = [System.Collections.Generic.List[PSCustomObject]]::new()

    foreach ($diskSmartData in $hostSmartData.DisksSmartData)
    {
        $hash = [ordered]@{}
        $hash.Add('Device', $diskSmartData.Device)
        $hash.Add('DiskType', $diskSmartData.DiskType)

        $attributes = @()

        if ($hash.DiskType -eq 'ATA')
        {
            foreach ($attributeSmartData in $diskSmartData.SmartData)
            {
                $attribute = [ordered]@{}
                $attribute.Add('ID', $attributeSmartData.ID)
                $attribute.Add('Data', $attributeSmartData.Data)
                $attributes += [PSCustomObject]$attribute
            }
        }
        elseif ($hash.DiskType -eq 'NVMe')
        {
            foreach ($attributeSmartData in $diskSmartData.SmartData)
            {
                $attribute = [ordered]@{}
                $attribute.Add('Name', $attributeSmartData.Name)
                $attribute.Add('Data', $attributeSmartData.Data)
                $attributes += [PSCustomObject]$attribute
            }
        }

        if ($attributes)
        {
            $hash.Add("SmartData", $attributes)
            $historicalData.Add([PSCustomObject]$hash)
        }
    }

    if ($historicalData.Count)
    {
        $fullname = inGetHistoricalDataFileName -computerName $hostSmartData.computerName

        $hostHistoricalData = @{
            TimeStamp = Get-Date
            HistoricalData = $historicalData
        }

        inEnsureFolderExists -folder (Split-Path -Path $fullname -Parent)

        Set-Content -Path $fullname -Value (ConvertTo-Json -InputObject $hostHistoricalData -Depth 5)
    }
}

function inGetHistoricalData
{
    Param (
        $computerName
    )

    $fullname = inGetHistoricalDataFileName -computerName $computerName

    # if ($content = Get-Content -Path $fullname -Raw -ErrorAction SilentlyContinue)
    if ($historicalDataFileContent = Get-Content -Path $fullname -Raw -ErrorAction SilentlyContinue)
    {
        # $converted = ConvertFrom-Json -InputObject $content
        $sourceHostHistoricalData = ConvertFrom-Json -InputObject $historicalDataFileContent

        if ($IsCoreCLR)
        {
            # $timestamp = $converted.TimeStamp
            $timestamp = $sourceHostHistoricalData.TimeStamp
        }
        # Windows PowerShell 5.1 ConvertTo-Json converts DateTime objects differently
        else
        {
            # $timestamp = $converted.TimeStamp.DateTime
            $timestamp = $sourceHostHistoricalData.TimeStamp.DateTime
        }

        $hostHistoricalData = @{
            TimeStamp = [datetime]$timestamp
            HistoricalData = @()
        }

        # foreach ($object in $converted.HistoricalData)
        foreach ($sourceDiskHistoricalData in $sourceHostHistoricalData.HistoricalData)
        {
            $hash = [ordered]@{}
            $attributes = @()

            # $hash.Add('Device', [string]$object.Device)
            $hash.Add('Device', [string]$sourceDiskHistoricalData.Device)

            # if ($object.DiskType -eq 'ATA')
            if ($sourceDiskHistoricalData.DiskType -eq 'ATA')
            {
                # foreach ($at in $object.SmartData)
                foreach ($sourceAttribute in $sourceDiskHistoricalData.SmartData)
                {
                    $attribute = [ordered]@{}
                    # $attribute.Add('ID', [byte]$at.ID)
                    $attribute.Add('ID', [byte]$sourceAttribute.ID)

                    # if ($at.Data.Count -gt 1)
                    if ($sourceAttribute.Data.Count -gt 1)
                    {
                        # $attribute.Add('Data', [long[]]$at.Data)
                        $attribute.Add('Data', [long[]]$sourceAttribute.Data)
                    }
                    else
                    {
                        # $attribute.Add('Data', [long]$at.Data)
                        $attribute.Add('Data', [long]$sourceAttribute.Data)
                    }

                    $attributes += [PSCustomObject]$attribute
                }
            }
            # elseif ($object.DiskType -eq 'NVMe')
            elseif ($sourceDiskHistoricalData.DiskType -eq 'NVMe')
            {
                # foreach ($at in $object.SmartData)
                foreach ($sourceAttribute in $sourceDiskHistoricalData.SmartData)
                {
                    $attribute = [ordered]@{}
                    # $attribute.Add('Name', [string]$at.Name)
                    $attribute.Add('Name', [string]$sourceAttribute.Name)
                    # $attribute.Add('Data', [string]$at.Data)
                    $attribute.Add('Data', [string]$sourceAttribute.Data)
                    $attributes += [PSCustomObject]$attribute
                }
            }

            $hash.Add('SmartData', $attributes)
            $hostHistoricalData.HistoricalData += [PSCustomObject]$hash
        }

        return $hostHistoricalData
    }
}

function inGetAttributeHistoricalData
{
    Param (
        $diskHistoricalData,
        $attribute,
        $diskType
    )

    if ($diskType -eq 'ATA')
    {
        $attributeHistoricalData = $diskHistoricalData.Where{$_.ID -eq $attribute.ID}.Data
    }
    elseif ($diskType -eq 'NVMe')
    {
        $attributeHistoricalData = $diskHistoricalData.Where{$_.Name -eq $attribute.Name}.Data
    }

    if ($Config.ShowUnchangedDataHistory -or
        (-not (isAttributeDataEqual -attributeData $attribute.Data -attributeHistoricalData $attributeHistoricalData)))
    {
        return $attributeHistoricalData
    }
    else
    {
        return $null
    }
}

function inGetHistoricalDataFileName
{
    Param (
        [string]$computerName
    )

    if ($computerName)
    {
        $filename = "$computerName.json"
    }
    else
    {
        $filename = 'localhost.json'
    }

    if ($IsCoreCLR)
    {
        if ([System.IO.Path]::IsPathFullyQualified($Config.DataHistoryPath))
        {
            $folder = $Config.DataHistoryPath
        }
        else
        {
            $folder = Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath $Config.DataHistoryPath
        }
    }
    # .NET Framework version 4 and lower does not have [System.IO.Path]::IsPathFullyQualified method
    else
    {
        $pathroot = [System.IO.Path]::GetPathRoot($Config.DataHistoryPath)

        # not '\folder' or 'c:folder'
        if ($pathroot -and $pathroot -ne '\' -and $pathroot -notlike "?:")
        {
            $folder = $Config.DataHistoryPath
        }
        else
        {
            $folder = Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath $Config.DataHistoryPath
        }
    }

    $fullname = Join-Path -Path $folder -ChildPath $filename

    return $fullname
}
