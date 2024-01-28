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
        if ((isRequested -AttributeID $attribute.AttributeID) -and (!$CriticalOnly -or $attribute.IsCritical))
        # if (($attributeIDs.Count $attribute.AttributeID -in $attributeIDs) -and (!IsCritical -or $attribute.IsCritical))
        {
            $attribute
        }
    }
    # switch ($PSCmdlet.ParameterSetName)
    # {
    #     'AllAttributes'
    #     {
    #         $descriptions
    #     }

    #     'AttributeID'
    #     {
    #         $descriptions | Where-Object -FilterScript {$_.AttributeID -eq $AttributeID}
    #     }

    #     'AttributeIDHex'
    #     {
    #         $descriptions | Where-Object -FilterScript {$_.AttributeIDHex -eq $AttributeIDHex}
    #     }

    #     'CriticalOnly'
    #     {
    #         $descriptions | Where-Object -Property IsCritical
    #     }
    # }
}
