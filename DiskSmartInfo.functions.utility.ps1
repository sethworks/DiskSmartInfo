function inComposeAttributeIDs
{
    Param (
        [int[]]$AttributeID,
        [string[]]$AttributeIDHex,
        [string[]]$AttributeName
        )

    $attributeIDs = @()

    foreach ($at in $AttributeID)
    {
        if ($attributeIDs -notcontains $at)
        {
            $attributeIDs += $at
        }
    }

    foreach ($at in $AttributeIDHex)
    {
        $value = [convert]::ToInt32($at, 16)
        if ($attributeIDs -notcontains $value)
        {
            $attributeIDs += $value
        }
    }

    foreach ($at in $AttributeName)
    {
        if ($value = $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeName -eq $at}))
        {
            if ($attributeIDs -notcontains $value.AttributeID)
            {
                $attributeIDs += $value.AttributeID
            }
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

    if ($Script:Config.TrimDiskDriveModel)
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
        if ([System.IO.Path]::IsPathFullyQualified($Config.HistoricalDataPath))
        {
            $filepath = $Config.HistoricalDataPath
        }
        else
        {
            $filepath = Join-Path -Path $PSScriptRoot -ChildPath $Config.HistoricalDataPath
        }
    }
    # .NET Framework version 4 and lower does not have [System.IO.Path]::IsPathFullyQualified method
    else
    {
        $pathroot = [System.IO.Path]::GetPathRoot($Config.HistoricalDataPath)
        if ($pathroot -and $pathroot[-1] -eq '\')
        {
            $filepath = $Config.HistoricalDataPath
        }
        else
        {
            $filepath = Join-Path -Path $PSScriptRoot -ChildPath $Config.HistoricalDataPath
        }
    }

    if (!(Test-Path -Path $filepath))
    {
        New-Item -ItemType Directory -Path $filepath | Out-Null
    }

    $fullname = Join-Path -Path $filepath -ChildPath $filename

    return $fullname
}
