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
        [switch]$Quiet,
        [switch]$ShowHistory,
        [switch]$UpdateHistory
    )

    begin
    {
        $Script:ErrorCreatingCimSession = @()
        $Script:ErrorAccessingCimSession = @()
        $Script:ErrorAccessingClass = @()

        $attributeIDs = inComposeAttributeIDs -AttributeID $AttributeID -AttributeIDHex $AttributeIDHex -AttributeName $AttributeName

        $sessionsComputersDisks = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()
    }

    process
    {
        if ($CimSession)
        {
            foreach ($cs in $CimSession)
            {
                if (($in = $sessionsComputersDisks.FindIndex([Predicate[System.Collections.Hashtable]]{$args[0].CimSession.ComputerName -eq $cs.ComputerName})) -ge 0)
                {
                    if ($DiskNumber.Count)
                    {
                        foreach ($dn in $DiskNumber)
                        {
                            if ($sessionsComputersDisks[$in].DiskNumber.Count -and ($sessionsComputersDisks[$in].DiskNumber -notcontains $dn))
                            {
                                $sessionsComputersDisks[$in].DiskNumber += $dn
                            }
                        }
                    }
                    else
                    {
                        $sessionsComputersDisks[$in].DiskNumber = @()
                    }
                }
                else
                {
                    if ($DiskNumber.Count)
                    {
                        $sessionsComputersDisks.Add(@{CimSession = $cs; ComputerName = $null; DiskNumber=@($DiskNumber)})
                    }
                    else
                    {
                        $sessionsComputersDisks.Add(@{CimSession = $cs; ComputerName = $null; DiskNumber=@()})
                    }
                }
            }
        }
        elseif ($ComputerName)
        {
            foreach ($cn in $ComputerName)
            {
                if (($in = $sessionsComputersDisks.FindIndex([Predicate[System.Collections.Hashtable]]{$args[0].ComputerName -eq $cn})) -ge 0)
                {
                    if ($DiskNumber.Count)
                    {
                        foreach ($dn in $DiskNumber)
                        {
                            if ($sessionsComputersDisks[$in].DiskNumber.Count -and ($sessionsComputersDisks[$in].DiskNumber -notcontains $dn))
                            {
                                $sessionsComputersDisks[$in].DiskNumber += $dn
                            }
                        }
                    }
                    else
                    {
                        $sessionsComputersDisks[$in].DiskNumber = @()
                    }
                }
                else
                {
                    if ($DiskNumber.Count)
                    {
                        $sessionsComputersDisks.Add(@{CimSession = $null; ComputerName = $cn; DiskNumber=@($DiskNumber)})
                    }
                    else
                    {
                        $sessionsComputersDisks.Add(@{CimSession = $null; ComputerName = $cn; DiskNumber=@()})
                    }
                }
            }
        }
        else
        {
            if (($in = $sessionsComputersDisks.FindIndex([Predicate[System.Collections.Hashtable]]{($args[0].ComputerName -eq $null -and $args[0].CimSession -eq $null)})) -ge 0)
            {
                if ($DiskNumber.Count)
                {
                    foreach ($dn in $DiskNumber)
                    {
                        if ($sessionsComputersDisks[$in].DiskNumber.Count -and ($sessionsComputersDisks[$in].DiskNumber -notcontains $dn))
                        {
                            $sessionsComputersDisks[$in].DiskNumber += $dn
                        }
                    }
                }
                else
                {
                    $sessionsComputersDisks[$in].DiskNumber = @()
                }
            }
            else
            {
                if ($DiskNumber.Count)
                {
                    $sessionsComputersDisks.Add(@{CimSession = $null; ComputerName = $null; DiskNumber=@($DiskNumber)})
                }
                else
                {
                    $sessionsComputersDisks.Add(@{CimSession = $null; ComputerName = $null; DiskNumber=@()})
                }
            }
        }
    }

    end
    {
        try
        {
            foreach ($scd in $sessionsComputersDisks)
            {
                if ($scd.CimSession -and -not $scd.CimSession.TestConnection())
                {
                    $Script:ErrorAccessingCimSession += $scd.ComputerName
                    continue
                }
                elseif ($scd.ComputerName -and -not ($scd.CimSession = New-CimSession -ComputerName $scd.ComputerName -ErrorVariable Script:ErrorCreatingCimSession -ErrorAction SilentlyContinue))
                {
                    continue
                }
                else
                {
                    inGetDiskSmartInfo `
                        -Session $scd.CimSession `
                        -ShowConverted:$ShowConverted `
                        -CriticalAttributesOnly:$CriticalAttributesOnly `
                        -DiskNumbers $scd.DiskNumber `
                        -DiskModels $DiskModel `
                        -AttributeIDs $attributeIDs `
                        -Quiet:$Quiet `
                        -ShowHistory:$ShowHistory `
                        -UpdateHistory:$UpdateHistory
                }
            }
        }
        finally
        {
            foreach ($scd in $sessionsComputersDisks)
            {
                if ($scd.ComputerName -and $scd.CimSession)
                {
                    Remove-CimSession -CimSession $scd.CimSession
                }
            }
        }

        # Error reporting
        inReportErrors
    }
}
