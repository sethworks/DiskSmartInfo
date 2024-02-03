function inGetDiskSmartInfo
{
    Param (
        [Microsoft.Management.Infrastructure.CimSession[]]$Session,
        [switch]$ShowConverted,
        [switch]$CriticalAttributesOnly,
        [System.Collections.Generic.List[int]]$DiskNumbers,
        [string[]]$DiskModels,
        [System.Collections.Generic.List[int]]$AttributeIDs,
        [switch]$Quiet,
        [switch]$ShowHistory,
        [switch]$UpdateHistory
    )

    $namespaceWMI = 'root/WMI'
    $classSmartData = 'MSStorageDriver_ATAPISmartData'
    $classThresholds = 'MSStorageDriver_FailurePredictThresholds'
    $classFailurePredictStatus = 'MSStorageDriver_FailurePredictStatus'
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
        $disksSmartData = Get-CimInstance -Namespace $namespaceWMI -ClassName $classSmartData @parameters -ErrorAction Stop
        $disksThresholds = Get-CimInstance -Namespace $namespaceWMI -ClassName $classThresholds @parameters
        $disksFailurePredictStatus = Get-CimInstance -nam $namespaceWMI -ClassName $classFailurePredictStatus @parameters
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

    if ($ShowHistory)
    {
        $hostHistoricalData = inGetHistoricalData -session $Session
    }

    foreach ($diskSmartData in $disksSmartData)
    {
        $smartData = $diskSmartData.VendorSpecific
        $thresholdsData = $disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName VendorSpecific
        $failurePredictStatus = $disksFailurePredictStatus | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName PredictFailure

        $pNPDeviceId = $diskSmartData.InstanceName
        if ($pNPDeviceId -match '_\d$')
        {
            $pNPDeviceId = $pNPDeviceId.Remove($pNPDeviceId.Length - 2)
        }

        $diskDrive = $diskDrives | Where-Object -FilterScript { $_.PNPDeviceID -eq $pNPDeviceId }

        $model = inTrimDiskDriveModel -Model $diskDrive.Model

        if ((!$DiskNumbers.Count -and !$DiskModels.Count) -or (isDiskNumberMatched -Index $diskDrive.Index) -or (isDiskModelMatched -Model $model))
        {
            $hash = [ordered]@{}

            if ($Session)
            {
                $hash.Add('ComputerName', [string]$Session.ComputerName)
            }
            else
            {
                $hash.Add('ComputerName', $null)
            }

            $hash.Add('DiskNumber', [uint32]$diskDrive.Index)
            $hash.Add('DiskModel', [string]$model)
            $hash.Add('PNPDeviceId', [string]$pNPDeviceId)
            $hash.Add('PredictFailure', [bool]$failurePredictStatus)

            if ($ShowHistory)
            {
                if ($hostHistoricalData)
                {
                    $hash.Add('HistoryDate', [datetime]$hostHistoricalData.TimeStamp)
                }
                else
                {
                    $hash.Add('HistoryDate', $null)
                }
            }

            $attributes = @()

            $smartAttributes = inOverwriteAttributes -model $model

            if ($hostHistoricalData)
            {
                $historicalAttributes = $hostHistoricalData.HistoricalData.Where{$_.PNPDeviceID -eq $pNPDeviceId}.SmartData
            }

            for ($a = $initialOffset; $a -lt $smartData.Count; $a += $attributeLength)
            {
                $attribute = [ordered]@{}

                $attributeID = $smartData[$a]

                if ($attributeID -and
                (isAttributeRequested -AttributeID $attributeID) -and
                ((-not $CriticalAttributesOnly) -or (isCritical -AttributeID $attributeID)))
                {
                    $attribute.Add("ID", $attributeID)
                    $attribute.Add("IDHex", $attributeID.ToString("X"))
                    $attribute.Add("AttributeName", $smartAttributes.Where{$_.AttributeID -eq $attributeID}.AttributeName)
                    $attribute.Add("Threshold", $thresholdsData[$a + 1])
                    $attribute.Add("Value", $smartData[$a + 3])
                    $attribute.Add("Worst", $smartData[$a + 4])
                    $attribute.Add("Data", $(inGetAttributeData -smartData $smartData -a $a))

                    if ((-not $Quiet) -or (((isCritical -AttributeID $attributeID) -and $attribute.Data) -or (isThresholdReached -Attribute $attribute)))
                    {
                        if ($ShowHistory)
                        {
                            if ($hostHistoricalData)
                            {
                                $historicalAttributeData = $historicalAttributes.Where{$_.ID -eq $attributeID}.Data
                                if ($Config.ShowUnchangedHistoricalData -or ($historicalAttributeData -ne $attribute.Data))
                                {
                                    $attribute.Add("DataHistory", $historicalAttributeData)
                                }
                                else
                                {
                                    $attribute.Add("DataHistory", $null)
                                }
                            }
                            else
                            {
                                $attribute.Add("DataHistory", $null)
                            }
                        }
                        if ($ShowConverted)
                        {
                            $attribute.Add("DataConverted", $(inConvertData -attribute $attribute))
                        }

                        $attributeObject = [PSCustomObject]$attribute
                        $attributeObject | Add-Member -TypeName "DiskSmartAttribute"

                        if ($ShowHistory -and $ShowConverted)
                        {
                            $attributeObject | Add-Member -TypeName 'DiskSmartAttribute#DataHistoryDataConverted'
                        }
                        elseif ($ShowHistory)
                        {
                            $attributeObject | Add-Member -TypeName 'DiskSmartAttribute#DataHistory'
                        }
                        elseif ($ShowConverted)
                        {
                            $attributeObject | Add-Member -TypeName 'DiskSmartAttribute#DataConverted'
                        }
                        $attributes += $attributeObject
                    }
                }
            }

            if ($attributes -or (-not $Config.SuppressEmptySmartData -and -not $Quiet) -or $failurePredictStatus)
            {
                $hash.Add("SmartData", $attributes)
                $diskSmartInfo = [PSCustomObject]$hash
                $diskSmartInfo | Add-Member -TypeName "DiskSmartInfo"

                if ($ShowHistory)
                {
                    $diskSmartInfo | Add-Member -TypeName "DiskSmartInfo#DataHistory"
                }

                $diskSmartInfo
            }
        }
    }

    if ($UpdateHistory)
    {
        inUpdateHistoricalData -disksSmartData $disksSmartData -disksThresholds $disksThresholds -diskDrives $diskDrives -session $Session
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
                    AttributeName = $attrib.AttributeName
                    DataType = $attrib.DataType
                    IsCritical = $false
                    ConvertScriptBlock = $null
                    BetterValue = ''
                    Description = ''
                }

                if ($attrib.Keys -contains 'IsCritical')
                {
                    $newAttrib.IsCritical = $attrib.IsCritical
                }
                if ($attrib.Keys -contains 'ConvertScriptBlock')
                {
                    $newAttrib.ConvertScriptBlock = $attrib.ConvertScriptBlock
                }

                if (($index = $result.FindIndex([Predicate[PSCustomObject]]{$args[0].AttributeID -eq $attrib.AttributeID})) -ge 0)
                {
                    if ($attrib.Keys -notcontains 'IsCritical')
                    {
                        $newAttrib.IsCritical = $result[$index].IsCritical
                    }
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

    $dt = $smartAttributes.Where{$_.AttributeID -eq $smartData[$a]}.DataType

    switch ($dt.value__)
    {
        $([DataType]::bits48.value__)
        {
            $result = 0
            $dataStartOffset = $a + 5

            for ($offset = 0; $offset -lt 6; $offset++)
            {
                $result += $smartData[$dataStartOffset + $offset] * ( [math]::Pow(256, $offset) )
            }

            return $result
        }

        $([DataType]::bits24.value__)
        {
            $result = 0
            $dataStartOffset = $a + 5

            for ($offset = 0; $offset -lt 3; $offset++)
            {
                $result += $smartData[$dataStartOffset + $offset] * ( [math]::Pow(256, $offset) )
            }

            return $result
        }

        $([DataType]::bits16.value__)
        {
            $result = 0
            $dataStartOffset = $a + 5

            for ($offset = 0; $offset -lt 2; $offset++)
            {
                $result += $smartData[$dataStartOffset + $offset] * ( [math]::Pow(256, $offset) )
            }

            return $result
        }

        $([DataType]::temperature3.value__)
        {
            # 9, 7, 5
            $temps = @()

            for ($offset = 9; $offset -ge 5; $offset -= 2)
            {
                $value = $smartData[$a + $offset] + ($smartData[$a + $offset + 1] * 256)

                if ($value)
                {
                    $temps += $value
                }
            }

            return $temps
        }
    }
}

function inConvertData
{
    Param(
        $attribute
    )

    if ($convertScriptBlock = $smartAttributes.Where{$_.AttributeID -eq $attribute.ID}.ConvertScriptBlock)
    {
        $data = $attribute.Data
        return $convertScriptBlock.Invoke()
    }
    else
    {
        return $null
    }
}

function inUpdateHistoricalData
{
    Param (
        $disksSmartData,
        $disksThresholds,
        $diskDrives,
        $session
    )

    $historicalData = [System.Collections.Generic.List[PSCustomObject]]::new()

    foreach ($diskSmartData in $disksSmartData)
    {
        $smartData = $diskSmartData.VendorSpecific
        $thresholdsData = $disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName VendorSpecific

        $pNPDeviceId = $diskSmartData.InstanceName
        if ($pNPDeviceId -match '_\d$')
        {
            $pNPDeviceId = $pNPDeviceId.Remove($pNPDeviceId.Length - 2)
        }

        $diskDrive = $diskDrives | Where-Object -FilterScript { $_.PNPDeviceID -eq $pNPDeviceId }

        $model = inTrimDiskDriveModel -Model $diskDrive.Model

        $hash = [ordered]@{}

        $hash.Add('PNPDeviceId', $pNPDeviceId)

        $attributes = @()

        $smartAttributes = inOverwriteAttributes -model $model

        for ($a = $initialOffset; $a -lt $smartData.Count; $a += $attributeLength)
        {
            $attribute = [ordered]@{}

            $attributeID = $smartData[$a]

            if ($attributeID)
            {
                $attribute.Add("ID", $attributeID)
                $attribute.Add("Data", $(inGetAttributeData -smartData $smartData -a $a))

                $attributes += [PSCustomObject]$attribute
                }
        }

        if ($attributes)
        {
            $hash.Add("SmartData", $attributes)
            $historicalData.Add([PSCustomObject]$hash)
        }
    }

    if ($historicalData.Count)
    {
        $fullname = inComposeHistoricalDataFileName -session $session

        $hostHistoricalData = @{
            TimeStamp = Get-Date
            HistoricalData = $historicalData
        }

        Set-Content -Path $fullname -Value (ConvertTo-Json -InputObject $hostHistoricalData -Depth 5)
    }
}

function inGetHistoricalData
{
    Param (
        $session
    )

    $fullname = inComposeHistoricalDataFileName -session $session

    if ($content = Get-Content -Path $fullname -Raw -ErrorAction SilentlyContinue)
    {
        $converted = ConvertFrom-Json -InputObject $content

        if ($IsCoreCLR)
        {
            $timestamp = $converted.TimeStamp
        }
        # Windows PowerShell 5.1 ConvertTo-Json converts DateTime objects differently
        else
        {
            $timestamp = $converted.TimeStamp.DateTime
        }

        $hostHistoricalData = @{
            TimeStamp = $timestamp
            HistoricalData = @()
        }

        foreach ($object in $converted.HistoricalData)
        {
            $hash = [ordered]@{}
            $attributes = @()

            $hash.Add('PNPDeviceID', $object.PNPDeviceID)

            foreach ($at in $object.SmartData)
            {
                $attribute = [ordered]@{}

                $attribute.Add('ID', [int]$at.ID)

                if ($at.Data.Count -gt 1)
                {
                    $attribute.Add('Data', [long[]]$at.Data)
                }
                else
                {
                    $attribute.Add('Data', [long]$at.Data)
                }

                $attributes += [PSCustomObject]$attribute
            }

            $hash.Add('SmartData', $attributes)
            $hostHistoricalData.HistoricalData += [PSCustomObject]$hash
        }

        return $hostHistoricalData
    }
}

function inReportErrors
{
    foreach ($e in $Script:ErrorCreatingCimSession)
    {
        # $e
        # Write-Error -Message "ComputerName: ""$($e.OriginInfo.PSComputerName)"". $($e.Exception.Message)"
        $exception = [System.Exception]::new("ComputerName: ""$($e.OriginInfo.PSComputerName)"". $($e.Exception.Message)")
        [System.Management.Automation.ErrorRecord]::new($exception, $e.FullyQualifiedErrorId, $e.CategoryInfo.Category, $e.TargetObject)
    }
    foreach ($e in $Script:ErrorAccessingCimSession)
    {
        Write-Error -Message "ComputerName: ""$e"". The WinRM client cannot process the request because the CimSession cannot be accessed."
    }
    foreach ($e in $Script:ErrorAccessingClass)
    {
        Write-Error -Message "ComputerName: ""$($e.ComputerName)"", Protocol: $($e.Protocol). $($e.ErrorObject.Exception.Message)"
    }
}
