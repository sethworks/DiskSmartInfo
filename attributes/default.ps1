$defaultAttributesHash = @(
    [ordered]@{
        AttributeID = 1
        AttributeName = 'Raw Read Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 2
        AttributeName = 'Throughput Performance'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 3
        AttributeName = 'Spin-Up Time'
        DataType = [DataType]::bits16
        IsCritical = $false
        ConvertScriptBlock = {"{0:f3} Sec" -f $($args[0] / 1000)}
    },
    [ordered]@{
        AttributeID = 4
        AttributeName = 'Start/Stop Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 5
        AttributeName = 'Reallocated Sectors Count'
        DataType = [DataType]::bits16
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 6
        AttributeName = 'Read Channel Margin'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 7
        AttributeName = 'Seek Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 8
        AttributeName = 'Seek Time Performance'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 9
        AttributeName = 'Power-On Hours'
        DataType = [DataType]::bits24
        IsCritical = $false
        ConvertScriptBlock = {"{0:f} Days" -f $($args[0] / 24)}
    },
    [ordered]@{
        AttributeID = 10
        AttributeName = 'Spin Retry Count'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 11
        AttributeName = 'Calibration Retry Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 12
        AttributeName = 'Power Cycle Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 13
        AttributeName = 'Read Soft Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 175
        AttributeName = 'Program Fail Count Chip'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 176
        AttributeName = 'Erase Fail Count Chip'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 177
        AttributeName = 'Wear Leveling Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 178
        AttributeName = 'Used Reserved Block Count Chip'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 179
        AttributeName = 'Used Reserved Block Count Total'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 180
        AttributeName = 'Unused Reserved Block Count Total'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 181
        AttributeName = 'Program Fail Count Total'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 182
        AttributeName = 'Erase Fail Count Total'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 183
        AttributeName = 'Runtime Bad Block'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 184
        AttributeName = 'End-to-End Error'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 187
        AttributeName = 'Reported Uncorrectable Errors'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 188
        AttributeName = 'Command Timeout'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 189
        AttributeName = 'High Fly Writes'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 190
        AttributeName = 'Airflow Temperature Celsius'
        DataType = [DataType]::temperature3
        IsCritical = $false
        ConvertScriptBlock = {"{0:n0} $([char]0xB0)C" -f $($args[0])}
    },
    [ordered]@{
        AttributeID = 191
        AttributeName = 'G-Sense Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 192
        AttributeName = 'Power-off Retract Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 193
        AttributeName = 'Load Cycle Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 194
        AttributeName = 'Temperature Celsius'
        DataType = [DataType]::temperature3
        IsCritical = $false
        ConvertScriptBlock = {"{0:n0} $([char]0xB0)C" -f $($args[0])}
    },
    [ordered]@{
        AttributeID = 195
        AttributeName = 'Hardware ECC Recovered'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 196
        AttributeName = 'Reallocation Event Count'
        DataType = [DataType]::bits16
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 197
        AttributeName = 'Current Pending Sector Count'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 198
        AttributeName = 'Offline Uncorrectable Sector Count'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 199
        AttributeName = 'Ultra DMA CRC Error Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 200
        AttributeName = 'Multi-Zone Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 201
        AttributeName = 'Soft Read Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 202
        AttributeName = 'Data Address Mark Errors'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 203
        AttributeName = 'Run Out Cancel'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 204
        AttributeName = 'Soft ECC correction'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 205
        AttributeName = 'Thermal Asperity Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 206
        AttributeName = 'Flying Height'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 207
        AttributeName = 'Spin High Current'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 208
        AttributeName = 'Spin Buzz'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 209
        AttributeName = 'Offline Seek Performance'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 220
        AttributeName = 'Disk Shift'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 221
        AttributeName = 'G-Sense Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 222
        AttributeName = 'Loaded Hours'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 223
        AttributeName = 'Load/Unload Retry Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 224
        AttributeName = 'Load Friction'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 225
        AttributeName = 'Load/Unload Cycle Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 226
        AttributeName = 'Load-in time'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 227
        AttributeName = 'Torque Amplification Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 228
        AttributeName = 'Power-Off Retract Cycle'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 230
        AttributeName = 'Head Amplitude'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 231
        AttributeName = 'Temperature Celsius'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 232
        AttributeName = 'Available Reserved Space'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 233
        AttributeName = 'Media Wearout Indicator'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 240
        AttributeName = 'Head Flying Hours'
        DataType = [DataType]::bits24
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 241
        AttributeName = 'Total LBAs Written'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] * $diskDrive.BytesPerSector / 1TB)}
    },
    [ordered]@{
        AttributeID = 242
        AttributeName = 'Total LBAs Read'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = {"{0:f3} TB" -f $($args[0] * $diskDrive.BytesPerSector / 1TB)}
    },
    [ordered]@{
        AttributeID = 250
        AttributeName = 'Read Error Retry Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 254
        AttributeName = 'Free Fall Sensor'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    }
)

$Script:defaultAttributes = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($defaultAttributeHash in $defaultAttributesHash)
{
    $defaultAttributes.Add([PSCustomObject]$defaultAttributeHash)
}
