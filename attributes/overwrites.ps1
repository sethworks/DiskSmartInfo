$overwrites = @(
    @{Family = 'SK hynix SATA SSDs'
    ModelPatterns = @('^HFS(128|256|512)G39TND.*', '^HFS(120|250|500)G32TND.*', '^HFS(128|256|512)G32TNF.*')
    Attributes = @(
        [ordered]@{AttributeID = 5
            AttributeIDHex = '5'
            AttributeName = 'Retired Block Count'
        },
        [ordered]@{AttributeID = 100
            AttributeIDHex = '64'
            AttributeName = 'Total Erase Count'
        },
        [ordered]@{AttributeID = 168
            AttributeIDHex = 'A8'
            AttributeName = 'Min Erase Count'
        },
        [ordered]@{AttributeID = 169
            AttributeIDHex = 'A9'
            AttributeName = 'Max Erase Count'
        },
        [ordered]@{AttributeID = 170
            AttributeIDHex = 'AA'
            AttributeName = 'Unknown SK hynix Attrib'
        },
        [ordered]@{AttributeID = 171
            AttributeIDHex = 'AB'
            AttributeName = 'Program Fail Count'
        },
        [ordered]@{AttributeID = 172
            AttributeIDHex = 'AC'
            AttributeName = 'Erase Fail Count'
        },
        [ordered]@{AttributeID = 173
            AttributeIDHex = 'AD'
            AttributeName = 'Wear Leveling Count'
        },
        [ordered]@{AttributeID = 174
            AttributeIDHex = 'AE'
            AttributeName = 'Unexpect Power Loss Ct'
        },
        [ordered]@{AttributeID = 176
            AttributeIDHex = 'B0'
            AttributeName = 'Unused Rsvd Blk Cnt Tot'
        },
        [ordered]@{AttributeID = 180
            AttributeIDHex = 'B4'
            AttributeName = 'Erase Fail Count'
        },
        [ordered]@{AttributeID = 181
            AttributeIDHex = 'B5'
            AttributeName = 'Non4k Aligned Access'
        },
        [ordered]@{AttributeID = 183
            AttributeIDHex = 'B7'
            AttributeName = 'SATA Downshift Count'
        },
        [ordered]@{AttributeID = 191
            AttributeIDHex = 'BF'
            AttributeName = 'Unknown SK hynix Attrib'
        },
        [ordered]@{AttributeID = 201
            AttributeIDHex = 'C9'
            AttributeName = 'Percent Lifetime Remain'
        },
        [ordered]@{AttributeID = 212
            AttributeIDHex = 'D4'
            AttributeName = 'Phy Error Count'
        },
        [ordered]@{AttributeID = 231
            AttributeIDHex = 'E7'
            AttributeName = 'SSD Life Left'
        },
        [ordered]@{AttributeID = 234
            AttributeIDHex = 'EA'
            AttributeName = 'Unknown SK hynix Attrib'
        },
        [ordered]@{AttributeID = 236
            AttributeIDHex = 'EC'
            AttributeName = 'Unknown SK hynix Attrib'
        },
        [ordered]@{AttributeID = 238
            AttributeIDHex = 'EE'
            AttributeName = 'Unknown SK hynix Attrib'
        },
        [ordered]@{AttributeID = 241
            AttributeIDHex = 'F1'
            AttributeName = 'Total Writes GB'
        },
        [ordered]@{AttributeID = 242
            AttributeIDHex = 'F2'
            AttributeName = 'Total Reads GB'
        },
        [ordered]@{AttributeID = 243
            AttributeIDHex = 'F3'
            AttributeName = 'Total Media Writes'
        },
        [ordered]@{AttributeID = 249
            AttributeIDHex = 'F9'
            AttributeName = 'NAND Writes GiB'
        },
        [ordered]@{AttributeID = 250
            AttributeIDHex = 'FA'
            AttributeName = 'Read Retry Count'
        }
    ) }
)


