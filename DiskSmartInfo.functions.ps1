function Get-DiskSmartInfo
{
    [CmdletBinding(DefaultParameterSetName='ComputerName')]
    Param(
        [Parameter(Position=0,ParameterSetName='ComputerName')]
        [string[]]$ComputerName,
        [Parameter(ParameterSetName='CimSession')]
        [CimSession[]]$CimSession,
        [switch]$ShowConvertedData,
        [switch]$CriticalAttributesOnly,
        [Alias('WarningOrCriticalOnly','SilenceIfNotInWarningOrCriticalState')]
        [switch]$QuietIfOK
    )

    $Script:ErrorCreatingCimSession = @()
    $Script:ErrorAccessingCimSession = @()
    $Script:ErrorAccessingClass = @()

    # ComputerName
    if ($ComputerName)
    {
        try
        {
            if ($DebugPreference -eq 'Continue')
            {
                $cimSessions = New-CimSession -ComputerName $ComputerName
            }
            else
            {
                $cimSessions = New-CimSession -ComputerName $ComputerName -ErrorVariable Script:ErrorCreatingCimSession -ErrorAction SilentlyContinue
            }

            foreach ($cim in $cimSessions)
            {
                inGetDiskSmartInfo `
                    -Session $cim `
                    -ShowConvertedData:$ShowConvertedData `
                    -CriticalAttributesOnly:$CriticalAttributesOnly `
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
    elseif ($CimSession)
    {
        foreach ($cim in $CimSession)
        {
            if ($cim.TestConnection())
            {
                inGetDiskSmartInfo `
                    -Session $cim `
                    -ShowConvertedData:$ShowConvertedData `
                    -CriticalAttributesOnly:$CriticalAttributesOnly `
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
            -QuietIfOK:$QuietIfOK
    }

    # Error reporting
    foreach ($e in $Script:ErrorCreatingCimSession)
    {
        Write-Error -Message "ComputerName: ""$($e.OriginInfo.PSComputerName)"". $($e.Exception.Message)"
    }
    foreach ($e in $Script:ErrorAccessingCimSession)
    {
        Write-Error -Message "ComputerName: ""$e"". The WinRM client cannot process the request because the CimSession cannot be accessed."
    }
    foreach ($e in $Script:ErrorAccessingClass)
    {
        Write-Error -Message "ComputerName: ""$($e.ComputerName)"", Protocol: $($e.Protocol). $($e.ErrorObject.Exception.Message)"
    }
}
