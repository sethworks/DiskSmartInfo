function inUpdateActualAttributesList
{
    Param (
        [string]$model
    )

    $result = [System.Collections.Generic.List[PSCustomObject]]::new($defaultAttributes)

    foreach ($proprietary in $proprietaryAttributes)
    {
        $patternMatched = $false
        foreach ($modelPattern in $proprietary.ModelPatterns)
        {
            if ($model -match $modelPattern)
            {
                $patternMatched = $true
                break
            }
        }

        if ($patternMatched)
        {
            foreach ($attribute in $proprietary.Attributes)
            {
                if (($index = $result.FindIndex([Predicate[PSCustomObject]]{$args[0].AttributeID -eq $attribute.AttributeID})) -ge 0)
                {
                    $newAttribute = [ordered]@{
                        AttributeID = $attribute.AttributeID
                        AttributeName = $attribute.AttributeName
                        DataFormat = $attribute.DataFormat
                        IsCritical = $result[$index].IsCritical
                        CriticalThreshold = $result[$index].CriticalThreshold
                        ConvertScriptBlock = $result[$index].ConvertScriptBlock
                    }

                    if ($attribute.Keys -contains 'IsCritical')
                    {
                        $newAttribute.IsCritical = $attribute.IsCritical
                    }
                    if ($attribute.Keys -contains 'CriticalThreshold')
                    {
                        $newAttribute.CriticalThreshold = $attribute.CriticalThreshold
                    }
                    if ($attribute.Keys -contains 'ConvertScriptBlock')
                    {
                        $newAttribute.ConvertScriptBlock = $attribute.ConvertScriptBlock
                    }

                    $result[$index] = [PSCustomObject]$newAttribute
                }
                else
                {
                    $result.Add([PSCustomObject]$attribute)
                }
            }
            break
        }
    }

    return $result
}

function inGetAttributeData
{
    Param(
        $actualAttributesList,
        $smartData,
        $attributeStart
    )

    $df = $actualAttributesList.Where{$_.AttributeID -eq $smartData[$attributeStart]}.DataFormat

    switch ($df.value__)
    {
        $([AttributeDataFormat]::bits48.value__)
        {
            return inExtractAttributeData -smartData $smartData -startOffset ($attributeStart + 5) -byteCount 6
        }

        $([AttributeDataFormat]::bits24.value__)
        {
            return inExtractAttributeData -smartData $smartData -startOffset ($attributeStart + 5) -byteCount 3
        }

        $([AttributeDataFormat]::bits16.value__)
        {
            return inExtractAttributeData -smartData $smartData -startOffset ($attributeStart + 5) -byteCount 2
        }

        $([AttributeDataFormat]::temperature3.value__)
        {
            return inExtractAttributeTemps -smartData $smartData -startOffset ($attributeStart + 5)
        }

        $([AttributeDataFormat]::bytes1032.value__)
        {
            return inExtractAttributeWords -smartData $smartData -startOffset ($attributeStart + 5) -words 0, 1
        }

        $([AttributeDataFormat]::bytes5410.value__)
        {
            return inExtractAttributeWords -smartData $smartData -startOffset ($attributeStart + 5) -words 2, 0
        }

        default
        {
            return inExtractAttributeData -smartData $smartData -startOffset ($attributeStart + 5) -byteCount 6
        }
    }
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

function inConvertData
{
    Param(
        $actualAttributesList,
        $attribute
    )

    if ($convertScriptBlock = $actualAttributesList.Where{$_.AttributeID -eq $attribute.ID}.ConvertScriptBlock)
    {
        return $convertScriptBlock.Invoke($attribute.Data)
    }
    else
    {
        return $null
    }
}
