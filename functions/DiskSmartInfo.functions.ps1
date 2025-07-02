function Get-DiskSmartInfo
{
    [CmdletBinding(PositionalBinding=$false,DefaultParameterSetName='ComputerName')]
    Param(
        [Alias('PSComputerName')]
        [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='ComputerName')]
        [string[]]$ComputerName,
        [Parameter(ParameterSetName='ComputerName')]
        [ValidateSet('CimSession','PSSession')]
        [string]$Transport,
        [Parameter(ValueFromPipeline,ParameterSetName='Session')]
        [CimSession[]]$CimSession,
        [Parameter(ValueFromPipeline,ParameterSetName='Session')]
        [System.Management.Automation.Runspaces.PSSession[]]$PSSession,
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

        if (-not $IsLinux -and -not $IsMacOS -and -not $Transport -and $PSCmdlet.ParameterSetName -eq 'ComputerName')
        {
            $Transport = 'CimSession'
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
        $PSSessionQueries = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()
    }

    process
    {
        # if ($CimSession -or $PSSession)
        if ($PSCmdlet.ParameterSetName -eq 'Session')
        {
            foreach ($cs in $CimSession)
            {
                $HostsSmartData = inGetHostsSmartData -CimSession $cs
                inGetDiskSmartInfoCIM `
                    -HostsSmartData $HostsSmartData `
                    -Convert:$Convert `
                    -CriticalAttributesOnly:$CriticalAttributesOnly `
                    -DiskNumbers $DiskNumber `
                    -DiskModels $DiskModel `
                    -AttributeIDs $attributeIDs `
                    -Quiet:$Quiet `
                    -ShowHistory:$ShowHistory `
                    -UpdateHistory:$UpdateHistory
            }

            foreach ($ps in $PSSession)
            {
                $HostsSmartData = inGetHostsSmartData -PSSession $ps
                inGetDiskSmartInfoCIM `
                    -HostsSmartData $HostsSmartData `
                    -Convert:$Convert `
                    -CriticalAttributesOnly:$CriticalAttributesOnly `
                    -DiskNumbers $DiskNumber `
                    -DiskModels $DiskModel `
                    -AttributeIDs $attributeIDs `
                    -Quiet:$Quiet `
                    -ShowHistory:$ShowHistory `
                    -UpdateHistory:$UpdateHistory
            }
        }

        # elseif ($PSCmdlet.ParameterSetName -eq 'ComputerName')
        elseif ($ComputerName)
        {
            if ($Transport -eq 'CimSession')
            {
                foreach ($cn in $ComputerName)
                {
                    if (-not ($cs = New-CimSession -ComputerName $cn -Credential $Credential @errorParameters))
                    {
                        inReportErrors -CimErrors $cimSessionErrors
                        continue
                    }
                    $HostsSmartData = inGetHostsSmartData -CimSession $cs
                    Remove-CimSession -CimSession $cs
                    inGetDiskSmartInfoCIM `
                        -HostsSmartData $HostsSmartData `
                        -Convert:$Convert `
                        -CriticalAttributesOnly:$CriticalAttributesOnly `
                        -DiskNumbers $DiskNumber `
                        -DiskModels $DiskModel `
                        -AttributeIDs $attributeIDs `
                        -Quiet:$Quiet `
                        -ShowHistory:$ShowHistory `
                        -UpdateHistory:$UpdateHistory
                }
            }
            elseif ($Transport -eq 'PSSession')
            {
                foreach ($cn in $ComputerName)
                {
                    if ($Credential)
                    {
                        $ps = New-PSSession -ComputerName $cn -Credential $Credential @errorParameters
                    }
                    else
                    {
                        $ps = New-PSSession -ComputerName $cn @errorParameters
                    }
                    # if (-not ($ps = New-PSSession -ComputerName $cn -Credential $Credential @errorParameters))
                    if (-not $ps)
                    {
                        inReportErrors -CimErrors $cimSessionErrors
                        continue
                    }
                    $HostsSmartData = inGetHostsSmartData -PSSession $ps
                    Remove-PSSession -Session $ps
                    inGetDiskSmartInfoCIM `
                        -HostsSmartData $HostsSmartData `
                        -Convert:$Convert `
                        -CriticalAttributesOnly:$CriticalAttributesOnly `
                        -DiskNumbers $DiskNumber `
                        -DiskModels $DiskModel `
                        -AttributeIDs $attributeIDs `
                        -Quiet:$Quiet `
                        -ShowHistory:$ShowHistory `
                        -UpdateHistory:$UpdateHistory
                }
            }
        }
        # Localhost
        else
        {
            $HostsSmartData = inGetHostsSmartData
            inGetDiskSmartInfoCIM `
                -HostsSmartData $HostsSmartData `
                -Convert:$Convert `
                -CriticalAttributesOnly:$CriticalAttributesOnly `
                -DiskNumbers $DiskNumber `
                -DiskModels $DiskModel `
                -AttributeIDs $attributeIDs `
                -Quiet:$Quiet `
                -ShowHistory:$ShowHistory `
                -UpdateHistory:$UpdateHistory
        }
    }

    end
    {
        # Remove unnecessary System.Management.Automation.Runspaces.RemotingErrorRecord objects from ErrorVariable
        inClearRemotingErrorRecords
    }
}
