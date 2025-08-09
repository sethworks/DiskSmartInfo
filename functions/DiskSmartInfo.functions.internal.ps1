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

    # Localhost
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
            $hash.Add('Device', [string]$pNPDeviceId)
            $hash.Add('PredictFailure', [bool]$failurePredictStatus)
            $hash.Add('DiskType', 'ATA')

            $attributes = @()

            $actualAttributesList = inUpdateActualAttributesList -model $model -diskType $hash.DiskType

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

function inGetSourceSmartDataCtl
{
    Param (
        [System.Management.Automation.Runspaces.PSSession[]]$PSSession
    )

    $HostsSmartData = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()

    foreach ($ps in $PSSession)
    {
        $disksSmartData = @()

        if (Invoke-Command -ScriptBlock { Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue } -Session $ps)
        {
            if (Invoke-Command -ScriptBlock { $IsLinux } -Session $ps)
            {
                $sbs = 'sudo smartctl --info --health --attributes'
            }
            else
            {
                $sbs = 'smartctl --info --health --attributes'
            }

            $devices = Invoke-Command -ScriptBlock { smartctl --scan } -Session $ps

            foreach ($device in $devices)
            {
                if ($device -match '^(?<device>/dev/\w+)')
                {
                    $sb = [scriptblock]::Create("$sbs $($Matches.device)")

                    $disksSmartData += @{
                        device = $Matches.device
                        diskSmartData = Invoke-Command -ScriptBlock $sb -Session $ps
                    }
                }
            }

            $HostsSmartData.Add(@{
                computerName = $ps.ComputerName
                disksSmartData = $disksSmartData
            })
        }
        else
        {
            $message = "ComputerName: ""$($ps.ComputerName)"". SmartCtl utility is not found."
            $exception = [System.Exception]::new($message)
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::NotInstalled, $null)
            $PSCmdlet.WriteError($errorRecord)
        }
    }

    # Localhost
    if (-not $PSSession)
    {
        $disksSmartData = @()

        if (Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue)
        {
            if ($IsLinux)
            {
                $sbs = 'sudo smartctl --info --health --attributes'
            }
            else
            {
                $sbs = 'smartctl --info --health --attributes'
            }

            $devices = Invoke-Command -ScriptBlock { smartctl --scan }

            foreach ($device in $devices)
            {
                if ($device -match '^(?<device>/dev/\w+)')
                {
                    $sb = [scriptblock]::Create("$sbs $($Matches.device)")

                    $disksSmartData += @{
                        device = $Matches.device
                        diskSmartData = Invoke-Command -ScriptBlock $sb
                    }
                }
            }

            $HostsSmartData.Add(@{
                computerName = $null
                disksSmartData = $disksSmartData
            })
        }
        else
        {
            $message = "SmartCtl utility is not found."
            $exception = [System.Exception]::new($message)
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::NotInstalled, $null)
            $PSCmdlet.WriteError($errorRecord)
        }
    }

    return $HostsSmartData
}

