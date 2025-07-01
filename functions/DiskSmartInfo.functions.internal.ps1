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
        ErrorVariable = 'cimInstanceErrors'
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
            inReportErrors -CimErrors $cimInstanceErrors
        }
    }

    foreach ($ps in $PSSession)
    {
        Invoke-Command -Session $ps -ScriptBlock { $errorParameters = @{ ErrorVariable = 'cimInstanceErrors'; ErrorAction = 'SilentlyContinue' } }
        $diskDrives = Invoke-Command -Session $ps -ScriptBlock { Get-CimInstance -ClassName $Using:classDiskDrive @errorParameters }
        $disksSmartData = Invoke-Command -Session $ps -ScriptBlock { Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classSmartData @errorParameters }
        $disksThresholds = Invoke-Command -Session $ps -ScriptBlock { Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classThresholds @errorParameters }
        $disksFailurePredictStatus = Invoke-Command -Session $ps -ScriptBlock { Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classFailurePredictStatus @errorParameters }
        $cimInstanceErrors = Invoke-Command -Session $ps -ScriptBlock { $cimInstanceErrors }

        # if (($diskDrives = Get-CimInstance -ClassName $classDiskDrive -CimSession $cs @errorParameters) -and
        #     ($disksSmartData = Get-CimInstance -Namespace $namespaceWMI -ClassName $classSmartData -CimSession $cs @errorParameters) -and
        #     ($disksThresholds = Get-CimInstance -Namespace $namespaceWMI -ClassName $classThresholds -CimSession $cs @errorParameters) -and
        #     ($disksFailurePredictStatus = Get-CimInstance -Namespace $namespaceWMI -ClassName $classFailurePredictStatus -CimSession $cs @errorParameters))

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
            inReportErrors -CimErrors $cimInstanceErrors
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
            inReportErrors -CimErrors $cimInstanceErrors
        }
    }

    # if ($HostsSmartData)
    # {
    return $HostsSmartData
    # }
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

    # $namespaceWMI = 'root/WMI'
    # $classSmartData = 'MSStorageDriver_ATAPISmartData'
    # $classThresholds = 'MSStorageDriver_FailurePredictThresholds'
    # $classFailurePredictStatus = 'MSStorageDriver_FailurePredictStatus'
    # $classDiskDrive = 'Win32_DiskDrive'

    $initialOffset = 2
    $attributeLength = 12

    # $errorParameters = @{
    #     ErrorVariable = 'cimInstanceErrors'
    #     ErrorAction = 'SilentlyContinue'
    # }

    # $parameters = @{}

    # if ($Session)
    # {
    #     $parameters.Add('CimSession', $Session)
    # }

    # if (($diskDrives = Get-CimInstance -ClassName $classDiskDrive @parameters @errorParameters) -and
    #     ($disksSmartData = Get-CimInstance -Namespace $namespaceWMI -ClassName $classSmartData @parameters @errorParameters) -and
    #     ($disksThresholds = Get-CimInstance -Namespace $namespaceWMI -ClassName $classThresholds @parameters @errorParameters) -and
    #     ($disksFailurePredictStatus = Get-CimInstance -Namespace $namespaceWMI -ClassName $classFailurePredictStatus @parameters @errorParameters))
    foreach ($hostSmartData in $HostsSmartData)
    {
        if ($ShowHistory)
        {
            # $hostHistoricalData = inGetHistoricalData -session $Session
            $hostHistoricalData = inGetHistoricalData -computerName $hostSmartData.ComputerName
        }

        foreach ($diskSmartData in $hostSmartData.disksSmartData)
        {
            $smartData = $diskSmartData.VendorSpecific
            # $thresholdsData = $disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName VendorSpecific
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

                # if ($Session)
                if ($hostSmartData.ComputerName)
                {
                    # $hash.Add('ComputerName', [string]$Session.ComputerName)
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
            # inUpdateHistoricalData -disksSmartData $disksSmartData -disksThresholds $disksThresholds -diskDrives $diskDrives -session $Session
            # inUpdateHistoricalData -disksSmartData $disksSmartData -disksThresholds $disksThresholds -diskDrives $diskDrives -computerName $hostSmartData.ComputerName
            inUpdateHistoricalData -hostSmartData $hostSmartData
        }
    }
    # else
    # {
    #     inReportErrors -CimErrors $cimInstanceErrors
    # }

}

