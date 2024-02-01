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
        [Alias('ShowConvertedData')]
        [switch]$ShowConverted,
        [switch]$CriticalAttributesOnly,
        [Alias('Index','Number','DeviceId')]
        [Parameter(ValueFromPipelineByPropertyName)]
        [ArgumentCompleter([DiskCompleter])]
        [int[]]$DiskNumber,
        [Alias('Model')]
        [ArgumentCompleter([DiskCompleter])]
        [string[]]$DiskModel,
        [ValidateRange(1, 255)]
        [int[]]$AttributeID,
        [ValidatePattern("^(0?[1-9A-F])|([1-9A-F])([0-9A-F])$")]
        [string[]]$AttributeIDHex,
        [ArgumentCompleter([AttributeNameCompleter])]
        [string[]]$AttributeName,
        [Alias('WarningOrCriticalOnly','SilenceIfNotInWarningOrCriticalState','QuietIfOK')]
        [switch]$Quiet,
        [Alias('ShowHistoricalData')]
        [switch]$ShowHistory,
        [Alias('UpdateHistoricalData')]
        [switch]$UpdateHistory
    )

    begin
    {
        $Script:ErrorCreatingCimSession = @()
        $Script:ErrorAccessingCimSession = @()
        $Script:ErrorAccessingClass = @()

        $attributeIDs = inComposeAttributeIDs -AttributeID $AttributeID -AttributeIDHex $AttributeIDHex -AttributeName $AttributeName

        # $diskNumbers = [System.Collections.Generic.List[int]]::new()
        # $computerNamesAndDiskNumbers = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()
        $computersAndDisks = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()
        $cimSessions = [System.Collections.Generic.List[Microsoft.Management.Infrastructure.CimSession]]::new()
    }

    process
    {
        if ($ComputerName)
        {
            foreach ($cn in $ComputerName)
            {
                # if (($in = $computerNamesAndDiskNumbers.FindIndex([Predicate[System.Collections.Hashtable]]{$args[0].ComputerName -eq $cn})) -ge 0)
                if (($in = $computersAndDisks.FindIndex([Predicate[System.Collections.Hashtable]]{$args[0].ComputerName -eq $cn})) -ge 0)
                {
                    if ($DiskNumber.Count)
                    {
                        foreach ($dn in $DiskNumber)
                        {
                            # if ($computerNamesAndDiskNumbers[$in].DiskNumber -notcontains $dn)
                            if ($computersAndDisks[$in].DiskNumber.Count -and ($computersAndDisks[$in].DiskNumber -notcontains $dn))
                            {
                                # $computerNamesAndDiskNumbers[$in].DiskNumber += $dn
                                $computersAndDisks[$in].DiskNumber += $dn
                            }
                        }
                    }
                    else
                    {
                        $computersAndDisks[$in].DiskNumber = @()
                    }
                }
                else
                {
                    if ($DiskNumber.Count)
                    {
                        # $computerNamesAndDiskNumbers.Add(@{ComputerName = $cn; DiskNumber=@($DiskNumber)})
                        $computersAndDisks.Add(@{ComputerName = $cn; Cim = $null; DiskNumber=@($DiskNumber)})
                    }
                    else
                    {
                        # $computerNamesAndDiskNumbers.Add(@{ComputerName = $cn; DiskNumber=@()})
                        $computersAndDisks.Add(@{ComputerName = $cn; Cim = $null; DiskNumber=@()})
                    }
                }
            }
        }
        else
        {
            if (($in = $computersAndDisks.FindIndex([Predicate[System.Collections.Hashtable]]{$args[0].ComputerName -eq $null})) -ge 0)
            {
                if ($DiskNumber.Count)
                {
                    foreach ($dn in $DiskNumber)
                    {
                        if ($computersAndDisks[$in].DiskNumber.Count -and ($computersAndDisks[$in].DiskNumber -notcontains $dn))
                        {
                            # $computerNamesAndDiskNumbers[$in].DiskNumber += $dn
                            $computersAndDisks[$in].DiskNumber += $dn
                        }
                    }
                }
                else
                {
                    $computersAndDisks[$in].DiskNumber = @()
                }
            }
            else
            {
                if ($DiskNumber.Count)
                {
                    # $computerNamesAndDiskNumbers.Add(@{ComputerName = $cn; DiskNumber=@($DiskNumber)})
                    $computersAndDisks.Add(@{ComputerName = $null; Cim = $null; DiskNumber=@($DiskNumber)})
                }
                else
                {
                    # $computerNamesAndDiskNumbers.Add(@{ComputerName = $cn; DiskNumber=@()})
                    $computersAndDisks.Add(@{ComputerName = $null; Cim = $null; DiskNumber=@()})
                }
            }
            # foreach ($dn in $DiskNumber)
            # {
            #     if (-not $diskNumbers.Contains($dn))
            #     {
            #         $diskNumbers.Add($dn)
            #     }
            # }
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
        # if ($computerNamesAndDiskNumbers)
        if ($computersAndDisks)
        {
            try
            {
                foreach ($cad in $computersAndDisks)
                {
                    if ($cad.ComputerName)
                    {
                        $cad.Cim = New-CimSession -ComputerName $cad.ComputerName -ErrorVariable Script:ErrorCreatingCimSession -ErrorAction SilentlyContinue
                    }

                    if (-not $cad.ComputerName -or $cad.Cim)
                    {
                        inGetDiskSmartInfo `
                        -Session $cad.Cim `
                        -ShowConverted:$ShowConverted `
                        -CriticalAttributesOnly:$CriticalAttributesOnly `
                        -DiskNumbers $cad.DiskNumber `
                        -DiskModels $DiskModel `
                        -AttributeIDs $attributeIDs `
                        -Quiet:$Quiet `
                        -ShowHistory:$ShowHistory `
                        -UpdateHistory:$UpdateHistory
                        # -DiskNumbers $computerNamesAndDiskNumbers.Find([Predicate[System.Collections.Hashtable]]{$args[0].ComputerName -eq $cim.ComputerName}).DiskNumber `
                    }
                }
                # if ($DebugPreference -eq 'Continue')
                # {
                #     $cimSessions = New-CimSession -ComputerName $computerNamesAndDiskNumbers.ComputerName
                # }
                # else
                # {
                #     $cimSessions = New-CimSession -ComputerName $computerNamesAndDiskNumbers.ComputerName -ErrorVariable Script:ErrorCreatingCimSession -ErrorAction SilentlyContinue
                # }

                # foreach ($cim in $cimSessions)
                # {
                    # inGetDiskSmartInfo `
                    #     -Session $cim `
                    #     -ShowConverted:$ShowConverted `
                    #     -CriticalAttributesOnly:$CriticalAttributesOnly `
                    #     -DiskNumbers $computerNamesAndDiskNumbers.Find([Predicate[System.Collections.Hashtable]]{$args[0].ComputerName -eq $cim.ComputerName}).DiskNumber `
                    #     -DiskModels $DiskModel `
                    #     -AttributeIDs $attributeIDs `
                    #     -Quiet:$Quiet `
                    #     -ShowHistory:$ShowHistory `
                    #     -UpdateHistory:$UpdateHistory
                # }
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
                        -ShowConverted:$ShowConverted `
                        -CriticalAttributesOnly:$CriticalAttributesOnly `
                        -DiskNumbers $diskNumbers `
                        -DiskModels $DiskModel `
                        -AttributeIDs $attributeIDs `
                        -Quiet:$Quiet `
                        -ShowHistory:$ShowHistory `
                        -UpdateHistory:$UpdateHistory
                }
                else
                {
                    $Script:ErrorAccessingCimSession += $cim.ComputerName
                }
            }
        }

        # Localhost
        # else
        # {
        #     inGetDiskSmartInfo `
        #         -ShowConverted:$ShowConverted `
        #         -CriticalAttributesOnly:$CriticalAttributesOnly `
        #         -DiskNumbers $diskNumbers `
        #         -DiskModels $DiskModel `
        #         -AttributeIDs $attributeIDs `
        #         -Quiet:$Quiet `
        #         -ShowHistory:$ShowHistory `
        #         -UpdateHistory:$UpdateHistory
        # }

        # Error reporting
        inReportErrors
    }
}
