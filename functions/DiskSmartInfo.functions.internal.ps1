function inGetSourceSmartDataCIM
{
    Param (
        [Microsoft.Management.Infrastructure.CimSession[]]$CimSession,
        [System.Management.Automation.Runspaces.PSSession[]]$PSSession
    )

    $namespaceWMI = 'root/WMI'
    $classSmartData = 'MSStorageDriver_ATAPISmartData'
    $classThresholds = 'MSStorageDriver_FailurePredictThresholds'
    $classFailurePredictStatus = 'MSStorageDriver_FailurePredictStatus'
    $classDiskDrive = 'Win32_DiskDrive'

    $HostsSmartData = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()

    $errorParameters = @{
        ErrorVariable = 'instanceErrors'
        ErrorAction = 'SilentlyContinue'
    }

    foreach ($cs in $CimSession)
    {
        if (($diskDrives = Get-CimInstance -ClassName $classDiskDrive -CimSession $cs @errorParameters) -and
            ($disksSmartData = Get-CimInstance -Namespace $namespaceWMI -ClassName $classSmartData -CimSession $cs @errorParameters) -and
            ($disksThresholds = Get-CimInstance -Namespace $namespaceWMI -ClassName $classThresholds -CimSession $cs @errorParameters) -and
            ($disksFailurePredictStatus = Get-CimInstance -Namespace $namespaceWMI -ClassName $classFailurePredictStatus -CimSession $cs @errorParameters))
        {
            $HostsSmartData.Add(@{
                diskDrives = $diskDrives
                disksSmartData = $disksSmartData
                disksThresholds = $disksThresholds
                disksFailurePredictStatus = $disksFailurePredictStatus
                computerName = $cs.ComputerName
            })
        }
        else
        {
            inReportErrors -Errors $instanceErrors
        }
    }

    foreach ($ps in $PSSession)
    {
        Invoke-Command -Session $ps -ScriptBlock { $errorParameters = @{ ErrorVariable = 'instanceErrors'; ErrorAction = 'SilentlyContinue' } }
        $diskDrives = Invoke-Command -Session $ps -ScriptBlock { Get-CimInstance -ClassName $Using:classDiskDrive @errorParameters }
        $disksSmartData = Invoke-Command -Session $ps -ScriptBlock { Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classSmartData @errorParameters }
        $disksThresholds = Invoke-Command -Session $ps -ScriptBlock { Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classThresholds @errorParameters }
        $disksFailurePredictStatus = Invoke-Command -Session $ps -ScriptBlock { Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classFailurePredictStatus @errorParameters }
        $instanceErrors = Invoke-Command -Session $ps -ScriptBlock { $instanceErrors }

        if ($diskDrives -and $disksSmartData -and $disksThresholds -and $disksFailurePredictStatus)
        {
            $HostsSmartData.Add(@{
                diskDrives = $diskDrives
                disksSmartData = $disksSmartData
                disksThresholds = $disksThresholds
                disksFailurePredictStatus = $disksFailurePredictStatus
                computerName = $ps.ComputerName
            })
        }
        else
        {
            inReportErrors -Errors $instanceErrors
        }
    }

    if (-not $CimSession -and -not $PSSession)
    {
        if (($diskDrives = Get-CimInstance -ClassName $classDiskDrive @errorParameters) -and
            ($disksSmartData = Get-CimInstance -Namespace $namespaceWMI -ClassName $classSmartData @errorParameters) -and
            ($disksThresholds = Get-CimInstance -Namespace $namespaceWMI -ClassName $classThresholds @errorParameters) -and
            ($disksFailurePredictStatus = Get-CimInstance -Namespace $namespaceWMI -ClassName $classFailurePredictStatus @errorParameters))
        {
            $HostsSmartData.Add(@{
                diskDrives = $diskDrives
                disksSmartData = $disksSmartData
                disksThresholds = $disksThresholds
                disksFailurePredictStatus = $disksFailurePredictStatus
                computerName = $null
            })
        }
        else
        {
            inReportErrors -Errors $instanceErrors
        }
    }

    return $HostsSmartData
}

