function Get-DiskSmartAttributeDescription
{
    Param(
        [Parameter(Position=0)]
        [ValidateRange(1, 255)]
        [int[]]$AttributeID,
        [Parameter(Position=1)]
        [ValidatePattern("^(0?[1-9A-F])|([1-9A-F])([0-9A-F])$")]
        [string[]]$AttributeIDHex,
        [Parameter(Position=2)]
        [ArgumentCompleter([AttributeNameCompleter])]
        [string[]]$AttributeName
    )

    # $RequestedAttributes = @{AttributeIDs=$AttributeID; AttributeIDHexes=$AttributeIDHex; AttributeNames=$AttributeName}

    foreach ($attribute in $descriptions)
    {
        # if (isAttributeRequested -RequestedAttributes $RequestedAttributes -AttributeID $attribute.AttributeID -AttributeIDHex $attribute.AttributeID.ToString('X') -AttributeName $attribute.AttributeName)
        # if (isAttributeRequested -RequestedAttributes $RequestedAttributes -AttributeID $attribute.AttributeID -AttributeIDHex $attribute.AttributeID.ToString('X') -AttributeName $attribute.AttributeName)
        # {
        #     $attribute
        # }

        if ((-not ($AttributeID -or $AttributeIDHex -or $AttributeName)) -or
            ($AttributeID -contains $attribute.AttributeID) -or
            ($AttributeIDHex -contains $attribute.AttributeID.ToString('X')) -or
            ($AttributeName.Where{$attribute.AttributeName -like $PSItem}))
            {
                $attribute
            }
    }
}
