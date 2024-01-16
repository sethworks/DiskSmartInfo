$overwrites = @(
    @{Family = 'SK hynix SATA SSDs'
    ModelPatterns = @('^HFS(128|256|512)G39TND.*', '^HFS(120|250|500)G32TND.*', '^HFS(128|256|512)G32TNF.*')
    Attributes = @(
        [ordered]@{AttributeID = 5
            AttributeIDHex = '5'
            AttributeName = 'Retired Block Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 100
            AttributeIDHex = '64'
            AttributeName = 'Total Erase Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 168
            AttributeIDHex = 'A8'
            AttributeName = 'Min Erase Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 169
            AttributeIDHex = 'A9'
            AttributeName = 'Max Erase Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 170
            AttributeIDHex = 'AA'
            AttributeName = 'Unknown SK hynix Attrib'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 171
            AttributeIDHex = 'AB'
            AttributeName = 'Program Fail Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 172
            AttributeIDHex = 'AC'
            AttributeName = 'Erase Fail Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 173
            AttributeIDHex = 'AD'
            AttributeName = 'Wear Leveling Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 174
            AttributeIDHex = 'AE'
            AttributeName = 'Unexpect Power Loss Ct'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 176
            AttributeIDHex = 'B0'
            AttributeName = 'Unused Rsvd Blk Cnt Tot'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 180
            AttributeIDHex = 'B4'
            AttributeName = 'Erase Fail Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 181
            AttributeIDHex = 'B5'
            AttributeName = 'Non4k Aligned Access'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 183
            AttributeIDHex = 'B7'
            AttributeName = 'SATA Downshift Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 191
            AttributeIDHex = 'BF'
            AttributeName = 'Unknown SK hynix Attrib'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 201
            AttributeIDHex = 'C9'
            AttributeName = 'Percent Lifetime Remain'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 212
            AttributeIDHex = 'D4'
            AttributeName = 'Phy Error Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 231
            AttributeIDHex = 'E7'
            AttributeName = 'SSD Life Left'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 234
            AttributeIDHex = 'EA'
            AttributeName = 'Unknown SK hynix Attrib'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 236
            AttributeIDHex = 'EC'
            AttributeName = 'Unknown SK hynix Attrib'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 238
            AttributeIDHex = 'EE'
            AttributeName = 'Unknown SK hynix Attrib'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 241
            AttributeIDHex = 'F1'
            AttributeName = 'Total Writes GB'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 242
            AttributeIDHex = 'F2'
            AttributeName = 'Total Reads GB'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 243
            AttributeIDHex = 'F3'
            AttributeName = 'Total Media Writes'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 249
            AttributeIDHex = 'F9'
            AttributeName = 'NAND Writes GiB'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 250
            AttributeIDHex = 'FA'
            AttributeName = 'Read Retry Count'
            DataType = [DataType]::bits48
        }
    ) }
)


