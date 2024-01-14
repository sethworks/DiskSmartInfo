$overwrites = @(
    @{ModelPatterns = @('^Samsung SSD 870.*', '^Samsung SSD 860.*');
    Attributes = @(
        [ordered]@{AttributeID = 1
            AttributeIDHex = '1'
            AttributeName = 'Read Error Rate!!!'
            BetterValue = 'Low'
            IsCritical = $null
            Description = '(Vendor specific raw value.) Stores data related to the rate of hardware read errors that occurred when reading data from a disk surface. The raw value has different structure for different vendors and is often not meaningful as a decimal number.'
        },
        [ordered]@{AttributeID = 2
            AttributeIDHex = '2'
            AttributeName = 'Throughput Performance!!!'
            BetterValue = 'High'
            IsCritical = $null
            Description = 'Overall (general) throughput performance of a hard disk drive. If the value of this attribute is decreasing there is a high probability that there is a problem with the disk.'
        },
        [ordered]@{AttributeID = 3
            AttributeIDHex = '3'
            AttributeName = 'Spin-Up Time!!!'
            BetterValue = 'Low'
            IsCritical = $null
            Description = 'Average time of spindle spin up (from zero RPM to fully operational [milliseconds]).'
        },
        [ordered]@{AttributeID = 4
            AttributeIDHex = '4'
            AttributeName = 'Start/Stop Count!!!'
            BetterValue = ''
            IsCritical = $null
            Description = 'A tally of spindle start/stop cycles. The spindle turns on, and hence the count is increased, both when the hard disk is turned on after having before been turned entirely off (disconnected from power source) and when the hard disk returns from having previously been put to sleep mode.'
        },
        [ordered]@{AttributeID = 5
            AttributeIDHex = '5'
            AttributeName = 'Reallocated Sectors Count!!!'
            BetterValue = ''
            IsCritical = $true
            Description = 'Count of reallocated sectors. The raw value represents a count of the bad sectors that have been found and remapped.[25] Thus, the higher the attribute value, the more sectors the drive has had to reallocate. This value is primarily used as a metric of the life expectancy of the drive; a drive which has had any reallocations at all is significantly more likely to fail in the immediate months.'
        }
    ) },

    @{ModelPatterns = @('^HFS(128|256|512)G39TND.*', '^HFS(120|250|500)G32TND.*', '^HFS(128|256|512)G32TNF.*');
    Attributes = @(
        [ordered]@{AttributeID = 5
            AttributeIDHex = '5'
            AttributeName = 'Retired Block Count'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 100
            AttributeIDHex = '64'
            AttributeName = 'Total Erase Count'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 168
            AttributeIDHex = 'A8'
            AttributeName = 'Min Erase Count'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 169
            AttributeIDHex = 'A9'
            AttributeName = 'Max Erase Count'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 170
            AttributeIDHex = 'AA'
            AttributeName = 'Unknown SK hynix Attrib'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 171
            AttributeIDHex = 'AB'
            AttributeName = 'Program Fail Count'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 172
            AttributeIDHex = 'AC'
            AttributeName = 'Erase Fail Count'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 173
            AttributeIDHex = 'AD'
            AttributeName = 'Wear Leveling Count'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 174
            AttributeIDHex = 'AE'
            AttributeName = 'Unexpect Power Loss Ct'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 176
            AttributeIDHex = 'B0'
            AttributeName = 'Unused Rsvd Blk Cnt Tot'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 180
            AttributeIDHex = 'B4'
            AttributeName = 'Erase Fail Count'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 181
            AttributeIDHex = 'B5'
            AttributeName = 'Non4k Aligned Access'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 183
            AttributeIDHex = 'B7'
            AttributeName = 'SATA Downshift Count'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 191
            AttributeIDHex = 'BF'
            AttributeName = 'Unknown SK hynix Attrib'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 201
            AttributeIDHex = 'C9'
            AttributeName = 'Percent Lifetime Remain'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 212
            AttributeIDHex = 'D4'
            AttributeName = 'Phy Error Count'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 231
            AttributeIDHex = 'E7'
            AttributeName = 'SSD Life Left'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 234
            AttributeIDHex = 'EA'
            AttributeName = 'Unknown SK hynix Attrib'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 236
            AttributeIDHex = 'EC'
            AttributeName = 'Unknown SK hynix Attrib'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 238
            AttributeIDHex = 'EE'
            AttributeName = 'Unknown SK hynix Attrib'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 241
            AttributeIDHex = 'F1'
            AttributeName = 'Total Writes GB'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 242
            AttributeIDHex = 'F2'
            AttributeName = 'Total Reads GB'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 243
            AttributeIDHex = 'F3'
            AttributeName = 'Total Media Writes'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 249
            AttributeIDHex = 'F9'
            AttributeName = 'NAND Writes GiB'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        },
        [ordered]@{AttributeID = 250
            AttributeIDHex = 'FA'
            AttributeName = 'Read Retry Count'
            BetterValue = ''
            IsCritical = $null
            Description = ''
        }
    ) }
)

# $smartAttributes = [System.Collections.Generic.List[PSCustomObject]]::new()

# foreach ($smartAttributeHash in $smartAttributesHash)
# {
#     $smartAttributes.Add([PSCustomObject]$smartAttributeHash)
# }
