$Script:proprietaryAttributes = @(
    @{Family = 'SK hynix SATA SSDs'
    ModelPatterns = @('^HFS(128|256|512)G39TND-N210A.*', '^HFS(120|250|500)G32TND-N1A2A.*', '^HFS(128|256|512)G32TNF-N3A0A.*')
    Attributes = @(
        [ordered]@{AttributeID = 5
            AttributeName = 'Retired Block Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 100
            AttributeName = 'Total Erase Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 168
            AttributeName = 'Min Erase Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 169
            AttributeName = 'Max Erase Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 170
            AttributeName = 'Unknown SK hynix Attrib'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 171
            AttributeName = 'Program Fail Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 172
            AttributeName = 'Erase Fail Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 173
            AttributeName = 'Wear Leveling Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 174
            AttributeName = 'Unexpect Power Loss Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 176
            AttributeName = 'Unused Reserved Block Count Total'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 180
            AttributeName = 'Erase Fail Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 181
            AttributeName = 'Non4k Aligned Access'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 183
            AttributeName = 'SATA Downshift Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 191
            AttributeName = 'Unknown SK hynix Attrib'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 201
            AttributeName = 'Percent Lifetime Remain'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 212
            AttributeName = 'Phy Error Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 231
            AttributeName = 'SSD Life Left'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 234
            AttributeName = 'Unknown SK hynix Attrib'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 236
            AttributeName = 'Unknown SK hynix Attrib'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 238
            AttributeName = 'Unknown SK hynix Attrib'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 241
            AttributeName = 'Total Writes GB'
            DataType = [DataType]::bits48
            ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] / 1KB)}
        },
        [ordered]@{AttributeID = 242
            AttributeName = 'Total Reads GB'
            DataType = [DataType]::bits48
            ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] / 1KB)}
        },
        [ordered]@{AttributeID = 243
            AttributeName = 'Total Media Writes'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 249
            AttributeName = 'NAND Writes GiB'
            DataType = [DataType]::bits48
            ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] / 1KB)}
        },
        [ordered]@{AttributeID = 250
            AttributeName = 'Read Retry Count'
            DataType = [DataType]::bits48
        }
    ) },
    @{Family = 'Samsung SATA SSDs'
    ModelPatterns = @('^Samsung SSD 8[4-7]0 EVO (mSATA |M\.2 )?((120|250|500|750)G|[124]T)B.*')
    Attributes = @(
        [ordered]@{AttributeID = 170
            AttributeName = 'Unused Reserved Block Count Chip'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 171
            AttributeName = 'Program Fail Count Chip'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 172
            AttributeName = 'Erase Fail Count Chip'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 173
            AttributeName = 'Wear Leveling Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 174
            AttributeName = 'Unexpect Power Loss Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 187
            AttributeName = 'Uncorrectable Error Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 191
            AttributeName = 'Unknown Samsung Attr'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 195
            AttributeName = 'ECC Error Rate'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 199
            AttributeName = 'CRC Error Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 201
            AttributeName = 'Supercap Status'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 202
            AttributeName = 'Exception Mode Status'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 234
            AttributeName = 'Unknown Samsung Attr'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 235
            AttributeName = 'POR Recovery Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 236
            AttributeName = 'Unknown Samsung Attr'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 237
            AttributeName = 'Unknown Samsung Attr'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 238
            AttributeName = 'Unknown Samsung Attr'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 243
            AttributeName = 'SATA Downshift Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 244
            AttributeName = 'Thermal Throttle Status'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 245
            AttributeName = 'Timed Workload Media Wear'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 246
            AttributeName = 'Timed Workload Read Write Ratio'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 247
            AttributeName = 'Timed Workload Timer'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 249
            AttributeName = 'NAND Writes 1GiB'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 250
            AttributeName = 'SATA Interface Downshift'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 251
            AttributeName = 'NAND Writes'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 252
            AttributeName = 'Added Bad Flash Block Count'
            DataType = [DataType]::bits48
        }
    ) }
)
