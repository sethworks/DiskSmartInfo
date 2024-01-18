enum DataType {
    bits48
    bits24
    bits16
    temperature3
}

$defaultAttributesHash = @(
    [ordered]@{
        AttributeID = 1
        AttributeIDHex = '1'
        AttributeName = 'Raw Read Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 2
        AttributeIDHex = '2'
        AttributeName = 'Throughput Performance'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 3
        AttributeIDHex = '3'
        AttributeName = 'Spin-Up Time'
        DataType = [DataType]::bits16
        IsCritical = $false
        ConvertScriptBlock = {"{0:f3} Sec" -f $($data / 1000)}
    },
    [ordered]@{
        AttributeID = 4
        AttributeIDHex = '4'
        AttributeName = 'Start/Stop Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 5
        AttributeIDHex = '5'
        AttributeName = 'Reallocated Sectors Count'
        DataType = [DataType]::bits16
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 6
        AttributeIDHex = '6'
        AttributeName = 'Read Channel Margin'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 7
        AttributeIDHex = '7'
        AttributeName = 'Seek Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 8
        AttributeIDHex = '8'
        AttributeName = 'Seek Time Performance'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 9
        AttributeIDHex = '9'
        AttributeName = 'Power-On Hours'
        DataType = [DataType]::bits24
        IsCritical = $false
        ConvertScriptBlock = {"{0:f} Days" -f $($data / 24)}
    },
    [ordered]@{
        AttributeID = 10
        AttributeIDHex = 'A'
        AttributeName = 'Spin Retry Count'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 11
        AttributeIDHex = 'B'
        AttributeName = 'Calibration Retry Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 12
        AttributeIDHex = 'C'
        AttributeName = 'Power Cycle Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 13
        AttributeIDHex = 'D'
        AttributeName = 'Read Soft Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 175
        AttributeIDHex = 'AF'
        AttributeName = 'Program Fail Count Chip'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 176
        AttributeIDHex = 'B0'
        AttributeName = 'Erase Fail Count Chip'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 177
        AttributeIDHex = 'B1'
        AttributeName = 'Wear Leveling Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 178
        AttributeIDHex = 'B2'
        AttributeName = 'Used Reserved Block Count Chip'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 179
        AttributeIDHex = 'B3'
        AttributeName = 'Used Reserved Block Count Total'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 180
        AttributeIDHex = 'B4'
        AttributeName = 'Unused Reserved Block Count Total'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 181
        AttributeIDHex = 'B5'
        AttributeName = 'Program Fail Count Total'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 182
        AttributeIDHex = 'B6'
        AttributeName = 'Erase Fail Count Total'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 183
        AttributeIDHex = 'B7'
        AttributeName = 'Runtime Bad Block'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 184
        AttributeIDHex = 'B8'
        AttributeName = 'End-to-End Error'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 187
        AttributeIDHex = 'BB'
        AttributeName = 'Reported Uncorrectable Errors'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 188
        AttributeIDHex = 'BC'
        AttributeName = 'Command Timeout'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 189
        AttributeIDHex = 'BD'
        AttributeName = 'High Fly Writes'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 190
        AttributeIDHex = 'BE'
        AttributeName = 'Airflow Temperature Celsius'
        DataType = [DataType]::temperature3
        IsCritical = $false
        ConvertScriptBlock = {"{0:n0} °C" -f $(100 - $data)}
    },
    [ordered]@{
        AttributeID = 191
        AttributeIDHex = 'BF'
        AttributeName = 'G-Sense Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 192
        AttributeIDHex = 'C0'
        AttributeName = 'Power-off Retract Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 193
        AttributeIDHex = 'C1'
        AttributeName = 'Load Cycle Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 194
        AttributeIDHex = 'C2'
        AttributeName = 'Temperature Celsius'
        DataType = [DataType]::temperature3
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 195
        AttributeIDHex = 'C3'
        AttributeName = 'Hardware ECC Recovered'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 196
        AttributeIDHex = 'C4'
        AttributeName = 'Reallocation Event Count'
        DataType = [DataType]::bits16
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 197
        AttributeIDHex = 'C5'
        AttributeName = 'Current Pending Sector Count'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 198
        AttributeIDHex = 'C6'
        AttributeName = 'Offline Uncorrectable Sector Count'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 199
        AttributeIDHex = 'C7'
        AttributeName = 'Ultra DMA CRC Error Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 200
        AttributeIDHex = 'C8'
        AttributeName = 'Multi-Zone Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 201
        AttributeIDHex = 'C9'
        AttributeName = 'Soft Read Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $true
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 202
        AttributeIDHex = 'CA'
        AttributeName = 'Data Address Mark Errors'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 203
        AttributeIDHex = 'CB'
        AttributeName = 'Run Out Cancel'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 204
        AttributeIDHex = 'CC'
        AttributeName = 'Soft ECC correction'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 205
        AttributeIDHex = 'CD'
        AttributeName = 'Thermal Asperity Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 206
        AttributeIDHex = 'CE'
        AttributeName = 'Flying Height'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 207
        AttributeIDHex = 'CF'
        AttributeName = 'Spin High Current'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 208
        AttributeIDHex = 'D0'
        AttributeName = 'Spin Buzz'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 209
        AttributeIDHex = 'D1'
        AttributeName = 'Offline Seek Performance'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 220
        AttributeIDHex = 'DC'
        AttributeName = 'Disk Shift'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 221
        AttributeIDHex = 'DD'
        AttributeName = 'G-Sense Error Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 222
        AttributeIDHex = 'DE'
        AttributeName = 'Loaded Hours'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 223
        AttributeIDHex = 'DF'
        AttributeName = 'Load/Unload Retry Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 224
        AttributeIDHex = 'E0'
        AttributeName = 'Load Friction'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 225
        AttributeIDHex = 'E1'
        AttributeName = 'Load/Unload Cycle Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 226
        AttributeIDHex = 'E2'
        AttributeName = 'Load-in time'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 227
        AttributeIDHex = 'E3'
        AttributeName = 'Torque Amplification Count'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 228
        AttributeIDHex = 'E4'
        AttributeName = 'Power-Off Retract Cycle'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 230
        AttributeIDHex = 'E6'
        AttributeName = 'Head Amplitude'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 231
        AttributeIDHex = 'E7'
        AttributeName = 'Temperature Celsius'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 232
        AttributeIDHex = 'E8'
        AttributeName = 'Available Reserved Space'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 233
        AttributeIDHex = 'E9'
        AttributeName = 'Media Wearout Indicator'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 240
        AttributeIDHex = 'F0'
        AttributeName = 'Head Flying Hours'
        DataType = [DataType]::bits24
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 241
        AttributeIDHex = 'F1'
        AttributeName = 'Total LBAs Written'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = {"{0:f3} TB" -f $($data * $diskDrive.BytesPerSector / 1TB)}
    },
    [ordered]@{
        AttributeID = 242
        AttributeIDHex = 'F2'
        AttributeName = 'Total LBAs Read'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = {"{0:f3} TB" -f $($data * $diskDrive.BytesPerSector / 1TB)}
    },
    [ordered]@{
        AttributeID = 250
        AttributeIDHex = 'FA'
        AttributeName = 'Read Error Retry Rate'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    },
    [ordered]@{
        AttributeID = 254
        AttributeIDHex = 'FE'
        AttributeName = 'Free Fall Sensor'
        DataType = [DataType]::bits48
        IsCritical = $false
        ConvertScriptBlock = $null
    }
)

$defaultAttributes = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($defaultAttributeHash in $defaultAttributesHash)
{
    $defaultAttributes.Add([PSCustomObject]$defaultAttributeHash)
}