function inGetSmartDataStructureCIM
{
    Param (
        $SourceSmartDataCIM
    )

    $initialOffset = 2
    $attributeLength = 12

    $hostsSmartData = @()

    foreach ($sourceSmartData in $SourceSmartDataCIM)
    {
        $hostSmartData = [ordered]@{}

        if ($sourceSmartData.ComputerName)
        {
            $hostSmartData.Add('ComputerName', $sourceSmartData.ComputerName)
        }
        else
        {
            $hostSmartData.Add('ComputerName', $null)
        }

        $hostSmartData.Add('DisksSmartData', @())

        foreach ($diskSmartData in $sourceSmartData.disksSmartData)
        {
            $smartData = $diskSmartData.VendorSpecific
            $thresholdsData = $sourceSmartData.disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName VendorSpecific
            $failurePredictStatus = $sourceSmartData.disksFailurePredictStatus | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName PredictFailure

            $pNPDeviceId = $diskSmartData.InstanceName
            if ($pNPDeviceId -match '_\d$')
            {
                $pNPDeviceId = $pNPDeviceId.Remove($pNPDeviceId.Length - 2)
            }

            $diskDrive = $sourceSmartData.diskDrives | Where-Object -FilterScript { $_.PNPDeviceID -eq $pNPDeviceId }

            $model = inTrimDiskDriveModel -Model $diskDrive.Model

            $hash = [ordered]@{}
            $hash.Add('DiskNumber', [uint32]$diskDrive.Index)
            $hash.Add('DiskModel', [string]$model)
            $hash.Add('PNPDeviceId', [string]$pNPDeviceId)
            $hash.Add('PredictFailure', [bool]$failurePredictStatus)

            $attributes = @()

            $actualAttributesList = inUpdateActualAttributesList -model $model

            for ($attributeStart = $initialOffset; $attributeStart -lt $smartData.Count; $attributeStart += $attributeLength)
            {
                $attribute = [ordered]@{}

                $attributeID = $smartData[$attributeStart]

                if ($attributeID)
                {
                    $attribute.Add("ID", [byte]$attributeID)
                    $attribute.Add("IDHex", [string]$attributeID.ToString("X"))
                    $attribute.Add("Name", [string]$actualAttributesList.Where{$_.AttributeID -eq $attributeID}.AttributeName)
                    $attribute.Add("Threshold", [byte]$thresholdsData[$attributeStart + 1])
                    $attribute.Add("Value", [byte]$smartData[$attributeStart + 3])
                    $attribute.Add("Worst", [byte]$smartData[$attributeStart + 4])
                    $attribute.Add("Data", $(inGetAttributeData -actualAttributesList $actualAttributesList -smartData $smartData -attributeStart $attributeStart))

                    $attributes += $attribute
                }
            }

            $hash.Add("SmartData", $attributes)
            $hash.Add("AuxiliaryData", @{BytesPerSector=$diskDrive.BytesPerSector})

            $hostSmartData.DisksSmartData += $hash
        }

        $hostsSmartData += $hostSmartData
    }

    return $hostsSmartData
}

