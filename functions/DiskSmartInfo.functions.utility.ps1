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
        $startOffset
    )

    $temps = @([long]$smartData[$startOffset])

    for ($offset = 1; $offset -le 5; $offset++)
    {
        if ($smartData[$startOffset + $offset] -ne 0 -and $smartData[$startOffset + $offset] -ne 255)
        {
            $temps += [long]$smartData[$startOffset + $offset]
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

    return $result
}

function inSelectAttributeProperties
{
    Param (
        $attributes,
        [AttributeProperty[]]$properties,
        $formatScriptBlock
    )

    $result = @()

    foreach ($attribute in $attributes)
    {
        $attributeSelected = [ordered]@{}
        foreach ($property in $properties)
        {
            switch ($property.value__)
            {
                ([AttributeProperty]::AttributeName.value__)
                {
                    $attributeSelected.Add('Name', $attribute.Name)
                    break
                }
                ([AttributeProperty]::History.value__)
                {
                    $attributeSelected.Add('DataHistory', $attribute.DataHistory)
                    break
                }
                ([AttributeProperty]::Converted.value__)
                {
                    $attributeSelected.Add('DataConverted', $attribute.DataConverted)
                    break
                }
                default
                {
                    $attributeSelected.Add($property, $attribute.$property)
                }
            }
        }

        $attributeObject = [PSCustomObject]$attributeSelected
        $attributeObject | Add-Member -TypeName "DiskSmartAttributeCustom"
        $attributeObject | Add-Member -MemberType ScriptMethod -Name FormatTable -Value $formatScriptBlock

        $result += $attributeObject
    }

    return $result
}
