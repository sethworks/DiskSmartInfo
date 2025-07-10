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

function isAttributeRequested
{
    Param (
        [int]$attributeID,
        [PSCustomObject[]]$actualAttributesList
    )

    $atName = $actualAttributesList.Where{$PSItem.AttributeID -eq $attributeID}.AttributeName

    if ((-not $attributeIDs.Count -and -not $AttributeName.Count) -or
        ($attributeIDs -contains $attributeID) -or
        ($AttributeName.Where{$atName -like $PSItem}))
    {
        return $true
    }
    else
    {
        return $false
    }
}

function isThresholdExceeded
{
    Param (
        [System.Collections.Specialized.OrderedDictionary]$Attribute
    )

    if ($Attribute.Value -lt $Attribute.Threshold)
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