function inGetDiskSmartInfo
{
        Param (
        # [System.Collections.Generic.List[System.Collections.Hashtable]]$HostsSmartData,
        $HostsSmartData,
        [switch]$Convert,
        [switch]$CriticalAttributesOnly,
        [int[]]$DiskNumbers,
        [string[]]$DiskModels,
        [int[]]$AttributeIDs,
        [AttributeProperty[]]$AttributeProperties,
        [switch]$Quiet,
        [switch]$ShowHistory,
        [switch]$UpdateHistory,
        [switch]$Archive
    )

    foreach ($hostSmartData in $HostsSmartData)
    {
        if ($ShowHistory)
        {
            $hostHistoricalData = inGetHistoricalData -computerName $hostSmartData.ComputerName
        }

        foreach ($diskSmartData in $hostSmartData.DisksSmartData)
        {
            # Disk selection check
            if ((-not $DiskNumbers.Count -and -not $DiskModels.Count) -or (isDiskNumberMatched -Index $diskSmartData.DiskNumber) -or (isDiskModelMatched -Model $diskSmartData.DiskModel))
            {
                $hash = [ordered]@{}

                $hash.Add('ComputerName', [string]$hostSmartData.ComputerName)
                $hash.Add('DiskNumber', [uint32]$diskSmartData.DiskNumber)
                $hash.Add('DiskModel', [string]$diskSmartData.DiskModel)
                $hash.Add('PNPDeviceId', [string]$diskSmartData.PNPDeviceID)
                $hash.Add('PredictFailure', [bool]$diskSmartData.PredictFailure)

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

                $actualAttributesList = inUpdateActualAttributesList -model $hash.DiskModel

                if ($hostHistoricalData)
                {
                    $historicalAttributes = $hostHistoricalData.HistoricalData.Where{$_.PNPDeviceID -eq $hash.PNPDeviceId}.SmartData
                }

                foreach ($attributeSmartData in $diskSmartData.SmartData)
                {
                    # Attribute request check
                    if ((isAttributeRequested -attributeID $attributeSmartData.ID -actualAttributesList $actualAttributesList))
                    {
                        # Attribute criticality check
                        if ((-not $CriticalAttributesOnly) -or (isCritical -AttributeID $attributeSmartData.ID))
                        {
                            # Attribute quiet eligibility check
                            if ((-not $Quiet) -or
                                (((isCritical -AttributeID $attributeSmartData.ID) -and $attributeSmartData.Data) -or
                                (isThresholdExceeded -Value $attributeSmartData.Value -Threshold $attributeSmartData.Threshold)))
                            {
                                $attribute = [ordered]@{}
                                $attribute.Add('ID', $attributeSmartData.ID)
                                $attribute.Add('IDHex', $attributeSmartData.IDHex)
                                $attribute.Add('Name', $attributeSmartData.Name)
                                $attribute.Add('Threshold', $attributeSmartData.Threshold)
                                $attribute.Add('Value', $attributeSmartData.Value)
                                $attribute.Add('Worst', $attributeSmartData.Worst)
                                $attribute.Add('Data', $attributeSmartData.Data)

                                if ($ShowHistory)
                                {
                                    if ($hostHistoricalData)
                                    {
                                        $historicalAttributeData = $historicalAttributes.Where{$_.ID -eq $attribute.ID}.Data

                                        if ($Config.ShowUnchangedDataHistory -or
                                            (-not (isAttributeDataEqual -attributeData $attribute.Data -historicalAttributeData $historicalAttributeData)))
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
                }

                if ($attributes -or (-not $Config.SuppressResultsWithEmptySmartData -and -not $Quiet) -or $hash.PredictFailure)
                {
                    if ($AttributeProperties)
                    {
                        $formatProperties = $AttributeProperties.ForEach{$AttributePropertyFormat.($PSItem.ToString())} -join ', '
                        $scriptBlockString = '$this | Format-Table -Property ' + $formatProperties
                        $formatScriptBlock = [scriptblock]::Create($scriptBlockString)

                        $hash.Add("SmartData", (inSelectAttributeProperties -attributes $attributes -properties $AttributeProperties -formatScriptBlock $formatScriptBlock))

                        Add-Member -InputObject $hash.SmartData -TypeName 'DiskSmartAttributeCustom[]'
                        Add-Member -InputObject $hash.SmartData -MemberType ScriptMethod -Name FormatTable -Value $formatScriptBlock
                    }
                    else
                    {
                        $hash.Add("SmartData", $attributes)
                        Add-Member -InputObject $hash.SmartData -TypeName 'DiskSmartAttribute[]'
                    }

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
            inUpdateHistoricalData -hostSmartData $hostSmartData
        }

        if ($Archive)
        {
            inUpdateArchive -hostSmartData $hostSmartData
        }
    }
}

function inUpdateActualAttributesList
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
                        DataFormat = $attribute.DataFormat
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
        $actualAttributesList,
        $smartData,
        $attributeStart
    )

    $df = $actualAttributesList.Where{$_.AttributeID -eq $smartData[$attributeStart]}.DataFormat

    switch ($df.value__)
    {
        $([AttributeDataFormat]::bits48.value__)
        {
            return inExtractAttributeData -smartData $smartData -startOffset ($attributeStart + 5) -byteCount 6
        }

        $([AttributeDataFormat]::bits24.value__)
        {
            return inExtractAttributeData -smartData $smartData -startOffset ($attributeStart + 5) -byteCount 3
        }

        $([AttributeDataFormat]::bits16.value__)
        {
            return inExtractAttributeData -smartData $smartData -startOffset ($attributeStart + 5) -byteCount 2
        }

        $([AttributeDataFormat]::temperature3.value__)
        {
            return inExtractAttributeTemps -smartData $smartData -startOffset ($attributeStart + 5)
        }

        $([AttributeDataFormat]::bytes1032.value__)
        {
            return inExtractAttributeWords -smartData $smartData -startOffset ($attributeStart + 5) -words 0, 1
        }

        $([AttributeDataFormat]::bytes1054.value__)
        {
            return inExtractAttributeWords -smartData $smartData -startOffset ($attributeStart + 5) -words 0, 2
        }

        default
        {
            return inExtractAttributeData -smartData $smartData -startOffset ($attributeStart + 5) -byteCount 6
        }
    }
}

function inConvertData
{
    Param(
        $attribute
    )

    if ($convertScriptBlock = $actualAttributesList.Where{$_.AttributeID -eq $attribute.ID}.ConvertScriptBlock)
    {
        return $convertScriptBlock.Invoke($attribute.Data)
    }
    else
    {
        return $null
    }
}

function inReportErrors
{
    Param (
        $Errors
    )

    foreach ($err in $Errors)
    {
        # CIMSession
        if ($err.GetType().FullName -eq 'System.Management.Automation.Runspaces.RemotingErrorRecord')
        {
            if ($err.OriginInfo.PSComputerName)
            {
                $message = "ComputerName: ""$($err.OriginInfo.PSComputerName)"". $($err.Exception.Message)"
            }
            else
            {
                $message = $err.Exception.Message
            }
        }
        # PSSession
        elseif ($err.Exception.GetType().FullName -eq 'System.Management.Automation.Remoting.PSRemotingTransportException')
        {
            if ($err.ErrorDetails.Message -match '\[(?<ComputerName>\S+)]')
            {
                $message = "ComputerName: ""$($Matches.ComputerName)"". $($err.Exception.Message)"
            }
            else
            {
                $message = $err.Exception.Message
            }
        }

        $exception = [System.Exception]::new($message, $err.Exception)
        $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $err.FullyQualifiedErrorId, $err.CategoryInfo.Category, $err.TargetObject)
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
                if ($PSItem.GetType().FullName -eq 'System.Management.Automation.Runspaces.RemotingErrorRecord' -or
                    $PSItem.Exception.GetType().FullName -eq 'System.Management.Automation.Remoting.PSRemotingTransportException')
                {
                    $value.Remove($PSItem)
                    continue
                }
            }
            break
        }
    }
}
