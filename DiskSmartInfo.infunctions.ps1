function inGetDiskSmartInfo
{
    Param (
        [Microsoft.Management.Infrastructure.CimSession[]]$Session,
        [switch]$ShowConvertedData,
        [switch]$CriticalAttributesOnly,
        [switch]$QuietIfOK
    )

    $namespaceWMI = 'root/WMI'
    $classSMARTData = 'MSStorageDriver_ATAPISmartData'
    $classThresholds = 'MSStorageDriver_FailurePredictThresholds'
    $classDiskDrive = 'Win32_DiskDrive'

    $initialOffset = 2
    $attributeLength = 12

    $parameters = @{}

    if ($Session)
    {
        $parameters.Add('CimSession', $Session)
    }

    try
    {
        $disksSmartData = Get-CimInstance -Namespace $namespaceWMI -ClassName $classSMARTData @parameters  -ErrorAction Stop
        $disksThresholds = Get-CimInstance -Namespace $namespaceWMI -ClassName $classThresholds @parameters
        $diskDrives = Get-CimInstance -ClassName $classDiskDrive @parameters
    }
    catch
    {
        if ($DebugPreference -eq 'Continue')
        {
            $_
        }
        else
        {
            $Script:ErrorAccessingClass += @{ComputerName = $Session.ComputerName; Protocol = $Session.Protocol; ErrorObject = $_}
        }
        continue
    }

    foreach ($diskSmartData in $disksSmartData)
    {
        $Silence = $QuietIfOK

        $instanceName = $diskSmartData.InstanceName
        $smartData = $diskSmartData.VendorSpecific
        $thresholdsData = $disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $instanceName} | ForEach-Object -MemberName VendorSpecific

        # remove '_0' at the end
        $instanceId = $instanceName.Substring(0, $instanceName.Length - 2)

        $diskDrive = $diskDrives | Where-Object -FilterScript { $_.PNPDeviceID -eq $instanceId }
        $model = $diskDrive.Model

        $hash = [ordered]@{}

        if ($Session)
        {
            $hash.Add('ComputerName', $Session.ComputerName)
        }

        # $hash.Add('Model', $diskDrive.Model)
        $hash.Add('Model', $model)
        $hash.Add('InstanceId', $instanceId)

        $attributes = @()

        $smartAttributes = inOverwriteAttributes -model $model

        for ($a = $initialOffset; $a -lt $smartData.Count; $a += $attributeLength)
        {
            $attribute = [ordered]@{}

            $attributeID = $smartData[$a]

            if ($attributeID -and
                (   (-not $CriticalAttributesOnly) -or
                    ($CriticalAttributesOnly -and $smartAttributes.Where{$_.AttributeID -eq $attributeID}.IsCritical) ) )
            {
                $attribute.Add("ID", $attributeID)
                $attribute.Add("IDhex", [convert]::ToString($attributeID,16).ToUpper())
                $attribute.Add("AttributeName", $smartAttributes.Where{$_.AttributeID -eq $attributeID}.AttributeName)
                $attribute.Add("Threshold", $thresholdsData[$a + 1])
                $attribute.Add("Value", $smartData[$a + 3])
                $attribute.Add("Worst", $smartData[$a + 4])
                $attribute.Add("Data", $(inGetAttributeData -smartData $smartData -a $a))

                if ($QuietIfOK)
                {
                    if ( ($smartAttributes.Where{$_.AttributeID -eq $attributeID}.IsCritical -and $attribute.Data) -or
                         ($attribute.Value -le $attribute.Threshold) )
                    {
                        $Silence = $false
                    }
                    else
                    {
                        continue
                    }
                }

                $attributeObject = [PSCustomObject]$attribute
                $attributeObject | Add-Member -TypeName "DiskSmartAttribute"

                if ($ShowConvertedData)
                {
                    $attributeObject | Add-Member -MemberType NoteProperty -Name ConvertedData -Value $(inConvertData -data $attribute.Data) -TypeName 'DiskSmartAttribute#ConvertedData'
                }

                $attributes += $attributeObject
            }
        }

        if ($Silence)
        {
            continue
        }

        $hash.Add("SmartData", $attributes)
        $diskSmartInfo = [PSCustomObject]$hash
        $diskSmartInfo | Add-Member -TypeName "DiskSmartInfo"

        if ($Session)
        {
            $diskSmartInfo | Add-Member -TypeName "DiskSmartInfo#ComputerName"
        }

        $diskSmartInfo
    }
}

function inOverwriteAttributes
{
    Param (
        [string]$model
    )

    $result = [System.Collections.Generic.List[PSCustomObject]]::new($defaultAttributes)

    foreach ($set in $overwrites)
    {
        $patternMatched = $false
        foreach ($modelPattern in $set.ModelPatterns)
        {
            if ($model -match $modelPattern)
            {
                $patternMatched = $true
                break
            }
        }

        if ($patternMatched)
        {
            foreach ($attrib in $set.Attributes)
            {
                $newAttrib = [ordered]@{
                    AttributeID = $attrib.AttributeID
                    AttributeIDHex = $attrib.AttributeIDHex
                    AttributeName = $attrib.AttributeName
                    IsCritical = $false
                    BetterValue = ''
                    Description = ''
                }

                if (($index = $result.FindIndex([Predicate[PSCustomObject]]{$args[0].AttributeID -eq $attrib.AttributeID})) -ge 0)
                {
                    $newAttrib.IsCritical = $result[$index].IsCritical
                    $result[$index] = $newAttrib
                }
                else
                {
                    $result.Add([PSCustomObject]$attrib)
                }
            }
            break
        }
    }

    return $result
}

function inGetAttributeData
{
    Param(
        $smartData,
        $a
    )

    if ($smartData[$a] -eq 194) # Temperature
    {
        # 10, 8, 6
        $temps = @()

        for ($i = 10; $i -ge 6; $i -= 2)
        {
            $value = ($smartData[$a + $i] * 256) + $smartData[$a + $i - 1]

            if ($value)
            {
                $temps += $value
            }
        }

        return $temps
    }
    else
    {
        $result = 0
        $dataStartOffset = $a + 5

        for ($offset = 0; $offset -le 6; $offset++)
        {
            $result += $smartData[$dataStartOffset + $offset] * ( [math]::Pow(256, $offset) )
        }

        return $result
    }
}

function inConvertData
{
    Param(
        $data
    )

    switch ($smartData[$a])
    {
        3 # Spin-Up Time
        {
            return "{0:f3} Sec" -f $($data / 1000)
        }

        9 # Power-On Hours
        {
            return "{0:f} Days" -f $($data / 24)
        }

        190 # Temperature Difference
        {
            return "{0:n0} °C" -f $(100 - $data)
        }

        241 # Total LBAs Written
        {
            return "{0:f3} Tb" -f $($data * $diskDrive.BytesPerSector / 1Tb)
        }

        242 # Total LBAs Read
        {
            return "{0:f3} Tb" -f $($data * $diskDrive.BytesPerSector / 1Tb)
        }

        default
        {
            return $null
        }
    }
}
