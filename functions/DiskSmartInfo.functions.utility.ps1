function inComposeAttributeIDs
{
    Param (
        [int[]]$AttributeID,
        [string[]]$AttributeIDHex,
        [string[]]$AttributeName,
        [switch]$IsDescription
        )

    $attributeIDs = [System.Collections.Generic.List[int]]::new()

    foreach ($at in $AttributeID)
    {
        if (-not $attributeIDs.Contains($at))
        {
            $attributeIDs.Add($at)
        }
    }

    foreach ($at in $AttributeIDHex)
    {
        $value = [convert]::ToInt32($at, 16)
        if (-not $attributeIDs.Contains($value))
        {
            $attributeIDs.Add($value)
        }
    }

    return $attributeIDs
}

function inTrimDiskDriveModel
{
    Param (
        $Model
    )

    $trimStrings = @(' ATA Device', ' SCSI Disk Device')

    if ($Script:Config.TrimDiskDriveModelSuffix)
    {
        foreach ($ts in $trimStrings)
        {
            if ($Model.EndsWith($ts))
            {
                return $Model.Remove($Model.LastIndexOf($ts))
            }
        }
    }

    return $Model
}

function inComposeHistoricalDataFileName
{
    Param (
        # $session
        [string]$computerName
    )

    # if ($session)
    if ($computerName)
    {
        # $filename = "$($session.ComputerName).json"
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
            $filepath = $Config.DataHistoryPath
        }
        else
        {
            $filepath = Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath $Config.DataHistoryPath
        }
    }
    # .NET Framework version 4 and lower does not have [System.IO.Path]::IsPathFullyQualified method
    else
    {
        $pathroot = [System.IO.Path]::GetPathRoot($Config.DataHistoryPath)
        if ($pathroot -and $pathroot[-1] -eq '\')
        {
            $filepath = $Config.DataHistoryPath
        }
        else
        {
            $filepath = Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath $Config.DataHistoryPath
        }
    }

    if (-not (Test-Path -Path $filepath))
    {
        New-Item -ItemType Directory -Path $filepath | Out-Null
    }

    $fullname = Join-Path -Path $filepath -ChildPath $filename

    return $fullname
}

function inCompareAttributeData
{
    Param (
        $attributeData,
        $historicalAttributeData
    )

    if ($attributeData.Count -eq $historicalAttributeData.Count)
    {
        if ($attributeData.Count -eq 1)
        {
            return $attributeData -eq $historicalAttributeData
        }
        elseif ($attributeData.Count -gt 1)
        {
            for ($i = 0; $i -lt $attributeData.Count; $i++)
            {
                if ($attributeData[$i] -ne $historicalAttributeData[$i])
                {
                    return $false
                }
            }
            return $true
        }
    }
    return $false
}

function inExtractAttributeData
{
    Param (
        $smartData,
        $startOffset,
        $byteCount
    )

    [long]$result = 0

    for ($offset = 0; $offset -lt $byteCount; $offset++)
    {
        $result += $smartData[$startOffset + $offset] * ( [math]::Pow(256, $offset) )
    }

    return $result
}

function inExtractAttributeTemps
{
    Param (
        $smartData,
        $a
    )

    $temps = @([long]$smartData[$a + 5])

    for ($offset = 6; $offset -le 10; $offset++)
    {
        if ($smartData[$a + $offset] -ne 0 -and $smartData[$a + $offset] -ne 255)
        {
            $temps += [long]$smartData[$a + $offset]
        }

        if ($temps.Count -eq 3)
        {
            if ($temps[1] -gt $temps[2])
            {
                $t = $temps[1]
                $temps[1] = $temps[2]
                $temps[2] = $t
            }
            break
        }
    }

    return $temps
}
