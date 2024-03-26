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
        $session
    )

    if ($session)
    {
        $filename = "$($session.ComputerName).txt"
    }
    else
    {
        $filename = 'localhost.txt'
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
