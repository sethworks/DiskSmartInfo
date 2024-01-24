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

    if (!$attributeIDs.Count -or $AttributeIDs -contains $AttributeID)
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

    # if (!$DiskNumbers.Count -or $DiskNumbers -contains $Index)
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

    # if ($DiskModels.Count)
    # {
        foreach ($dm in $DiskModels)
        {
            if ($Model -like $dm)
            {
                return $true
            }
        }
        return $false
    # }
    # else
    # {
        # return $true
    # }
}
