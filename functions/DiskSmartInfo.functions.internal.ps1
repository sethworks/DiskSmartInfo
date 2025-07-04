function inGetHostsSmartData
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

function inGetDiskSmartInfoCIM
{
        Param (
        # [System.Collections.Generic.List[System.Collections.Hashtable]]$HostsSmartData,
        $HostsSmartData,
        [switch]$Convert,
        [switch]$CriticalAttributesOnly,
        [int[]]$DiskNumbers,
        [string[]]$DiskModels,
        [int[]]$AttributeIDs,
        [switch]$Quiet,
        [switch]$ShowHistory,
        [switch]$UpdateHistory
    )

    $initialOffset = 2
    $attributeLength = 12

    foreach ($hostSmartData in $HostsSmartData)
    {
        if ($ShowHistory)
        {
            $hostHistoricalData = inGetHistoricalData -computerName $hostSmartData.ComputerName
        }

        foreach ($diskSmartData in $hostSmartData.disksSmartData)
        {
            $smartData = $diskSmartData.VendorSpecific
            $thresholdsData = $hostSmartData.disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName VendorSpecific
            $failurePredictStatus = $hostSmartData.disksFailurePredictStatus | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName PredictFailure

            $pNPDeviceId = $diskSmartData.InstanceName
            if ($pNPDeviceId -match '_\d$')
            {
                $pNPDeviceId = $pNPDeviceId.Remove($pNPDeviceId.Length - 2)
            }

            $diskDrive = $hostSmartData.diskDrives | Where-Object -FilterScript { $_.PNPDeviceID -eq $pNPDeviceId }

            $model = inTrimDiskDriveModel -Model $diskDrive.Model

            if ((-not $DiskNumbers.Count -and -not $DiskModels.Count) -or (isDiskNumberMatched -Index $diskDrive.Index) -or (isDiskModelMatched -Model $model))
            {
                $hash = [ordered]@{}

                if ($hostSmartData.ComputerName)
                {
                    $hash.Add('ComputerName', [string]$hostSmartData.ComputerName)
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

                        if ((-not $Quiet) -or (((isCritical -AttributeID $attributeID) -and $attribute.Data) -or (isThresholdExceeded -Attribute $attribute)))
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
            inUpdateHistoricalData -hostSmartData $hostSmartData
        }
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
            return inExtractAttributeData -smartData $smartData -startOffset ($a + 5) -byteCount 6
        }

        $([DataType]::bits24.value__)
        {
            return inExtractAttributeData -smartData $smartData -startOffset ($a + 5) -byteCount 3
        }

        $([DataType]::bits16.value__)
        {
            return inExtractAttributeData -smartData $smartData -startOffset ($a + 5) -byteCount 2
        }

        $([DataType]::temperature3.value__)
        {
            return inExtractAttributeTemps -smartData $smartData -a $a
        }

        default
        {
            return inExtractAttributeData -smartData $smartData -startOffset ($a + 5) -byteCount 6
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
