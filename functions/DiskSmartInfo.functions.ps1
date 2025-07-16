function Get-DiskSmartInfo
{
    [CmdletBinding(PositionalBinding=$false,DefaultParameterSetName='ComputerName')]
    Param(
        [Alias('PSComputerName')]
        [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='ComputerName')]
        [string[]]$ComputerName,
        [Parameter(ParameterSetName='ComputerName')]
        [ValidateSet('CimSession','PSSession','SSHSession')]
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
        [AttributeProperty[]]$AttributeProperty,
        [switch]$Quiet,
        [switch]$ShowHistory,
        [switch]$UpdateHistory,
        [Parameter(Position=1,ParameterSetName='ComputerName')]
        [pscredential]$Credential
    )

    begin
    {
        # Restrictions
        if ($IsLinux -or $IsMacOS)
        {
            $message = "Platform is not supported"
            $exception = [System.Exception]::new($message)
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::NotImplemented, $null)
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }

        if (-not $IsCoreCLR -and $Transport -eq 'SSHSession')
        {
            $message = "PSSession with SSH transport is not supported in Windows PowerShell 5.1 and earlier."
            $exception = [System.Exception]::new($message)
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::NotImplemented, $null)
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }

        # Notifications
        if ($Credential -and -not $ComputerName -and -not $PSCmdlet.MyInvocation.ExpectingInput)
        {
            Write-Warning -Message "The -Credential parameter is used only for connecting to computers, listed or bound to the -ComputerName parameter."
        }

        if ($Credential -and $Transport -eq 'SSHSession')
        {
            Write-Warning -Message "The -Credential parameter is not used with SSHSession transport."
        }

        # Defaults
        if (-not $IsLinux -and -not $IsMacOS -and $PSCmdlet.ParameterSetName -eq 'ComputerName' -and -not $Transport)
        {
            $Transport = 'CimSession'
        }

        if ($AttributeProperty)
        {
            $AttributeProperty = $AttributeProperty | Select-Object -Unique

            if ('History' -in $AttributeProperty)
            {
                $ShowHistory = $true
            }

            if ('Converted' -in $AttributeProperty)
            {
                $Convert = $true
            }
        }

        $errorParameters = @{
            ErrorVariable = 'sessionErrors'
            ErrorAction = 'SilentlyContinue'
        }

        $attributeIDs = inComposeAttributeIDs -AttributeID $AttributeID -AttributeIDHex $AttributeIDHex -AttributeName $AttributeName

        $sessionsComputersDisks = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()
        $PSSessionQueries = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()
    }

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Session')
        {
            foreach ($cs in $CimSession)
            {
                $SourceSmartDataCIM = inGetSourceSmartDataCIM -CimSession $cs

                $HostsSmartData = inGetSmartDataStructureCIM -SourceSmartDataCIM $SourceSmartDataCIM

                inGetDiskSmartInfo `
                    -HostsSmartData $HostsSmartData `
                    -Convert:$Convert `
                    -CriticalAttributesOnly:$CriticalAttributesOnly `
                    -DiskNumbers $DiskNumber `
                    -DiskModels $DiskModel `
                    -AttributeIDs $attributeIDs `
                    -AttributeProperties $AttributeProperty `
                    -Quiet:$Quiet `
                    -ShowHistory:$ShowHistory `
                    -UpdateHistory:$UpdateHistory
            }

            foreach ($ps in $PSSession)
            {
                $SourceSmartDataCIM = inGetSourceSmartDataCIM -PSSession $ps

                $HostsSmartData = inGetSmartDataStructureCIM -SourceSmartDataCIM $SourceSmartDataCIM

                inGetDiskSmartInfo `
                    -HostsSmartData $HostsSmartData `
                    -Convert:$Convert `
                    -CriticalAttributesOnly:$CriticalAttributesOnly `
                    -DiskNumbers $DiskNumber `
                    -DiskModels $DiskModel `
                    -AttributeIDs $attributeIDs `
                    -AttributeProperties $AttributeProperty `
                    -Quiet:$Quiet `
                    -ShowHistory:$ShowHistory `
                    -UpdateHistory:$UpdateHistory
            }
        }

        elseif ($ComputerName)
        {
            if ($Transport -eq 'CimSession')
            {
                foreach ($cn in $ComputerName)
                {
                    if (-not ($cs = New-CimSession -ComputerName $cn -Credential $Credential @errorParameters))
                    {
                        inReportErrors -Errors $sessionErrors
                        continue
                    }

                    try
                    {
                        $SourceSmartDataCIM = inGetSourceSmartDataCIM -CimSession $cs

                        $HostsSmartData = inGetSmartDataStructureCIM -SourceSmartDataCIM $SourceSmartDataCIM

                        inGetDiskSmartInfo `
                            -HostsSmartData $HostsSmartData `
                            -Convert:$Convert `
                            -CriticalAttributesOnly:$CriticalAttributesOnly `
                            -DiskNumbers $DiskNumber `
                            -DiskModels $DiskModel `
                            -AttributeIDs $attributeIDs `
                            -AttributeProperties $AttributeProperty `
                            -Quiet:$Quiet `
                            -ShowHistory:$ShowHistory `
                            -UpdateHistory:$UpdateHistory
                    }
                    finally
                    {
                        Remove-CimSession -CimSession $cs
                    }
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

                    if (-not $ps)
                    {
                        inReportErrors -Errors $sessionErrors
                        continue
                    }

                    try
                    {
                        $SourceSmartDataCIM = inGetSourceSmartDataCIM -PSSession $ps

                        $HostsSmartData = inGetSmartDataStructureCIM -SourceSmartDataCIM $SourceSmartDataCIM

                        inGetDiskSmartInfo `
                            -HostsSmartData $HostsSmartData `
                            -Convert:$Convert `
                            -CriticalAttributesOnly:$CriticalAttributesOnly `
                            -DiskNumbers $DiskNumber `
                            -DiskModels $DiskModel `
                            -AttributeIDs $attributeIDs `
                            -AttributeProperties $AttributeProperty `
                            -Quiet:$Quiet `
                            -ShowHistory:$ShowHistory `
                            -UpdateHistory:$UpdateHistory
                    }
                    finally
                    {
                        Remove-PSSession -Session $ps
                    }
                }
            }
            elseif ($Transport -eq 'SSHSession')
            {
                foreach ($cn in $ComputerName)
                {
                    if (-not ($ps = New-PSSession -HostName $cn @errorParameters))
                    {
                        inReportErrors -Errors $sessionErrors
                        continue
                    }

                    try
                    {
                        $SourceSmartDataCIM = inGetSourceSmartDataCIM -PSSession $ps

                        $HostsSmartData = inGetSmartDataStructureCIM -SourceSmartDataCIM $SourceSmartDataCIM

                        inGetDiskSmartInfo `
                            -HostsSmartData $HostsSmartData `
                            -Convert:$Convert `
                            -CriticalAttributesOnly:$CriticalAttributesOnly `
                            -DiskNumbers $DiskNumber `
                            -DiskModels $DiskModel `
                            -AttributeIDs $attributeIDs `
                            -AttributeProperties $AttributeProperty `
                            -Quiet:$Quiet `
                            -ShowHistory:$ShowHistory `
                            -UpdateHistory:$UpdateHistory
                    }
                    finally
                    {
                        Remove-PSSession -Session $ps
                    }
                }
            }
        }
        # Localhost
        else
        {
            $SourceSmartDataCIM = inGetSourceSmartDataCIM -CimSession $cs

            $HostsSmartData = inGetSmartDataStructureCIM -SourceSmartDataCIM $SourceSmartDataCIM

            inGetDiskSmartInfo `
                -HostsSmartData $HostsSmartData `
                -Convert:$Convert `
                -CriticalAttributesOnly:$CriticalAttributesOnly `
                -DiskNumbers $DiskNumber `
                -DiskModels $DiskModel `
                -AttributeIDs $attributeIDs `
                -AttributeProperties $AttributeProperty `
                -Quiet:$Quiet `
                -ShowHistory:$ShowHistory `
                -UpdateHistory:$UpdateHistory
        }
    }

    end
    {
        # Remove unnecessary System.Management.Automation.Runspaces.RemotingErrorRecord (CIMSession errors) objects
        # or errors with exception System.Management.Automation.Remoting.PSRemotingTransportException (PSSession errors) from ErrorVariable
        inClearRemotingErrorRecords
    }
}
