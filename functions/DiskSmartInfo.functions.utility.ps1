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

# function inExtractAttributeBytes1054
function inExtractAttributeWords
{
    Param (
        $smartData,
        $startOffset,
        $words
    )

    $result = @()

    foreach ($word in $words)
    {
        $result += [long]($smartData[$startOffset + $word * 2] + $smartData[$startOffset + $word * 2 + 1] * 256)
    }

    # $result += @([long]($smartData[$startOffset] + $smartData[$startOffset + 1] * 256))
    # $result += [long]($smartData[$startOffset + 4] + $smartData[$startOffset + 5] * 256)

    return $result
}