# function inGetDiskSmartInfo
# {
#     Param (
#         [Microsoft.Management.Infrastructure.CimSession[]]$Session,
#         [switch]$Convert,
#         [switch]$CriticalAttributesOnly,
#         [int[]]$DiskNumbers,
#         [string[]]$DiskModels,
#         [int[]]$AttributeIDs,
#         [switch]$Quiet,
#         [switch]$ShowHistory,
#         [switch]$UpdateHistory
#     )

#     $namespaceWMI = 'root/WMI'
#     $classSmartData = 'MSStorageDriver_ATAPISmartData'
#     $classThresholds = 'MSStorageDriver_FailurePredictThresholds'
#     $classFailurePredictStatus = 'MSStorageDriver_FailurePredictStatus'
#     $classDiskDrive = 'Win32_DiskDrive'

#     $initialOffset = 2
#     $attributeLength = 12

#     $errorParameters = @{
#         ErrorVariable = 'cimInstanceErrors'
#         ErrorAction = 'SilentlyContinue'
#     }

#     $parameters = @{}

#     if ($Session)
#     {
#         $parameters.Add('CimSession', $Session)
#     }

#     if (($diskDrives = Get-CimInstance -ClassName $classDiskDrive @parameters @errorParameters) -and
#         ($disksSmartData = Get-CimInstance -Namespace $namespaceWMI -ClassName $classSmartData @parameters @errorParameters) -and
#         ($disksThresholds = Get-CimInstance -Namespace $namespaceWMI -ClassName $classThresholds @parameters @errorParameters) -and
#         ($disksFailurePredictStatus = Get-CimInstance -Namespace $namespaceWMI -ClassName $classFailurePredictStatus @parameters @errorParameters))
#     {
#         if ($ShowHistory)
#         {
#             $hostHistoricalData = inGetHistoricalData -session $Session
#         }

#         foreach ($diskSmartData in $disksSmartData)
#         {
#             $smartData = $diskSmartData.VendorSpecific
#             $thresholdsData = $disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName VendorSpecific
#             $failurePredictStatus = $disksFailurePredictStatus | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName PredictFailure

#             $pNPDeviceId = $diskSmartData.InstanceName
#             if ($pNPDeviceId -match '_\d$')
#             {
#                 $pNPDeviceId = $pNPDeviceId.Remove($pNPDeviceId.Length - 2)
#             }

#             $diskDrive = $diskDrives | Where-Object -FilterScript { $_.PNPDeviceID -eq $pNPDeviceId }

#             $model = inTrimDiskDriveModel -Model $diskDrive.Model

#             if ((-not $DiskNumbers.Count -and -not $DiskModels.Count) -or (isDiskNumberMatched -Index $diskDrive.Index) -or (isDiskModelMatched -Model $model))
#             {
#                 $hash = [ordered]@{}

#                 if ($Session)
#                 {
#                     $hash.Add('ComputerName', [string]$Session.ComputerName)
#                 }
#                 else
#                 {
#                     $hash.Add('ComputerName', $null)
#                 }

#                 $hash.Add('DiskNumber', [uint32]$diskDrive.Index)
#                 $hash.Add('DiskModel', [string]$model)
#                 $hash.Add('PNPDeviceId', [string]$pNPDeviceId)
#                 $hash.Add('PredictFailure', [bool]$failurePredictStatus)

#                 if ($ShowHistory)
#                 {
#                     if ($hostHistoricalData)
#                     {
#                         $hash.Add('HistoryDate', [datetime]$hostHistoricalData.TimeStamp)
#                     }
#                     else
#                     {
#                         $hash.Add('HistoryDate', $null)
#                     }
#                 }

#                 $attributes = @()

#                 $smartAttributes = inOverwriteAttributes -model $model

#                 if ($hostHistoricalData)
#                 {
#                     $historicalAttributes = $hostHistoricalData.HistoricalData.Where{$_.PNPDeviceID -eq $pNPDeviceId}.SmartData
#                 }

#                 for ($a = $initialOffset; $a -lt $smartData.Count; $a += $attributeLength)
#                 {
#                     $attribute = [ordered]@{}

#                     $attributeID = $smartData[$a]

#                     if ($attributeID -and
#                     (isAttributeRequested -attributeID $attributeID -attributeSet $smartAttributes) -and
#                     ((-not $CriticalAttributesOnly) -or (isCritical -AttributeID $attributeID)))
#                     {
#                         $attribute.Add("ID", [byte]$attributeID)
#                         $attribute.Add("IDHex", [string]$attributeID.ToString("X"))
#                         $attribute.Add("Name", [string]$smartAttributes.Where{$_.AttributeID -eq $attributeID}.AttributeName)
#                         $attribute.Add("Threshold", [byte]$thresholdsData[$a + 1])
#                         $attribute.Add("Value", [byte]$smartData[$a + 3])
#                         $attribute.Add("Worst", [byte]$smartData[$a + 4])
#                         $attribute.Add("Data", $(inGetAttributeData -smartAttributes $smartAttributes -smartData $smartData -a $a))

