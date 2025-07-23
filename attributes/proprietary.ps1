$Script:proprietaryAttributes = @(
    @{Family = 'SK hynix SATA SSDs'
    ModelPatterns = @('^HFS(128|256|512)G39TND-N210A.*', '^HFS(120|250|500)G32TND-N1A2A.*', '^HFS(128|256|512)G32TNF-N3A0A.*')
    Attributes = @(
        [ordered]@{AttributeID = 5
            AttributeName = 'Retired Block Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 100
            AttributeName = 'Total Erase Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 168
            AttributeName = 'Min Erase Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 169
            AttributeName = 'Max Erase Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 170
            AttributeName = 'Unknown SK hynix Attrib'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 171
            AttributeName = 'Program Fail Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 172
            AttributeName = 'Erase Fail Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 173
            AttributeName = 'Wear Leveling Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 174
            AttributeName = 'Unexpect Power Loss Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 176
            AttributeName = 'Unused Reserved Block Count Total'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 180
            AttributeName = 'Erase Fail Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 181
            AttributeName = 'Non4k Aligned Access'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 183
            AttributeName = 'SATA Downshift Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 191
            AttributeName = 'Unknown SK hynix Attrib'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 201
            AttributeName = 'Percent Lifetime Remain'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 212
            AttributeName = 'Phy Error Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 231
            AttributeName = 'SSD Life Left'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 234
            AttributeName = 'Unknown SK hynix Attrib'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 236
            AttributeName = 'Unknown SK hynix Attrib'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 238
            AttributeName = 'Unknown SK hynix Attrib'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 241
            AttributeName = 'Total Writes GB'
            DataFormat = [AttributeDataFormat]::bits48
            ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] / 1KB)}
        },
        [ordered]@{AttributeID = 242
            AttributeName = 'Total Reads GB'
            DataFormat = [AttributeDataFormat]::bits48
            ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] / 1KB)}
        },
        [ordered]@{AttributeID = 243
            AttributeName = 'Total Media Writes'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 249
            AttributeName = 'NAND Writes GiB'
            DataFormat = [AttributeDataFormat]::bits48
            ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] / 1KB)}
        },
        [ordered]@{AttributeID = 250
            AttributeName = 'Read Retry Count'
            DataFormat = [AttributeDataFormat]::bits48
        }
    ) },
    @{Family = 'Samsung SATA SSDs'
    ModelPatterns = @('^Samsung SSD 8[4-7]0 EVO (mSATA |M\.2 )?((120|250|500|750)G|[124]T)B.*')
    Attributes = @(
        [ordered]@{AttributeID = 170
            AttributeName = 'Unused Reserved Block Count Chip'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 171
            AttributeName = 'Program Fail Count Chip'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 172
            AttributeName = 'Erase Fail Count Chip'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 173
            AttributeName = 'Wear Leveling Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 174
            AttributeName = 'Unexpect Power Loss Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 187
            AttributeName = 'Uncorrectable Error Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 191
            AttributeName = 'Unknown Samsung Attr'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 195
            AttributeName = 'ECC Error Rate'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 199
            AttributeName = 'CRC Error Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 201
            AttributeName = 'Supercap Status'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 202
            AttributeName = 'Exception Mode Status'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 234
            AttributeName = 'Unknown Samsung Attr'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 235
            AttributeName = 'POR Recovery Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 236
            AttributeName = 'Unknown Samsung Attr'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 237
            AttributeName = 'Unknown Samsung Attr'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 238
            AttributeName = 'Unknown Samsung Attr'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 243
            AttributeName = 'SATA Downshift Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 244
            AttributeName = 'Thermal Throttle Status'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 245
            AttributeName = 'Timed Workload Media Wear'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 246
            AttributeName = 'Timed Workload Read Write Ratio'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 247
            AttributeName = 'Timed Workload Timer'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 249
            AttributeName = 'NAND Writes 1GiB'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 250
            AttributeName = 'SATA Interface Downshift'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 251
            AttributeName = 'NAND Writes'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 252
            AttributeName = 'Added Bad Flash Block Count'
            DataFormat = [AttributeDataFormat]::bits48
        }
    ) },
    @{Family = 'Kingston SATA SSDs'
    ModelPatterns = @('^KINGSTON  ?SA400(M8|S37)(120|240|480|960)G.*')
    Attributes = @(
        [ordered]@{AttributeID = 167
            AttributeName = 'Write Protect Mode'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 168
            AttributeName = 'SATA Phy Error Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 169
            AttributeName = 'Bad Block Rate'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 170
            AttributeName = 'Bad Block Count Later/Early'
            DataFormat = [AttributeDataFormat]::bytes5410
        },
        [ordered]@{AttributeID = 172
            AttributeName = 'Erase Fail Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 173
            AttributeName = 'Erase Count Max/Average'
            DataFormat = [AttributeDataFormat]::bytes1032
        },
        [ordered]@{AttributeID = 192
            AttributeName = 'Unsafe Shutdown Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 199
            AttributeName = 'CRC Error Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 218
            AttributeName = 'CRC Error Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 231
            AttributeName = 'SSD Life Left'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 233
            AttributeName = 'Flash Writes GiB'
            DataFormat = [AttributeDataFormat]::bits48
            ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] / 1KB)}
        },
        [ordered]@{AttributeID = 241
            AttributeName = 'Host Writes GiB'
            DataFormat = [AttributeDataFormat]::bits48
            ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] / 1KB)}
        },
        [ordered]@{AttributeID = 242
            AttributeName = 'Host Reads GiB'
            DataFormat = [AttributeDataFormat]::bits48
            ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] / 1KB)}
        },
        [ordered]@{AttributeID = 244
            AttributeName = 'Average Erase Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 245
            AttributeName = 'Max Erase Count'
            DataFormat = [AttributeDataFormat]::bits48
        },
        [ordered]@{AttributeID = 246
            AttributeName = 'Total Erase Count'
            DataFormat = [AttributeDataFormat]::bits48
        }
    ) }
)
