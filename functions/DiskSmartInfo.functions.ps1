function Get-DiskSmartInfo
{
    [CmdletBinding(PositionalBinding=$false,DefaultParameterSetName='ComputerName')]
    Param(
        [Alias('PSComputerName')]
        [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='ComputerName')]
        [string[]]$ComputerName,
        [Parameter(ParameterSetName='ComputerName')]
        [ValidateSet('CimSession','PSSession','SSHSession','SSHClient')]
        [string]$Transport,
        [Parameter(ValueFromPipeline,ParameterSetName='Session')]
        [CimSession[]]$CimSession,
        [Parameter(ValueFromPipeline,ParameterSetName='Session')]
        [System.Management.Automation.Runspaces.PSSession[]]$PSSession,
        [ValidateSet('CIM','SmartCtl')]
        [string]$Source,
        [switch]$Convert,
        [Alias('CriticalAttributesOnly')]
        [switch]$Critical,
        [Alias('Index','Number','DeviceId')]
        [Parameter(ValueFromPipelineByPropertyName)]
        [ArgumentCompleter([DiskCompleter])]
        [int[]]$DiskNumber,
        [Alias('Model')]
        [ArgumentCompleter([DiskCompleter])]
        [string[]]$DiskModel,
        [string[]]$Device,
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
        [switch]$Archive,
        [Parameter(Position=1,ParameterSetName='ComputerName')]
        [pscredential]$Credential,
        [string]$SmartCtlOption,
        [Parameter(ParameterSetName='ComputerName')]
        [switch]$SSHClientSudo
    )

    begin
    {
        # Restrictions
        if ($IsLinux -or $IsMacOS)
        {
            $message = "Platform is not supported."
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

        # Get-DiskSmartInfo -Source SmartCtl -CimSession $cs
        # Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | Get-DiskSmartInfo -Source SmartCtl -CimSession $cs

        # Get-DiskSmartInfo -Source SmartCtl -Transport CIMSession
        # ComputerName, Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | Get-DiskSmartInfo -Source SmartCtl -Transport CIMSession
        if (-not $IsLinux -and -not $IsMacOS -and $Source -eq 'SmartCtl' -and ($CimSession -or $Transport -eq 'CIMSession'))
        {
            $message = "CIMSession transport only supports CIM source."
            $exception = [System.Exception]::new($message)
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::InvalidArgument, $null)
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }

        # Get-DiskSmartInfo -Source SmartCtl -ComputerName $cn
        # Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | Get-DiskSmartInfo -Source SmartCtl -ComputerName $cn
        if (-not $IsLinux -and -not $IsMacOS -and $Source -eq 'SmartCtl' -and $ComputerName -and -not $Transport)
        {
            $message = "Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source."
            $exception = [System.Exception]::new($message)
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::InvalidArgument, $null)
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }

        # Get-DiskSmartInfo -Transport SSHClient -Source CIM
        # Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | Get-DiskSmartInfo -Transport SSHClient -Source CIM
        if (-not $IsLinux -and -not $IsMacOS -and $Transport -eq 'SSHClient' -and $Source -eq 'CIM')
        {
            $message = "SSHClient transport does not support CIM source."
            $exception = [System.Exception]::new($message)
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::InvalidArgument, $null)
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }

        # Get-DiskSmartInfo -Transport SSHClient -ComputerName $cn
        # Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | Get-DiskSmartInfo -Transport SSHClient -ComputerName $cn
        if (-not $IsLinux -and -not $IsMacOS -and $Transport -eq 'SSHClient' -and $ComputerName -and -not $Source)
        {
            $message = "Source parameter is not specified and its default value is ""CIM"". SSHClient transport does not support CIM source."
            $exception = [System.Exception]::new($message)
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::InvalidArgument, $null)
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

        if ($Credential -and $Transport -eq 'SSHClient')
        {
            Write-Warning -Message "The -Credential parameter is not used with SSHClient transport."
        }

        if ($SSHClientSudo -and $Transport -ne 'SSHClient')
        {
            Write-Warning -Message "The -SSHClientSudo parameter is only used with SSHClient transport."
        }

        if ($SmartCtlOption -and $Source -ne 'SmartCtl')
        {
            Write-Warning -Message "The -SmartCtlOption parameter is only used with SmartCtl source."
        }

        # Defaults
        if (-not $IsLinux -and -not $IsMacOS -and $PSCmdlet.ParameterSetName -eq 'ComputerName' -and -not $Transport)
        {
            $Transport = 'CimSession'
        }

        if (-not $IsLinux -and -not $IsMacOS -and -not $Source)
        {
            $Source = 'CIM'
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

        $RequestedAttributes = @{AttributeIDs=$AttributeID; AttributeIDHexes=$AttributeIDHex; AttributeNames=$AttributeName}
    }

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Session')
        {
            foreach ($cs in $CimSession)
            {
                if ($Source -eq 'CIM')
                {
                    $SourceSmartDataCIM = inGetSourceSmartDataCIM -CimSession $cs
                    $HostsSmartData = inGetSmartDataStructureCIM -SourceSmartDataCIM $SourceSmartDataCIM

                    inGetDiskSmartInfo `
                        -HostsSmartData $HostsSmartData `
                        -Convert:$Convert `
                        -Critical:$Critical `
                        -DiskNumbers $DiskNumber `
                        -DiskModels $DiskModel `
                        -Devices $Device `
                        -RequestedAttributes $RequestedAttributes `
                        -AttributeProperties $AttributeProperty `
                        -Quiet:$Quiet `
                        -ShowHistory:$ShowHistory `
                        -UpdateHistory:$UpdateHistory `
                        -Archive:$Archive
                }

                # CIMSession | Get-DiskSmartInfo -Source SmartCtl
                elseif ($Source -eq 'SmartCtl')
                {
                    $message = "ComputerName: ""$($cs.ComputerName)"": CIMSession only supports CIM source."
                    $exception = [System.Exception]::new($message)
                    $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::InvalidArgument, $null)
                    $PSCmdlet.WriteError($errorRecord)
                }
            }

            foreach ($ps in $PSSession)
            {
                if ($Source -eq 'CIM')
                {
                    $SourceSmartDataCIM = inGetSourceSmartDataCIM -PSSession $ps
                    $HostsSmartData = inGetSmartDataStructureCIM -SourceSmartDataCIM $SourceSmartDataCIM
                }
                elseif ($Source -eq 'SmartCtl')
                {
                    $SourceSmartDataCtl = inGetSourceSmartDataCtl -PSSession $ps -SmartCtlOptions $SmartCtlOption
                    $HostsSmartData = inGetSmartDataStructureCtl -SourceSmartDataCtl $SourceSmartDataCtl
                }

                inGetDiskSmartInfo `
                    -HostsSmartData $HostsSmartData `
                    -Convert:$Convert `
                    -Critical:$Critical `
                    -DiskNumbers $DiskNumber `
                    -DiskModels $DiskModel `
                    -Devices $Device `
                    -RequestedAttributes $RequestedAttributes `
                    -AttributeProperties $AttributeProperty `
                    -Quiet:$Quiet `
                    -ShowHistory:$ShowHistory `
                    -UpdateHistory:$UpdateHistory `
                    -Archive:$Archive
            }
        }

        elseif ($ComputerName)
        {
            if ($Transport -eq 'CimSession')
            {
                foreach ($cn in $ComputerName)
                {
                    if ($Source -eq 'CIM')
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
                                -Critical:$Critical `
                                -DiskNumbers $DiskNumber `
                                -DiskModels $DiskModel `
                                -Devices $Device `
                                -RequestedAttributes $RequestedAttributes `
                                -AttributeProperties $AttributeProperty `
                                -Quiet:$Quiet `
                                -ShowHistory:$ShowHistory `
                                -UpdateHistory:$UpdateHistory `
                                -Archive:$Archive
                        }
                        finally
                        {
                            Remove-CimSession -CimSession $cs
                        }
                    }
                    # ComputerName, Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | Get-DiskSmartInfo -Source SmartCtl
                    # (Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk are all from remote computers)
                    elseif ($Source -eq 'SmartCtl')
                    {
                        $message = "ComputerName: ""$cn"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source."
                        $exception = [System.Exception]::new($message)
                        $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::InvalidArgument, $null)
                        $PSCmdlet.WriteError($errorRecord)
                    }
                }
            }
            elseif ($Transport -eq 'PSSession')
            {
                foreach ($cn in $ComputerName)
                {
                    # non-existent computer name results in non-terminating error
                    # computername format error, e.g user@host (for -ComputerName, not -HostName) results in terminating error
                    # we need to suppress both types of cmdlet error messages and replace them with our own
                    try
                    {
                        if ($Credential)
                        {
                            $ps = New-PSSession -ComputerName $cn -Credential $Credential @errorParameters
                        }
                        else
                        {
                            $ps = New-PSSession -ComputerName $cn @errorParameters
                        }
                    }
                    catch { }

                    if (-not $ps)
                    {
                        inReportErrors -Errors $sessionErrors
                        continue
                    }

                    try
                    {
                        if ($Source -eq 'CIM')
                        {
                            $SourceSmartDataCIM = inGetSourceSmartDataCIM -PSSession $ps
                            $HostsSmartData = inGetSmartDataStructureCIM -SourceSmartDataCIM $SourceSmartDataCIM
                        }
                        elseif ($Source -eq 'SmartCtl')
                        {
                            $SourceSmartDataCtl = inGetSourceSmartDataCtl -PSSession $ps -SmartCtlOptions $SmartCtlOption
                            $HostsSmartData = inGetSmartDataStructureCtl -SourceSmartDataCtl $SourceSmartDataCtl
                        }

                        inGetDiskSmartInfo `
                            -HostsSmartData $HostsSmartData `
                            -Convert:$Convert `
                            -Critical:$Critical `
                            -DiskNumbers $DiskNumber `
                            -DiskModels $DiskModel `
                            -Devices $Device `
                            -RequestedAttributes $RequestedAttributes `
                            -AttributeProperties $AttributeProperty `
                            -Quiet:$Quiet `
                            -ShowHistory:$ShowHistory `
                            -UpdateHistory:$UpdateHistory `
                            -Archive:$Archive
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
                        if ($Source -eq 'CIM')
                        {
                            $SourceSmartDataCIM = inGetSourceSmartDataCIM -PSSession $ps
                            $HostsSmartData = inGetSmartDataStructureCIM -SourceSmartDataCIM $SourceSmartDataCIM
                        }
                        elseif ($Source -eq 'SmartCtl')
                        {
                            $SourceSmartDataCtl = inGetSourceSmartDataCtl -PSSession $ps -SmartCtlOptions $SmartCtlOption
                            $HostsSmartData = inGetSmartDataStructureCtl -SourceSmartDataCtl $SourceSmartDataCtl
                        }

                        inGetDiskSmartInfo `
                            -HostsSmartData $HostsSmartData `
                            -Convert:$Convert `
                            -Critical:$Critical `
                            -DiskNumbers $DiskNumber `
                            -DiskModels $DiskModel `
                            -Devices $Device `
                            -RequestedAttributes $RequestedAttributes `
                            -AttributeProperties $AttributeProperty `
                            -Quiet:$Quiet `
                            -ShowHistory:$ShowHistory `
                            -UpdateHistory:$UpdateHistory `
                            -Archive:$Archive
                    }
                    finally
                    {
                        Remove-PSSession -Session $ps
                    }
                }
            }
            elseif ($Transport -eq 'SSHClient')
            {
                foreach ($cn in $ComputerName)
                {
                    # ComputerName, Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | Get-DiskSmartInfo -Transport SSHClient
                    # (Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk are all from remote computers)
                    if ($Source -eq 'CIM')
                    {
                        $message = "ComputerName: ""$cn"": Source parameter is not specified and its default value is ""CIM"". SSHClient transport does not support CIM source."
                        $exception = [System.Exception]::new($message)
                        $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $message, [System.Management.Automation.ErrorCategory]::InvalidArgument, $null)
                        $PSCmdlet.WriteError($errorRecord)
                    }
                    elseif ($Source -eq 'SmartCtl')
                    {
                        $SourceSmartDataCtl = inGetSourceSmartDataSSHClientCtl -ComputerName $cn -SmartCtlOptions $SmartCtlOption -Sudo $SSHClientSudo
                        $HostsSmartData = inGetSmartDataStructureCtl -SourceSmartDataCtl $SourceSmartDataCtl
                    }

                    inGetDiskSmartInfo `
                        -HostsSmartData $HostsSmartData `
                        -Convert:$Convert `
                        -Critical:$Critical `
                        -DiskNumbers $DiskNumber `
                        -DiskModels $DiskModel `
                        -Devices $Device `
                        -RequestedAttributes $RequestedAttributes `
                        -AttributeProperties $AttributeProperty `
                        -Quiet:$Quiet `
                        -ShowHistory:$ShowHistory `
                        -UpdateHistory:$UpdateHistory `
                        -Archive:$Archive
                }
            }
        }
        # Localhost
        else
        {
            if ($Source -eq 'CIM')
            {
                $SourceSmartDataCIM = inGetSourceSmartDataCIM
                $HostsSmartData = inGetSmartDataStructureCIM -SourceSmartDataCIM $SourceSmartDataCIM
            }
            elseif ($Source -eq 'SmartCtl')
            {
                $SourceSmartDataCtl = inGetSourceSmartDataCtl -SmartCtlOptions $SmartCtlOption
                $HostsSmartData = inGetSmartDataStructureCtl -SourceSmartDataCtl $SourceSmartDataCtl
            }

            inGetDiskSmartInfo `
                -HostsSmartData $HostsSmartData `
                -Convert:$Convert `
                -Critical:$Critical `
                -DiskNumbers $DiskNumber `
                -DiskModels $DiskModel `
                -Devices $Device `
                -RequestedAttributes $RequestedAttributes `
                -AttributeProperties $AttributeProperty `
                -Quiet:$Quiet `
                -ShowHistory:$ShowHistory `
                -UpdateHistory:$UpdateHistory `
                -Archive:$Archive
        }
    }

    end
    {
        # Remove unnecessary System.Management.Automation.Runspaces.RemotingErrorRecord (CIMSession errors) objects
        # or errors with exception System.Management.Automation.Remoting.PSRemotingTransportException (PSSession errors) from ErrorVariable
        inClearRemotingErrorRecords
    }
}
