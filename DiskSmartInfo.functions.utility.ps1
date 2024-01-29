function inComposeAttributeIDs
{
    Param (
        [int[]]$AttributeID,
        [string[]]$AttributeIDHex,
        [string[]]$AttributeName
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

    foreach ($at in $AttributeName)
    {
        if ($value = $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeName -eq $at}))
        {
            if (-not $attributeIDs.Contains($value.AttributeID))
            {
                $attributeIDs.Add($value.AttributeID)
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
