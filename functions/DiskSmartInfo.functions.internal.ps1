function inGetDiskSmartInfo
{
    Param (
        [Microsoft.Management.Infrastructure.CimSession[]]$Session,
        [switch]$Convert,
        [switch]$CriticalAttributesOnly,
        [int[]]$DiskNumbers,
        [string[]]$DiskModels,
        [int[]]$AttributeIDs,
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

    $errorParameters = @{
        ErrorVariable = 'cimInstanceErrors'
        ErrorAction = 'SilentlyContinue'
    }

    $parameters = @{}

    if ($Session)
    {
        $parameters.Add('CimSession', $Session)
    }

    if (($diskDrives = Get-CimInstance -ClassName $classDiskDrive @parameters @errorParameters) -and
        ($disksSmartData = Get-CimInstance -Namespace $namespaceWMI -ClassName $classSmartData @parameters @errorParameters) -and
        ($disksThresholds = Get-CimInstance -Namespace $namespaceWMI -ClassName $classThresholds @parameters @errorParameters) -and
        ($disksFailurePredictStatus = Get-CimInstance -Namespace $namespaceWMI -ClassName $classFailurePredictStatus @parameters @errorParameters))
    {
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

            if ((-not $DiskNumbers.Count -and -not $DiskModels.Count) -or (isDiskNumberMatched -Index $diskDrive.Index) -or (isDiskModelMatched -Model $model))
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
                    (isAttributeRequested -attributeID $attributeID -attributeSet $smartAttributes) -and
                    ((-not $CriticalAttributesOnly) -or (isCritical -AttributeID $attributeID)))
                    {
                        $attribute.Add("ID", [byte]$attributeID)
                        $attribute.Add("IDHex", [string]$attributeID.ToString("X"))
                        $attribute.Add("Name", [string]$smartAttributes.Where{$_.AttributeID -eq $attributeID}.AttributeName)
                        $attribute.Add("Threshold", [byte]$thresholdsData[$a + 1])
                        $attribute.Add("Value", [byte]$smartData[$a + 3])
                        $attribute.Add("Worst", [byte]$smartData[$a + 4])
                        $attribute.Add("Data", $(inGetAttributeData -smartAttributes $smartAttributes -smartData $smartData -a $a))

                        if ((-not $Quiet) -or (((isCritical -AttributeID $attributeID) -and $attribute.Data) -or (isThresholdReached -Attribute $attribute)))
                        {
                            if ($ShowHistory)
                            {
                                if ($hostHistoricalData)
                                {
                                    $historicalAttributeData = $historicalAttributes.Where{$_.ID -eq $attributeID}.Data
                                    if ($Config.ShowUnchangedDataHistory -or
                                       -not (inCompareAttributeData -attributeData $attribute.Data -historicalAttributeData $historicalAttributeData))
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
                            if ($Convert)
                            {
                                $attribute.Add("DataConverted", $(inConvertData -attribute $attribute))
                            }

                            $attributeObject = [PSCustomObject]$attribute
                            $attributeObject | Add-Member -TypeName "DiskSmartAttribute"

                            if ($ShowHistory -and $Convert)
                            {
                                $attributeObject | Add-Member -TypeName 'DiskSmartAttribute#DataHistoryDataConverted'
                            }
                            elseif ($ShowHistory)
                            {
                                $attributeObject | Add-Member -TypeName 'DiskSmartAttribute#DataHistory'
                            }
                            elseif ($Convert)
                            {
                                $attributeObject | Add-Member -TypeName 'DiskSmartAttribute#DataConverted'
                            }
                            $attributes += $attributeObject
                        }
                    }
                }

                if ($attributes -or (-not $Config.SuppressResultsWithEmptySmartData -and -not $Quiet) -or $failurePredictStatus)
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
    else
    {
        inReportErrors -CimErrors $cimInstanceErrors
    }
}

function inOverwriteAttributes
{
    Param (
        [string]$model
    )

    $result = [System.Collections.Generic.List[PSCustomObject]]::new($defaultAttributes)

    foreach ($proprietary in $proprietaryAttributes)
    {
        $patternMatched = $false
        foreach ($modelPattern in $proprietary.ModelPatterns)
        {
            if ($model -match $modelPattern)
            {
                $patternMatched = $true
                break
            }
        }

        if ($patternMatched)
        {
            foreach ($attribute in $proprietary.Attributes)
            {
                if (($index = $result.FindIndex([Predicate[PSCustomObject]]{$args[0].AttributeID -eq $attribute.AttributeID})) -ge 0)
                {
                    $newAttribute = [ordered]@{
                        AttributeID = $attribute.AttributeID
                        AttributeName = $attribute.AttributeName
                        DataType = $attribute.DataType
                        IsCritical = $result[$index].IsCritical
                        ConvertScriptBlock = $result[$index].ConvertScriptBlock
                    }

                    if ($attribute.Keys -contains 'IsCritical')
                    {
                        $newAttribute.IsCritical = $attribute.IsCritical
                    }
                    if ($attribute.Keys -contains 'ConvertScriptBlock')
                    {
                        $newAttribute.ConvertScriptBlock = $attribute.ConvertScriptBlock
                    }

                    $result[$index] = [PSCustomObject]$newAttribute
                }
                else
                {
                    $result.Add([PSCustomObject]$attribute)
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
        $smartAttributes,
        $smartData,
        $a
    )

    $dt = $smartAttributes.Where{$_.AttributeID -eq $smartData[$a]}.DataType

    switch ($dt.value__)
    {
        $([DataType]::bits48.value__)
        {
            [long]$result = 0
            $dataStartOffset = $a + 5

            for ($offset = 0; $offset -lt 6; $offset++)
            {
                $result += $smartData[$dataStartOffset + $offset] * ( [math]::Pow(256, $offset) )
            }

            return $result
        }

        $([DataType]::bits24.value__)
        {
            [long]$result = 0
            $dataStartOffset = $a + 5

            for ($offset = 0; $offset -lt 3; $offset++)
            {
                $result += $smartData[$dataStartOffset + $offset] * ( [math]::Pow(256, $offset) )
            }

            return $result
        }

        $([DataType]::bits16.value__)
        {
            [long]$result = 0
            $dataStartOffset = $a + 5

            for ($offset = 0; $offset -lt 2; $offset++)
            {
                $result += $smartData[$dataStartOffset + $offset] * ( [math]::Pow(256, $offset) )
            }

            return $result
        }

        $([DataType]::temperature3.value__)
        {
            $temps = @([long]$smartData[$a + 5])

            for ($offset = 6; $offset -le 10; $offset++)
            {
                if ($smartData[$a + $offset] -ne 0 -and $smartData[$a + $offset] -ne 255)
                {
                    $temps += [long]$smartData[$a + $offset]
                }

                if ($temps.Count -eq 3)
                {
                    if ($temps[1] -gt $temps[2])
                    {
                        $t = $temps[1]
                        $temps[1] = $temps[2]
                        $temps[2] = $t
                    }
                    break
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
        return $convertScriptBlock.Invoke($attribute.Data)
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
                $attribute.Add("Data", $(inGetAttributeData -smartAttributes $smartAttributes -smartData $smartData -a $a))

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
            TimeStamp = [datetime]$timestamp
            HistoricalData = @()
        }

        foreach ($object in $converted.HistoricalData)
        {
            $hash = [ordered]@{}
            $attributes = @()

            $hash.Add('PNPDeviceID', [string]$object.PNPDeviceID)

            foreach ($at in $object.SmartData)
            {
                $attribute = [ordered]@{}

                $attribute.Add('ID', [byte]$at.ID)

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
    Param (
        $CimErrors
    )

    foreach ($cimError in $CimErrors)
    {
        if ($cimError.OriginInfo.PSComputerName)
        {
            $message = "ComputerName: ""$($cimError.OriginInfo.PSComputerName)"". $($cimError.Exception.Message)"
        }
        else
        {
            $message = $cimError.Exception.Message
        }

        $exception = [System.Exception]::new($message, $cimError.Exception)
        $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $cimError.FullyQualifiedErrorId, $cimError.CategoryInfo.Category, $cimError.TargetObject)
        $PSCmdlet.WriteError($errorRecord)
    }
}

function inClearRemotingErrorRecords
{
    if ($PSCmdlet.MyInvocation.BoundParameters.ErrorVariable)
    {
        $value = $PSCmdlet.SessionState.PSVariable.GetValue($PSCmdlet.MyInvocation.BoundParameters.ErrorVariable)
        while ($true)
        {
            $value.ForEach{
                if ($PSItem.GetType().FullName -eq 'System.Management.Automation.Runspaces.RemotingErrorRecord')
                {
                    $value.Remove($PSItem)
                    continue
                }
            }
            break
        }
    }
}