#                         if ((-not $Quiet) -or (((isCritical -AttributeID $attributeID) -and $attribute.Data) -or (isThresholdExceeded -Attribute $attribute)))
#                         {
#                             if ($ShowHistory)
#                             {
#                                 if ($hostHistoricalData)
#                                 {
#                                     $historicalAttributeData = $historicalAttributes.Where{$_.ID -eq $attributeID}.Data
#                                     if ($Config.ShowUnchangedDataHistory -or
#                                        -not (inCompareAttributeData -attributeData $attribute.Data -historicalAttributeData $historicalAttributeData))
#                                     {
#                                         $attribute.Add("DataHistory", $historicalAttributeData)
#                                     }
#                                     else
#                                     {
#                                         $attribute.Add("DataHistory", $null)
#                                     }
#                                 }
#                                 else
#                                 {
#                                     $attribute.Add("DataHistory", $null)
#                                 }
#                             }
#                             if ($Convert)
#                             {
#                                 $attribute.Add("DataConverted", $(inConvertData -attribute $attribute))
#                             }

#                             $attributeObject = [PSCustomObject]$attribute
#                             $attributeObject | Add-Member -TypeName "DiskSmartAttribute"

#                             if ($ShowHistory -and $Convert)
#                             {
#                                 $attributeObject | Add-Member -TypeName 'DiskSmartAttribute#DataHistoryDataConverted'
#                             }
#                             elseif ($ShowHistory)
#                             {
#                                 $attributeObject | Add-Member -TypeName 'DiskSmartAttribute#DataHistory'
#                             }
#                             elseif ($Convert)
#                             {
#                                 $attributeObject | Add-Member -TypeName 'DiskSmartAttribute#DataConverted'
#                             }
#                             $attributes += $attributeObject
#                         }
#                     }
#                 }

#                 if ($attributes -or (-not $Config.SuppressResultsWithEmptySmartData -and -not $Quiet) -or $failurePredictStatus)
#                 {
#                     $hash.Add("SmartData", $attributes)
#                     $diskSmartInfo = [PSCustomObject]$hash
#                     $diskSmartInfo | Add-Member -TypeName "DiskSmartInfo"

#                     if ($ShowHistory)
#                     {
#                         $diskSmartInfo | Add-Member -TypeName "DiskSmartInfo#DataHistory"
#                     }

#                     $diskSmartInfo
#                 }
#             }
#         }

#         if ($UpdateHistory)
#         {
#             inUpdateHistoricalData -disksSmartData $disksSmartData -disksThresholds $disksThresholds -diskDrives $diskDrives -session $Session
#         }
#     }
#     else
#     {
#         inReportErrors -CimErrors $cimInstanceErrors
#     }
# }

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

function inUpdateHistoricalData
{
    Param (
        $hostSmartData
        # $disksSmartData,
        # $disksThresholds,
        # $diskDrives,
        # $session
        # $computerName
    )

    $historicalData = [System.Collections.Generic.List[PSCustomObject]]::new()

    # foreach ($diskSmartData in $disksSmartData)
    foreach ($diskSmartData in $hostSmartData.disksSmartData)
    {
        $smartData = $diskSmartData.VendorSpecific
        # $thresholdsData = $disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName VendorSpecific
        $thresholdsData = $hostSmartData.disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName VendorSpecific

        $pNPDeviceId = $diskSmartData.InstanceName
        if ($pNPDeviceId -match '_\d$')
        {
            $pNPDeviceId = $pNPDeviceId.Remove($pNPDeviceId.Length - 2)
        }

        $diskDrive = $hostSmartData.diskDrives | Where-Object -FilterScript { $_.PNPDeviceID -eq $pNPDeviceId }

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
        # $fullname = inComposeHistoricalDataFileName -session $session
        # $fullname = inComposeHistoricalDataFileName -computerName $computerName
        $fullname = inComposeHistoricalDataFileName -computerName $hostSmartData.computerName

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
        # $session
        $computerName
    )

    # $fullname = inComposeHistoricalDataFileName -session $session
    $fullname = inComposeHistoricalDataFileName -computerName $computerName

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
