function Get-DiskSmartInfo
{
    Param(
        [string[]]$ComputerName,
        [switch]$NoWMIFallback
    )

    if ($ComputerName)
    {
        try
        {
            $cimSessions = New-CimSession -ComputerName $ComputerName

            foreach ($cimSession in $cimSessions)
            {
                inGetDiskSmartInfo -Session $cimSession -NoWMIFallback:$NoWMIFallback
            }
        }
        finally
        {
            Remove-CimSession -CimSession $cimSessions
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
        [switch]$NoWMIFallback
    )

    $namespaceWMI = 'root/WMI'
    $classSMARTData = 'MSStorageDriver_ATAPISmartData'
    $classThresholds = 'MSStorageDriver_FailurePredictThresholds'
    $classDiskDrive = 'Win32_DiskDrive'

    $initialOffset = 2
    $attributeLength = 12

    $parameters = @{}

    if ($Session)
    {
        $parameters.Add('CimSession', $Session)
    }

    try
    {
        $disksInfo = Get-CimInstance -Namespace $namespaceWMI -ClassName $classSMARTData @parameters -ErrorAction Stop
        $disksThresholds = Get-CimInstance -Namespace $namespaceWMI -ClassName $classThresholds @parameters
        $diskDrives = Get-CimInstance -ClassName $classDiskDrive @parameters
    }
    catch
    {
        if (-not $NoWMIFallback -and ($psSession = New-PSSession -ComputerName $Session.ComputerName))
        {
            try
            {
                $disksInfo = Invoke-Command -ScriptBlock { Get-WMIObject -Namespace $Using:namespaceWMI -Class $Using:classSMARTData } -Session $psSession
                $disksThresholds = Invoke-Command -ScriptBlock { Get-WMIObject -Namespace $Using:namespaceWMI -Class $Using:classThresholds } -Session $psSession
                $diskDrives = Invoke-Command -ScriptBlock { Get-WMIObject -Class $Using:classDiskDrive } -Session $psSession
            }
            finally
            {
                Remove-PSSession -Session $psSession
            }
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

        $hash = [ordered]@{}

        if ($Session)
        {
            $hash.Add('ComputerName', $Session.ComputerName)
        }

        $hash.Add('Model', $diskDrive.Model)
        $hash.Add('InstanceId', $instanceId)

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
                $attribute.Add("Threshold", $thresholdsData[$a + 1])
                $attribute.Add("Data", $(inGetAttributeData -smartData $smartData -a $a))

                $attributeObject = [PSCustomObject]$attribute
                $attributeObject | Add-Member -TypeName "DiskSmartAttribute"

                $attributes += $attributeObject
            }
        }

        $hash.Add("SmartData", $attributes)
        $diskSmartInfo = [PSCustomObject]$hash
        $diskSmartInfo | Add-Member -TypeName "DiskSmartInfo" -PassThru
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

function inGetAttributeData
{
    Param(
        $smartData,
        $a
    )

    if ($smartData[$a] -eq 194) # Temperature
    {
        # 10, 8, 6
        $temps = @()

        for ($i = 10; $i -ge 6; $i -= 2)
        {
            $value = ($smartData[$a + $i] * 256) + $smartData[$a + $i - 1]

            if ($value)
            {
                $temps += $value
            }
        }

        return $temps
    }
    else
    {
        $result = 0
        $dataStartOffset = $a + 5

        for ($offset = 0; $offset -le 6; $offset++)
        {
            $result += $smartData[$dataStartOffset + $offset] * ( [math]::Pow(256, $offset) )
        }

        return $result
    }
}
