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
        # [int]$AttributeID
        [int]$attributeID,
        [PSCustomObject[]]$attributeSet
        # [string[]]$attributeNames
    )

    # if ((-not $attributeIDs.Count -and -not $AttributeName.Count) -or
    #     ($attributeIDs.Count -and $attributeIDs -contains $attributeID) -or
    #     ($AttributeName.Count -and
    #         (($AttributeName |
    #             ForEach-Object -Process {
    #                 # $smartAttributes.Where{$PSItem.AttributeID -eq $AttributeID}.AttributeName -like $PSItem}) -contains $true
    #                 $attributeSet.Where{$PSItem.AttributeID -eq $attributeID}.AttributeName -like $PSItem}) -contains $true
    #     ) ) )
    if ((-not $attributeIDs.Count -and -not $AttributeName.Count) -or
        ($attributeIDs.Count -and $attributeIDs -contains $attributeID) -or
        ($AttributeName.Count -and $AttributeName.Where{$attributeSet.Where{$PSItem.AttributeID -eq $attributeID}.AttributeName -like $PSItem}
        ))
    {
        return $true
    }
    else
    {
        return $false
    }
    # if (-not $attributeIDs.Count -or $AttributeIDs -contains $AttributeID)
    # {
    #     return $true
    # }
    # else
    # {
    #     return $false
    # }
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
