$defaultAttributesHash = @(
    [ordered]@{
        AttributeID = 1
        AttributeName = 'Raw Read Error Rate'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 2
        AttributeName = 'Throughput Performance'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 3
        AttributeName = 'Spin-Up Time'
        DataFormat = [AttributeDataFormat]::bits16
        IsCritical = $false
        ConvertScriptBlock = {"{0:f3} Sec" -f $($args[0] / 1000)}
    },
    [ordered]@{
        AttributeID = 4
        AttributeName = 'Start/Stop Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 5
        AttributeName = 'Reallocated Sectors Count'
        DataFormat = [AttributeDataFormat]::bits16
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 6
        AttributeName = 'Read Channel Margin'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 7
        AttributeName = 'Seek Error Rate'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 8
        AttributeName = 'Seek Time Performance'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 9
        AttributeName = 'Power-On Hours'
        DataFormat = [AttributeDataFormat]::bits24
        IsCritical = $false
        ConvertScriptBlock = {"{0:f} Days" -f $($args[0] / 24)}
    },
    [ordered]@{
        AttributeID = 10
        AttributeName = 'Spin Retry Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 11
        AttributeName = 'Calibration Retry Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 12
        AttributeName = 'Power Cycle Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 13
        AttributeName = 'Read Soft Error Rate'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 175
        AttributeName = 'Program Fail Count Chip'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 176
        AttributeName = 'Erase Fail Count Chip'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 177
        AttributeName = 'Wear Leveling Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 178
        AttributeName = 'Used Reserved Block Count Chip'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 179
        AttributeName = 'Used Reserved Block Count Total'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 180
        AttributeName = 'Unused Reserved Block Count Total'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 181
        AttributeName = 'Program Fail Count Total'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 182
        AttributeName = 'Erase Fail Count Total'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 183
        AttributeName = 'Runtime Bad Block'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 184
        AttributeName = 'End-to-End Error'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 187
        AttributeName = 'Reported Uncorrectable Errors'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 188
        AttributeName = 'Command Timeout'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 189
        AttributeName = 'High Fly Writes'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 190
        AttributeName = 'Airflow Temperature Celsius'
        DataFormat = [AttributeDataFormat]::temperature3
        IsCritical = $false
        ConvertScriptBlock = {"{0:n0} $([char]0xB0)C" -f $($args[0])}
    },
    [ordered]@{
        AttributeID = 191
        AttributeName = 'G-Sense Error Rate'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 192
        AttributeName = 'Power-off Retract Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 193
        AttributeName = 'Load Cycle Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 194
        AttributeName = 'Temperature Celsius'
        DataFormat = [AttributeDataFormat]::temperature3
        IsCritical = $false
        ConvertScriptBlock = {"{0:n0} $([char]0xB0)C" -f $($args[0])}
    },
    [ordered]@{
        AttributeID = 195
        AttributeName = 'Hardware ECC Recovered'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 196
        AttributeName = 'Reallocation Event Count'
        DataFormat = [AttributeDataFormat]::bits16
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 197
        AttributeName = 'Current Pending Sector Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 198
        AttributeName = 'Offline Uncorrectable Sector Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 199
        AttributeName = 'Ultra DMA CRC Error Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 200
        AttributeName = 'Multi-Zone Error Rate'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 201
        AttributeName = 'Soft Read Error Rate'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 202
        AttributeName = 'Data Address Mark Errors'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 203
        AttributeName = 'Run Out Cancel'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 204
        AttributeName = 'Soft ECC correction'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 205
        AttributeName = 'Thermal Asperity Rate'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 206
        AttributeName = 'Flying Height'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 207
        AttributeName = 'Spin High Current'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 208
        AttributeName = 'Spin Buzz'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 209
        AttributeName = 'Offline Seek Performance'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 220
        AttributeName = 'Disk Shift'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 221
        AttributeName = 'G-Sense Error Rate'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 222
        AttributeName = 'Loaded Hours'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 223
        AttributeName = 'Load/Unload Retry Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 224
        AttributeName = 'Load Friction'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 225
        AttributeName = 'Load/Unload Cycle Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 226
        AttributeName = 'Load-in time'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 227
        AttributeName = 'Torque Amplification Count'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 228
        AttributeName = 'Power-Off Retract Cycle'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 230
        AttributeName = 'Head Amplitude'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 231
        AttributeName = 'Temperature Celsius'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 232
        AttributeName = 'Available Reserved Space'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 233
        AttributeName = 'Media Wearout Indicator'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 240
        AttributeName = 'Head Flying Hours'
        DataFormat = [AttributeDataFormat]::bits24
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 241
        AttributeName = 'Total LBAs Written'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        # ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] * $diskDrive.BytesPerSector / 1TB)}
        ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] * $diskSmartData.AuxiliaryData.BytesPerSector / 1TB)}
    },
    [ordered]@{
        AttributeID = 242
        AttributeName = 'Total LBAs Read'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        # ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] * $diskDrive.BytesPerSector / 1TB)}
        ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] * $diskSmartData.AuxiliaryData.BytesPerSector / 1TB)}
    },
    [ordered]@{
        AttributeID = 250
        AttributeName = 'Read Error Retry Rate'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 254
        AttributeName = 'Free Fall Sensor'
        DataFormat = [AttributeDataFormat]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    }
)

$Script:defaultAttributes = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($defaultAttributeHash in $defaultAttributesHash)
{
    $defaultAttributes.Add([PSCustomObject]$defaultAttributeHash)
}
