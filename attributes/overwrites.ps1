$overwrites = @(
    @{Family = 'SK hynix SATA SSDs'
    ModelPatterns = @('^HFS(128|256|512)G39TND-N210A.*', '^HFS(120|250|500)G32TND-N1A2A.*', '^HFS(128|256|512)G32TNF-N3A0A.*')
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
            AttributeName = 'Unexpect Power Loss Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 176
            AttributeIDHex = 'B0'
            AttributeName = 'Unused Reserved Block Count Total'
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
            ConvertScriptBlock = {"{0:f3} TB" -f $($data / 1KB)}
        },
        [ordered]@{AttributeID = 242
            AttributeIDHex = 'F2'
            AttributeName = 'Total Reads GB'
            DataType = [DataType]::bits48
            ConvertScriptBlock = {"{0:f3} TB" -f $($data / 1KB)}
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
    ) },
    @{Family = 'Samsung based SSDs'
    ModelPatterns = @('^Samsung SSD 8[4-7]0 EVO (mSATA |M\.2 )?((120|250|500|750)G|[124]T)B.*')
    Attributes = @(
        [ordered]@{AttributeID = 170
            AttributeIDHex = 'AA'
            AttributeName = 'Unused Reserved Block Count Chip'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 171
            AttributeIDHex = 'AB'
            AttributeName = 'Program Fail Count Chip'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 172
            AttributeIDHex = 'AC'
            AttributeName = 'Erase Fail Count Chip'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 173
            AttributeIDHex = 'AD'
            AttributeName = 'Wear Leveling Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 174
            AttributeIDHex = 'AE'
            AttributeName = 'Unexpect Power Loss Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 187
            AttributeIDHex = 'BB'
            AttributeName = 'Uncorrectable Error Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 191
            AttributeIDHex = 'BF'
            AttributeName = 'Unknown Samsung Attr'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 195
            AttributeIDHex = 'C3'
            AttributeName = 'ECC Error Rate'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 199
            AttributeIDHex = 'C7'
            AttributeName = 'CRC Error Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 201
            AttributeIDHex = 'C9'
            AttributeName = 'Supercap Status'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 202
            AttributeIDHex = 'CA'
            AttributeName = 'Exception Mode Status'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 234
            AttributeIDHex = 'EA'
            AttributeName = 'Unknown Samsung Attr'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 235
            AttributeIDHex = 'EB'
            AttributeName = 'POR Recovery Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 236
            AttributeIDHex = 'EC'
            AttributeName = 'Unknown Samsung Attr'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 237
            AttributeIDHex = 'ED'
            AttributeName = 'Unknown Samsung Attr'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 238
            AttributeIDHex = 'EE'
            AttributeName = 'Unknown Samsung Attr'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 243
            AttributeIDHex = 'F3'
            AttributeName = 'SATA Downshift Count'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 244
            AttributeIDHex = 'F4'
            AttributeName = 'Thermal Throttle Status'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 245
            AttributeIDHex = 'F5'
            AttributeName = 'Timed Workload Media Wear'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 246
            AttributeIDHex = 'F6'
            AttributeName = 'Timed Workload Read Write Ratio'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 247
            AttributeIDHex = 'F7'
            AttributeName = 'Timed Workload Timer'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 249
            AttributeIDHex = 'F9'
            AttributeName = 'NAND Writes 1GiB'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 250
            AttributeIDHex = 'FA'
            AttributeName = 'SATA Interface Downshift'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 251
            AttributeIDHex = 'FB'
            AttributeName = 'NAND Writes'
            DataType = [DataType]::bits48
        },
        [ordered]@{AttributeID = 252
            AttributeIDHex = 'FC'
            AttributeName = 'Added Bad Flash Block Count'
            DataType = [DataType]::bits48
        }
    ) }
)