function inGetSmartDataStructureCtl
{
    Param (
        $SourceSmartDataCtl
    )

    $hostsSmartData = @()

    foreach ($sourceSmartData in $SourceSmartDataCtl)
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
            if ($diskSmartData.device[-1] -match '\d')
            {
                $diskNumber = [uint32]::Parse($diskSmartData.device[-1])
            }
            else
            {
                $diskNumber = [uint32]$diskSmartData.device[-1] - [uint32][char]'a'
            }

            if ($diskSmartData.diskSmartData -match '^(?:Device Model:|Model Number:)' | ForEach-Object { $PSItem -match '^(?:Device Model:|Model Number:)\s+(?<model>.+)$' })
            {
                $model = $Matches.model
            }
            else
            {
                $model = $null
            }

            # Because on Windows NVMe device can be /dev/sd_
            if ($diskSmartData.diskSmartData -match '^S?ATA Version')
            {
                $diskType = 'ATA'
            }
            elseif ($diskSmartData.diskSmartData -match '^NVMe Version')
            {
                $diskType = 'NVMe'
            }
            else
            {
                $diskType = $null
            }

            if ($diskSmartData.diskSmartData -match '^SMART overall-health self-assessment test result:' | ForEach-Object { $PSItem -match '^SMART overall-health self-assessment test result:\s+(?<failurePredictStatus>.+)$' })
            {
                $failurePredictStatus = $Matches.failurePredictStatus -ne 'PASSED'
            }
            else
            {
                $failurePredictStatus = $null
            }

            $hash = [ordered]@{}

            $hash.Add('DiskNumber', [uint32]$diskNumber)
            $hash.Add('DiskModel', [string]$model)
            $hash.Add('Device', [string]$diskSmartData.device)
            $hash.Add('PredictFailure', [bool]$failurePredictStatus)
            $hash.Add('DiskType', $diskType)

            $attributes = @()

            if ($hash.DiskType -eq 'ATA')
            {
                $actualAttributesList = inUpdateActualAttributesList -model $model -diskType $hash.DiskType

                $headerIndex = $diskSmartData.diskSmartData.IndexOf('ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE')

                if ($headerIndex -ge 0)
                {
                    $table = $diskSmartData.diskSmartData | Select-Object -Skip ($headerIndex + 1)

                    foreach ($entry in $table)
                    {
                        $attribute = [ordered]@{}

                        if ($entry -match '^\s*(?<id>\S+)\s+(?<name>\S+)\s+\S+\s+(?<value>\S+)\s+(?<worst>\S+)\s+(?<threshold>\S+)\s+\S+\s+\S+\s+\S+\s+(?<data>\S+.*)$')
                        {
                            $attribute.Add("ID", [byte]$Matches.id)
                            $attribute.Add("IDHex", [string]($attribute.ID.ToString("X")))

                            if ($Config.ReplaceSmartCtlAttributeNames)
                            {
                                $attribute.Add("Name", [string]$actualAttributesList.Where{$_.AttributeID -eq $attribute.ID}.AttributeName)
                            }
                            else
                            {
                                $attribute.Add("Name", [string]$Matches.name)
                            }

                            $attribute.Add("Threshold", [byte]$Matches.threshold)
                            $attribute.Add("Value", [byte]$Matches.value)
                            $attribute.Add("Worst", [byte]$Matches.worst)

                            $sourcedata = $Matches.data

                            # 32 (Min/Max 18/40)
                            if ($sourcedata -match '^(?<data>\d+) \(Min/Max (?<min>\d+)/(?<max>\d+)\)$')
                            {
                                $attribute.Add("Data", @([long]$Matches.data, [long]$Matches.min, [long]$Matches.max))
                            }
                            # 10/11
                            elseif ($sourcedata -match '^(?<first>\d+)/(?<second>\d+)$')
                            {
                                $attribute.Add("Data", @([long]$Matches.first, [long]$Matches.second))
                            }
                            # 1
                            else
                            {
                                $attribute.Add("Data", [long]$Matches.data)
                            }

                            $attributes += $attribute
                        }
                    }
                }

                $hash.Add("SmartData", $attributes)

                if ($diskSmartData.diskSmartData -match '^Sector sizes?:' | ForEach-Object { $PSItem -match '^Sector sizes?:\s+(?<sectorsize>\d+).*$' })
                {
                    $sectorSize = $Matches.sectorsize
                }
                else
                {
                    $sectorSize = $null
                }
                $hash.Add("AuxiliaryData", @{BytesPerSector=$sectorSize})
            }

            elseif ($hash.DiskType -eq 'NVMe')
            {
                $header = $diskSmartData.diskSmartData -like "SMART/Health Information (NVMe Log*"
                # Because result of the -like operator is an array
                $headerIndex = $diskSmartData.diskSmartData.IndexOf($header[0])

                if ($headerIndex -ge 0)
                {
                    $table = $diskSmartData.diskSmartData | Select-Object -Skip ($headerIndex + 1)

                    foreach ($entry in $table)
                    {
                        $attribute = [ordered]@{}

                        if ($entry -match '^\s*(?<name>.+):\s+(?<data>\S+.*)$')
                        {
                            $attribute.Add("Name", [string]$Matches.name)
                            $attribute.Add("Data", [string]$Matches.data)

                            $attributes += $attribute
                        }
                    }
                }

                $hash.Add("SmartData", $attributes)
            }

            $hostSmartData.DisksSmartData += $hash
        }

        $hostsSmartData += $hostSmartData
    }

    return $hostsSmartData
}

