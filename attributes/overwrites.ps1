$overwrites = @(
    @{ModelPattern = '^Samsung.*'; Attributes = @(
        [ordered]@{
            AttributeID = 1
            AttributeIDHex = '1'
            AttributeName = 'Read Error Rate!!!'
            BetterValue = 'Low'
            IsCritical = $null
            Description = '(Vendor specific raw value.) Stores data related to the rate of hardware read errors that occurred when reading data from a disk surface. The raw value has different structure for different vendors and is often not meaningful as a decimal number.'
        },
        [ordered]@{
            AttributeID = 2
            AttributeIDHex = '2'
            AttributeName = 'Throughput Performance!!!'
            BetterValue = 'High'
            IsCritical = $null
            Description = 'Overall (general) throughput performance of a hard disk drive. If the value of this attribute is decreasing there is a high probability that there is a problem with the disk.'
        },
        [ordered]@{
            AttributeID = 3
            AttributeIDHex = '3'
            AttributeName = 'Spin-Up Time!!!'
            BetterValue = 'Low'
            IsCritical = $null
            Description = 'Average time of spindle spin up (from zero RPM to fully operational [milliseconds]).'
        },
        [ordered]@{
            AttributeID = 4
            AttributeIDHex = '4'
            AttributeName = 'Start/Stop Count!!!'
            BetterValue = ''
            IsCritical = $null
            Description = 'A tally of spindle start/stop cycles. The spindle turns on, and hence the count is increased, both when the hard disk is turned on after having before been turned entirely off (disconnected from power source) and when the hard disk returns from having previously been put to sleep mode.'
        },
        [ordered]@{
            AttributeID = 5
            AttributeIDHex = '5'
            AttributeName = 'Reallocated Sectors Count!!!'
            BetterValue = ''
            IsCritical = $true
            Description = 'Count of reallocated sectors. The raw value represents a count of the bad sectors that have been found and remapped.[25] Thus, the higher the attribute value, the more sectors the drive has had to reallocate. This value is primarily used as a metric of the life expectancy of the drive; a drive which has had any reallocations at all is significantly more likely to fail in the immediate months.'
        }
    ) }
)

# $smartAttributes = [System.Collections.Generic.List[PSCustomObject]]::new()

# foreach ($smartAttributeHash in $smartAttributesHash)
# {
#     $smartAttributes.Add([PSCustomObject]$smartAttributeHash)
# }
