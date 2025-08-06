function isAttributeDataEqual
{
    Param (
        $attributeData,
        $attributeHistoricalData
    )

    if ($attributeData.Count -eq $attributeHistoricalData.Count)
    {
        if ($attributeData.Count -eq 1)
        {
            return $attributeData -eq $attributeHistoricalData
        }
        elseif ($attributeData.Count -gt 1)
        {
            for ($i = 0; $i -lt $attributeData.Count; $i++)
            {
                if ($attributeData[$i] -ne $attributeHistoricalData[$i])
                {
                    return $false
                }
            }
            return $true
        }
    }
    return $false
}

function isAttributeRequested
{
    Param (
        [hashtable[]]$RequestedAttributes,
        [System.Collections.Specialized.OrderedDictionary]$attributeSmartData,
        [string]$diskType
    )

    if ($diskType -eq 'ATA')
    {
        if ((-not ($RequestedAttributes.AttributeIDs -or $RequestedAttributes.AttributeIDHexes -or $RequestedAttributes.AttributeNames)) -or
            ($RequestedAttributes.AttributeIDs -contains $attributeSmartData.ID) -or
            ($RequestedAttributes.AttributeIDHexes -contains $attributeSmartData.IDHex) -or
            ($RequestedAttributes.AttributeNames.Where{$attributeSmartData.Name -like $PSItem}))
        {
            return $true
        }
        else
        {
            return $false
        }
    }

    elseif ($diskType -eq 'NVMe')
    {
        if ((-not $RequestedAttributes.AttributeNames) -or
            ($RequestedAttributes.AttributeNames.Where{$attributeSmartData.Name -like $PSItem}))
        {
            return $true
        }
        else
        {
            return $false
        }
    }
}

function isCritical
{
    Param (
        [int]$AttributeID
    )

    if ($actualAttributesList.Where{$_.AttributeID -eq $AttributeID}.IsCritical)
    {
        return $true
    }
    else
    {
        return $false
    }
}

function isCriticalThresholdExceeded
{
    Param (
        [int]$AttributeID,
        $AttributeData
    )

    if ((isCritical -AttributeID $AttributeID) -and
        ($AttributeData -gt $actualAttributesList.Where{$_.AttributeID -eq $AttributeID}.CriticalThreshold))
    {
        return $true
    }
    else
    {
        return $false
    }
}

function isValueThresholdExceeded
{
    Param (
        $Value,
        $Threshold
    )

    if ($Value -lt $Threshold)
    {
        return $true
    }
    else
    {
        return $false
    }
}

function isDiskNumberMatched
{
    Param (
        [int]$Index
    )

    if ($DiskNumbers -contains $Index)
    {
        return $true
    }
    else
    {
        return $false
    }
}

function isDiskModelMatched
{
    Param (
        [string]$Model
    )

    foreach ($dm in $DiskModels)
    {
        if ($Model -like $dm)
        {
            return $true
        }
    }
    return $false
}

function isDeviceMatched
{
    Param (
        [string]$Device
    )

    foreach ($de in $Devices)
    {
        if ($Device -like $de)
        {
            return $true
        }
    }
    return $false
}
