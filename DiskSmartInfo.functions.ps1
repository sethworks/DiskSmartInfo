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
        [ValidateRange(1, 255)]
        [int[]]$AttributeID,
        [Alias('WarningOrCriticalOnly','SilenceIfNotInWarningOrCriticalState')]
        [switch]$QuietIfOK
    )

    $Script:ErrorCreatingCimSession = @()
    $Script:ErrorAccessingCimSession = @()
    $Script:ErrorAccessingClass = @()

    # Attributes
    $attributeIDs = [System.Collections.Generic.List[int]]::new()
    if ($AttributeID)
    {
        foreach ($at in $AttributeID)
        {
            $attributeIDs.Add($at)
        }
    }

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
            -AttributeIDs $attributeIDs `
            -QuietIfOK:$QuietIfOK
    }

    # Error reporting
    inReportErrors
}
