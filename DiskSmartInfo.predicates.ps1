function isCritical
{
    Param (
        [int]$AttributeID
    )

    if ($smartAttributes.Where{$_.AttributeID -eq $AttributeID}.IsCritical)
    {
        return $true
    }
    else
    {
        return $false
    }
}

function isRequested
{
    Param (
        [int]$AttributeID
    )

    if (!$attributeIDs -or $AttributeIDs -contains $AttributeID)
    {
        return $true
    }
    else
    {
        return $false
    }
}

function isThresholdReached
{
    Param (
        [System.Collections.Specialized.OrderedDictionary]$Attribute
    )

    if ($Attribute.Value -le $Attribute.Threshold)
    {
        return $true
    }
    else
    {
        return $false
    }
}