function inGetDiskSmartInfo
{
        Param (
        [System.Collections.Specialized.OrderedDictionary[]]$HostsSmartData,
        [switch]$Convert,
        [switch]$CriticalAttributesOnly,
        [int[]]$DiskNumbers,
        [string[]]$DiskModels,
        [string[]]$Devices,
        [hashtable[]]$RequestedAttributes,
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
            if ((-not $DiskNumbers.Count -and -not $DiskModels.Count -and -not $Devices.Count) -or
                (isDiskNumberMatched -Index $diskSmartData.DiskNumber) -or
                (isDiskModelMatched -Model $diskSmartData.DiskModel) -or
                (isDeviceMatched -Device $diskSmartData.Device))
            {
                $hash = [ordered]@{}

                $hash.Add('ComputerName', [string]$hostSmartData.ComputerName)
                $hash.Add('DiskNumber', [uint32]$diskSmartData.DiskNumber)
                $hash.Add('DiskModel', [string]$diskSmartData.DiskModel)
                $hash.Add('Device', [string]$diskSmartData.Device)
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

                if ($hostHistoricalData)
                {
                    $diskHistoricalData = $hostHistoricalData.HistoricalData.Where{$_.Device -eq $hash.Device}.SmartData
                }

                if ($diskSmartData.DiskType -eq 'ATA')
                {
                    $actualAttributesList = inUpdateActualAttributesList -model $hash.DiskModel -diskType $diskSmartData.DiskType

                    foreach ($attributeSmartData in $diskSmartData.SmartData)
                    {
                        # Attribute request check
                        if (isAttributeRequested -RequestedAttributes $RequestedAttributes -attributeSmartData $attributeSmartData -diskType $diskSmartData.DiskType)
                        {
                            # Attribute criticality check
                            if ((-not $CriticalAttributesOnly) -or (isCritical -actualAttributesList $actualAttributesList -attributeSmartData $attributeSmartData -diskType $diskSmartData.DiskType))
                            {
                                # Attribute quiet eligibility check
                                if ((-not $Quiet) -or
                                    (isCriticalThresholdExceeded -actualAttributesList $actualAttributesList -attributeSmartData $attributeSmartData -diskType $diskSmartData.DiskType) -or
                                    (isValueThresholdExceeded -Value $attributeSmartData.Value -Threshold $attributeSmartData.Threshold))
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
                                        $attribute.Add("DataHistory", $(inGetAttributeHistoricalData -diskHistoricalData $diskHistoricalData -attribute $attribute -diskType $diskSmartData.DiskType))
                                    }

                                    if ($Convert)
                                    {
                                        $attribute.Add("DataConverted", $(inConvertData -actualAttributesList $actualAttributesList -attribute $attribute))
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
                }
                elseif ($diskSmartData.DiskType -eq 'NVMe')
                {
                    $actualAttributesList = inUpdateActualAttributesList -model $hash.DiskModel -diskType $diskSmartData.DiskType

                    foreach ($attributeSmartData in $diskSmartData.SmartData)
                    {
                        # Attribute request check
                        if (isAttributeRequested -RequestedAttributes $RequestedAttributes -attributeSmartData $attributeSmartData -diskType $diskSmartData.DiskType)
                        {
                            # Attribute criticality check
                            if ((-not $CriticalAttributesOnly) -or (isCritical -actualAttributesList $actualAttributesList -attributeSmartData $attributeSmartData -diskType $diskSmartData.DiskType))
                            {
                                # Attribute quiet eligibility check
                                if ((-not $Quiet) -or
                                    (isCriticalThresholdExceeded -actualAttributesList $actualAttributesList -attributeSmartData $attributeSmartData -diskType $diskSmartData.DiskType))
                                {
                                    $attribute = [ordered]@{}
                                    $attribute.Add('Name', $attributeSmartData.Name)
                                    $attribute.Add('Data', $attributeSmartData.Data)

                                    if ($ShowHistory)
                                    {
                                        $attribute.Add("DataHistory", $(inGetAttributeHistoricalData -diskHistoricalData $diskHistoricalData -attribute $attribute -diskType $diskSmartData.DiskType))
                                    }

                                    $attributeObject = [PSCustomObject]$attribute
                                    $attributeObject | Add-Member -TypeName "DiskSmartAttributeNVMe"

                                    if ($ShowHistory)
                                    {
                                        $attributeObject | Add-Member -TypeName 'DiskSmartAttributeNVMe#DataHistory'
                                    }
                                    $attributes += $attributeObject
                                }
                            }
                        }
                    }
                }

                if ($attributes -or (-not $Config.SuppressResultsWithEmptySmartData -and -not $Quiet) -or $hash.PredictFailure)
                {
                    if ($diskSmartData.DiskType -eq 'ATA')
                    {
                        if (-not $AttributeProperties)
                        {
                            $hash.Add("SmartData", $attributes)
                            Add-Member -InputObject $hash.SmartData -TypeName 'DiskSmartAttribute[]'
                        }
                        else
                        {
                            $formatProperties = $AttributeProperties.ForEach{$AttributePropertyFormat.($PSItem.ToString())} -join ', '
                            $scriptBlockString = '$this | Format-Table -Property ' + $formatProperties
                            $formatScriptBlock = [scriptblock]::Create($scriptBlockString)

                            $hash.Add("SmartData", (inSelectAttributeProperties -attributes $attributes -properties $AttributeProperties -formatScriptBlock $formatScriptBlock -diskType $diskSmartData.DiskType))

                            Add-Member -InputObject $hash.SmartData -TypeName 'DiskSmartAttributeCustom[]'
                            Add-Member -InputObject $hash.SmartData -MemberType ScriptMethod -Name FormatTable -Value $formatScriptBlock
                        }
                    }
                    elseif ($diskSmartData.DiskType -eq 'NVMe')
                    {
                        if (-not $AttributeProperties)
                        {
                            $hash.Add("SmartData", $attributes)
                            Add-Member -InputObject $hash.SmartData -TypeName 'DiskSmartAttributeNVMe[]'
                        }
                        else
                        {
                            $formatProperties = $AttributeProperties.Where{$PSItem.ToString() -in 'AttributeName', 'Data', 'History'}.ForEach{$AttributePropertyFormat.($PSItem.ToString())} -join ', '
                            $scriptBlockString = '$this | Format-Table -Property ' + $formatProperties
                            $formatScriptBlock = [scriptblock]::Create($scriptBlockString)

                            $hash.Add("SmartData", (inSelectAttributeProperties -attributes $attributes -properties $AttributeProperties.Where{$PSItem.ToString() -in 'AttributeName', 'Data', 'History'} -formatScriptBlock $formatScriptBlock -diskType $diskSmartData.DiskType))

                            Add-Member -InputObject $hash.SmartData -TypeName 'DiskSmartAttributeNVMeCustom[]'
                            Add-Member -InputObject $hash.SmartData -MemberType ScriptMethod -Name FormatTable -Value $formatScriptBlock

                        }
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
