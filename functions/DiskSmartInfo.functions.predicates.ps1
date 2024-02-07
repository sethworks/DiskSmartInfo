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

function isAttributeRequested
{
    Param (
        [int]$AttributeID
    )

    if (-not $attributeIDs.Count -or $AttributeIDs -contains $AttributeID)
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