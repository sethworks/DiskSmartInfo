function Get-DiskSmartInfo
{
    [CmdletBinding(DefaultParameterSetName='ComputerName')]
    Param(
        # [Parameter(Position=0,ParameterSetName='ComputerName')]
        # [Parameter(Position=0)]
        [Alias('PSComputerName')]
        [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='ComputerName')]
        [string[]]$ComputerName,
        # [Parameter(ParameterSetName='CimSession')]
        [Parameter(ValueFromPipeline,ParameterSetName='CimSession')]
        [CimSession[]]$CimSession,
        [switch]$ShowConvertedData,
        [switch]$CriticalAttributesOnly,
        [Alias('Index','Number','DeviceId')]
        [Parameter(ValueFromPipelineByPropertyName)]
        [ArgumentCompleter([DiskCompleter])]
        [int[]]$DiskNumber,
        [ArgumentCompleter([DiskCompleter])]
        [string[]]$DiskModel,
        [ValidateRange(1, 255)]
        [int[]]$AttributeID,
        [ValidatePattern("^(0?[1-9A-F])|([1-9A-F])([0-9A-F])$")]
        [string[]]$AttributeIDHex,
        [ArgumentCompleter([AttributeNameCompleter])]
        [string[]]$AttributeName,
        [Alias('WarningOrCriticalOnly','SilenceIfNotInWarningOrCriticalState')]
        [switch]$QuietIfOK
    )

    begin
    {
        $Script:ErrorCreatingCimSession = @()
        $Script:ErrorAccessingCimSession = @()
        $Script:ErrorAccessingClass = @()

        # Attributes
        $attributeIDs = [System.Collections.Generic.List[int]]::new()
        if ($AttributeID)
        {
            foreach ($at in $AttributeID)
            {
                if (-not $attributeIDs.Contains($at))
                {
                    $attributeIDs.Add($at)
                }
            }
        }
        if ($AttributeIDHex)
        {
            foreach ($at in $AttributeIDHex)
            {
                $value = [convert]::ToInt32($at, 16)
                if (-not $attributeIDs.Contains($value))
                {
                    $attributeIDs.Add($value)
                }
            }
        }
        if ($AttributeName)
        {
            foreach ($at in $AttributeName)
            {
                if ($value = $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeName -eq $at}))
                {
                    if (-not $attributeIDs.Contains($value.AttributeID))
                    {$attributeIDs.Add($value.AttributeID)}
                }
            }
        }

        $diskNumbers = [System.Collections.Generic.List[int]]::new()
        $computerNamesAndDiskNumbers = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()
        $cimSessions = [System.Collections.Generic.List[Microsoft.Management.Infrastructure.CimSession]]::new()
    }

    process
    {
        if ($ComputerName)
        {
            foreach ($cn in $ComputerName)
            {
                if (($in = $computerNamesAndDiskNumbers.FindIndex([Predicate[System.Collections.Hashtable]]{$args[0].ComputerName -eq $cn})) -ge 0)
                {
                    foreach ($dn in $DiskNumber)
                    {
                        if ($computerNamesAndDiskNumbers[$in].DiskNumber -notcontains $dn)
                        {
                            $computerNamesAndDiskNumbers[$in].DiskNumber += $dn
                        }
                    }
                }
                else
                {
                    if ($DiskNumber)
                    {
                        $computerNamesAndDiskNumbers.Add(@{ComputerName = $cn; DiskNumber=@($DiskNumber)})
                    }
                    else
                    {
                        $computerNamesAndDiskNumbers.Add(@{ComputerName = $cn; DiskNumber=@()})
                    }
                }
            }
        }
        else
        {
            foreach ($dn in $DiskNumber)
            {
                if (-not $diskNumbers.Contains($dn))
                {
                    $diskNumbers.Add($dn)
                }
            }
        }

        foreach ($cs in $CimSession)
        {
            if (-not $cimSessions.Contains($cs))
            {
                $cimSessions.Add($cs)
            }
        }
    }

    end
    {
        # ComputerName
        if ($computerNamesAndDiskNumbers)
        {
            try
            {
                if ($DebugPreference -eq 'Continue')
                {
                    $cimSessions = New-CimSession -ComputerName $computerNamesAndDiskNumbers.ComputerName
                }
                else
                {
                    $cimSessions = New-CimSession -ComputerName $computerNamesAndDiskNumbers.ComputerName -ErrorVariable Script:ErrorCreatingCimSession -ErrorAction SilentlyContinue
                }

                foreach ($cim in $cimSessions)
                {
                    inGetDiskSmartInfo `
                        -Session $cim `
                        -ShowConvertedData:$ShowConvertedData `
                        -CriticalAttributesOnly:$CriticalAttributesOnly `
                        -DiskNumbers $computerNamesAndDiskNumbers.Find([Predicate[System.Collections.Hashtable]]{$args[0].ComputerName -eq $cim.ComputerName}).DiskNumber `
                        -DiskModels $DiskModel `
                        -AttributeIDs $attributeIDs `
                        -QuietIfOK:$QuietIfOK
                }
            }
            finally
            {
                if ($cimSessions)
                {
                    Remove-CimSession -CimSession $cimSessions
                }
            }
        }

        # CimSession
        elseif ($cimSessions)
        {
            foreach ($cim in $cimSessions)
            {
                if ($cim.TestConnection())
                {
                    inGetDiskSmartInfo `
                        -Session $cim `
                        -ShowConvertedData:$ShowConvertedData `
                        -CriticalAttributesOnly:$CriticalAttributesOnly `
                        -DiskNumbers $diskNumbers `
                        -DiskModels $DiskModel `
                        -AttributeIDs $attributeIDs `
                        -QuietIfOK:$QuietIfOK
                }
                else
                {
                    $Script:ErrorAccessingCimSession += $cim.ComputerName
                }
            }
        }

        # Localhost
        else
        {
            inGetDiskSmartInfo `
                -ShowConvertedData:$ShowConvertedData `
                -CriticalAttributesOnly:$CriticalAttributesOnly `
                -DiskNumbers $diskNumbers `
                -DiskModels $DiskModel `
                -AttributeIDs $attributeIDs `
                -QuietIfOK:$QuietIfOK
        }

        # Error reporting
        inReportErrors
    }
}
