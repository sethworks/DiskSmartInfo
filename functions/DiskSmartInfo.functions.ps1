function Get-DiskSmartInfo
{
    [CmdletBinding(PositionalBinding=$false,DefaultParameterSetName='ComputerName')]
    Param(
        [Alias('PSComputerName')]
        [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='ComputerName')]
        [string[]]$ComputerName,
        [Parameter(ValueFromPipeline,ParameterSetName='CimSession')]
        [CimSession[]]$CimSession,
        [switch]$Convert,
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
        [switch]$UpdateHistory,
        [Parameter(Position=1,ParameterSetName='ComputerName')]
        [pscredential]$Credential
    )

    begin
    {
        if ($IsLinux -or $IsMacOS)
        {
            $message = "Platform is not supported"
            $exception = [System.Exception]::new($message)
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::NotImplemented, $null)
            $PSCmdlet.WriteError($errorRecord)
            break
        }

        if ($Credential -and -not $ComputerName -and -not $PSCmdlet.MyInvocation.ExpectingInput)
        {
            Write-Warning -Message "The -Credential parameter is used only for connecting to computers, listed or bound to the -ComputerName parameter."
        }

        $errorParameters = @{
            ErrorVariable = 'cimSessionErrors'
            ErrorAction = 'SilentlyContinue'
        }

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
                if ($scd.ComputerName -and -not ($scd.CimSession = New-CimSession -ComputerName $scd.ComputerName -Credential $Credential @errorParameters))
                {
                    inReportErrors -CimErrors $cimSessionErrors
                    continue
                }

                inGetDiskSmartInfo `
                    -Session $scd.CimSession `
                    -Convert:$Convert `
                    -CriticalAttributesOnly:$CriticalAttributesOnly `
                    -DiskNumbers $scd.DiskNumber `
                    -DiskModels $DiskModel `
                    -AttributeIDs $attributeIDs `
                    -Quiet:$Quiet `
                    -ShowHistory:$ShowHistory `
                    -UpdateHistory:$UpdateHistory
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

            # Remove unnecessary System.Management.Automation.Runspaces.RemotingErrorRecord objects from ErrorVariable
            inClearRemotingErrorRecords
        }


        # $length = $PSCmdlet.SessionState.PSVariable.GetValue($PSCmdlet.MyInvocation.BoundParameters.ErrorVariable).Count
        # $value = $PSCmdlet.SessionState.PSVariable.Get($PSCmdlet.MyInvocation.BoundParameters.ErrorVariable).Value
        # $value.RemoveAt(0)
        # $PSCmdlet.SessionState.PSVariable.Get($PSCmdlet.MyInvocation.BoundParameters.ErrorVariable).Value.RemoveAt($length - 1)

        # while ($value.ForEach{$PSItem.GetType().FullName} -contains 'System.Management.Automation.Runspaces.RemotingErrorRecord')
        # {
            #     $value.ForEach{if ($PSItem.GetType().FullName -eq 'System.Management.Automation.Runspaces.RemotingErrorRecord') {$value.Remove($PSItem); continue}}
            # }

        # if ($PSCmdlet.MyInvocation.BoundParameters.ErrorVariable)
        # {
        #     $value = $PSCmdlet.SessionState.PSVariable.GetValue($PSCmdlet.MyInvocation.BoundParameters.ErrorVariable)
        #     while ($true)
        #     {
        #         $value.ForEach{
        #             if ($PSItem.GetType().FullName -eq 'System.Management.Automation.Runspaces.RemotingErrorRecord')
        #             {
        #                 $value.Remove($PSItem)
        #                 continue
        #             }
        #         }
        #         break
        #     }
        # }
    }
}
