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
        [string[]]$AttributeName,
        [switch]$CriticalOnly
    )

    $attributeIDs = inComposeAttributeIDs -AttributeID $AttributeID -AttributeIDHex $AttributeIDHex -AttributeName $AttributeName

    foreach ($attribute in $descriptions)
    {
        if ((isAttributeRequested -AttributeID $attribute.AttributeID) -and (-not $CriticalOnly -or $attribute.IsCritical))
        {
            $attribute
        }
    }
}
