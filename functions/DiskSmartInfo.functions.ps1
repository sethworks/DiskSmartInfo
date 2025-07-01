function Get-DiskSmartInfo
{
    [CmdletBinding(PositionalBinding=$false,DefaultParameterSetName='ComputerName')]
    Param(
        [Alias('PSComputerName')]
        [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='ComputerName')]
        [string[]]$ComputerName,
        [Parameter(ValueFromPipeline,ParameterSetName='CimSession')]
        [CimSession[]]$CimSession,
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
        if ($CimSession -or $PSSession)
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

        elseif ($ComputerName)
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
        try
        {
            # foreach ($scd in $sessionsComputersDisks)
            # {
            #     if ($scd.ComputerName -and -not ($scd.CimSession = New-CimSession -ComputerName $scd.ComputerName -Credential $Credential @errorParameters))
            #     {
            #         inReportErrors -CimErrors $cimSessionErrors
            #         continue
            #     }

            #     inGetDiskSmartInfo `
            #         -Session $scd.CimSession `
            #         -Convert:$Convert `
            #         -CriticalAttributesOnly:$CriticalAttributesOnly `
            #         -DiskNumbers $scd.DiskNumber `
            #         -DiskModels $DiskModel `
            #         -AttributeIDs $attributeIDs `
            #         -Quiet:$Quiet `
            #         -ShowHistory:$ShowHistory `
            #         -UpdateHistory:$UpdateHistory
            # }
        }
        finally
        {
            # foreach ($scd in $sessionsComputersDisks)
            # {
            #     if ($scd.ComputerName -and $scd.CimSession)
            #     {
            #         Remove-CimSession -CimSession $scd.CimSession
            #     }
            # }

            # Remove unnecessary System.Management.Automation.Runspaces.RemotingErrorRecord objects from ErrorVariable
            inClearRemotingErrorRecords
        }
    }
}
