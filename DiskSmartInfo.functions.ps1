function Get-DiskSmartInfo
{
    Param(
        [string[]]$ComputerName
    )

    $Namespace = 'root/WMI'
    $ClassSMARTData = 'MSStorageDriver_ATAPISmartData'
    $ClassThresholds = 'MSStorageDriver_FailurePredictThresholds'

    if ($ComputerName)
    {
        $disksInfo = Get-CimInstance -Namespace $Namespace -ClassName $ClassSMARTData -ComputerName $ComputerName
        $disksThresholds = Get-CimInstance -Namespace $Namespace -ClassName $ClassThresholds -ComputerName $ComputerName
    }
    else
    {
        $disksInfo = Get-CimInstance -Namespace $Namespace -ClassName $ClassSMARTData
        $disksThresholds = Get-CimInstance -Namespace $Namespace -ClassName $ClassThresholds
    }

    $initialOffset = 2
    $attributeLength = 12

    foreach ($diskInfo in $disksInfo)
    {
        $instanceName = $diskInfo.InstanceName
        $smartData = $diskInfo.VendorSpecific
        $thresholdsData = $disksThresholds | Where-Object -FilterScript {$_.InstanceName -eq $instanceName} | ForEach-Object -MemberName VendorSpecific

        # remove '_0' at the end
        $instanceId = $instanceName.Substring(0, $instanceName.Length - 2)
        $escapedInstanceId = $instanceId -replace '\\', '\\'

        if ($ComputerName)
        {
            $diskDrive = Get-CimInstance -ClassName Win32_DiskDrive -Filter "PNPDeviceID = '$escapedInstanceId'" -ComputerName $ComputerName
        }
        else
        {
            $diskDrive = Get-CimInstance -ClassName Win32_DiskDrive -Filter "PNPDeviceID = '$escapedInstanceId'"
        }

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
        $j = [PSCustomObject]$hash
        $j | Add-Member -TypeName "DiskSmartInfo" -PassThru
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
