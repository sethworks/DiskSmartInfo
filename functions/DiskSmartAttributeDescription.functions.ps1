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

    foreach ($attribute in $descriptions)
    {
        if ((-not ($AttributeID -or $AttributeIDHex -or $AttributeName)) -or
            ($AttributeID -contains $attribute.AttributeID) -or
            ($AttributeIDHex -contains $attribute.AttributeID.ToString('X')) -or
            ($AttributeName.Where{$attribute.AttributeName -like $PSItem}))
        {
            $attribute
        }
    }
}
