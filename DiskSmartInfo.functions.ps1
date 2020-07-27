function Get-DiskSmartInfo
{
    Param(
        [string[]]$ComputerName,
        [switch]$WMIFallback
    )

    $Namespace = 'root/WMI'
    $ClassSMARTData = 'MSStorageDriver_ATAPISmartData'
    $ClassThresholds = 'MSStorageDriver_FailurePredictThresholds'
    $ClassDiskDrive = 'Win32_DiskDrive'

    $initialOffset = 2
    $attributeLength = 12

    if ($ComputerName)
    {
        try
        {
            $cimSessions = New-CimSession -ComputerName $ComputerName

            foreach ($cimSession in $cimSessions)
            {
                inGetDiskSmartInfo -Session $cimSession -WMIFallback:$WMIFallback
            }
        }
        finally
        {
            Remove-CimSession -CimSession $cimSession
        }
    }
    else
    {
        inGetDiskSmartInfo
    }
}

function inGetDiskSmartInfo
{
    Param (
        [Microsoft.Management.Infrastructure.CimSession[]]$Session,
        [switch]$WMIFallback
    )

    $parameters = @{}

    if ($Session)
    {
        $parameters.Add('CimSession', $Session)
    }

    try
    {
        $disksInfo = Get-CimInstance -Namespace $Namespace -ClassName $ClassSMARTData @parameters -ErrorAction Stop
        $disksThresholds = Get-CimInstance -Namespace $Namespace -ClassName $ClassThresholds @parameters
        $diskDrives = Get-CimInstance -ClassName $ClassDiskDrive @parameters
    }
    catch
    {
        if ($WMIFallback)
        {
            $psSession = New-PSSession -ComputerName $Session.ComputerName

            $disksInfo = Invoke-Command -ScriptBlock { Get-WMIObject -Namespace $Using:Namespace -Class $Using:ClassSMARTData } -Session $psSession
            $disksThresholds = Invoke-Command -ScriptBlock { Get-WMIObject -Namespace $Using:Namespace -Class $Using:ClassThresholds } -Session $psSession
            $diskDrives = Invoke-Command -ScriptBlock { Get-WMIObject -Class $Using:ClassDiskDrive } -Session $psSession
        }
    }

    foreach ($diskInfo in $disksInfo)
    {
        $instanceName = $diskInfo.InstanceName
        $smartData = $diskInfo.VendorSpecific
        $thresholdsData = $disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $instanceName}  | ForEach-Object -MemberName VendorSpecific

        # remove '_0' at the end
        $instanceId = $instanceName.Substring(0, $instanceName.Length - 2)

        $diskDrive = $diskDrives | Where-Object -FilterScript { $_.PNPDeviceID -eq $instanceId }

        $hash = [ordered]@{
            Model = $diskDrive.Model
            InstanceId = $instanceId
        }

        $attributes = @()

        for ($a = $initialOffset; $a -lt $smartData.Count; $a += $attributeLength)
        {
            $attribute = [ordered]@{}

            $attributeID = $smartData[$a]

            if ($attributeID)
            {
                $attribute.Add("ID", $attributeID)
                $attribute.Add("IDhex", [convert]::ToString($attributeID,16).ToUpper())
                $attribute.Add("AttributeName", $smartAttributes.Where{$_.AttributeID -eq $attributeID}.AttributeName)
                $attribute.Add("Value", $(inGetAttributeValue -smartData $smartData -a $a))
                $attribute.Add("Threshold", $thresholdsData[$a + 1])

                $attributeObject = [PSCustomObject]$attribute
                $attributeObject | Add-Member -TypeName "DiskSmartAttribute"

                $attributes += $attributeObject
            }
        }

        $hash.Add("SmartData", $attributes)
        $diskSmartInfo = [PSCustomObject]$hash
        $diskSmartInfo | Add-Member -TypeName "DiskSmartInfo" -PassThru
    }

    if ($psSession)
    {
        Remove-PSSession -Session $psSession
    }
}

function Get-DiskSmartAttributeDescription
{
    [CmdletBinding(DefaultParameterSetName='AllAttributes')]
    Param(
        [Parameter(ParameterSetName='AttributeID')]
        [int]$AttributeID,
        [Parameter(ParameterSetName='AttributeIDHex')]
        [string]$AttributeIDHex,
        [Parameter(ParameterSetName='CriticalOnly')]
        [switch]$CriticalOnly
    )

    switch ($PSCmdlet.ParameterSetName)
    {
        'AllAttributes'
        {
            $smartAttributes
        }

        'AttributeID'
        {
            $smartAttributes | Where-Object -FilterScript {$_.AttributeID -eq $AttributeID}
        }

        'AttributeIDHex'
        {
            $smartAttributes | Where-Object -FilterScript {$_.AttributeIDHex -eq $AttributeIDHex}
        }

        'CriticalOnly'
        {
            $smartAttributes | Where-Object -Property IsCritical
        }
    }
}

function inGetAttributeValue
{
    Param(
        $smartData,
        $a
    )

    if ($smartData[$a] -eq 194) # Temperature
    {
        # 10, 8, 6
        $result = @()

        for ($i = 10; $i -ge 6; $i -= 2)
        {
            $value = ($smartData[$a + $i] * 256) + $smartData[$a + $i - 1]

            if ($value)
            {
                $result += $value
            }
        }

        $result
    }
    else
    {
        ($smartData[$a + 6] * 256) + $smartData[$a + 5]
    }
}
