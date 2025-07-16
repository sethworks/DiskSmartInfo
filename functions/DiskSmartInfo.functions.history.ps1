function inUpdateHistoricalData
{
    Param (
        $hostSmartData
    )

    $historicalData = [System.Collections.Generic.List[PSCustomObject]]::new()

    # foreach ($diskSmartData in $hostSmartData.disksSmartData)
    foreach ($diskSmartData in $hostSmartData.DisksSmartData)
    {
        # $smartData = $diskSmartData.VendorSpecific
        # $thresholdsData = $hostSmartData.disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName VendorSpecific

        # $pNPDeviceId = $diskSmartData.InstanceName
        # if ($pNPDeviceId -match '_\d$')
        # {
            # $pNPDeviceId = $pNPDeviceId.Remove($pNPDeviceId.Length - 2)
        # }

        # $diskDrive = $hostSmartData.diskDrives | Where-Object -FilterScript { $_.PNPDeviceID -eq $pNPDeviceId }

        # $model = inTrimDiskDriveModel -Model $diskDrive.Model

        $hash = [ordered]@{}

        # $hash.Add('PNPDeviceId', $pNPDeviceId)
        $hash.Add('PNPDeviceId', $diskSmartData.PNPDeviceId)

        $attributes = @()

        # $actualAttributesList = inUpdateActualAttributesList -model $model

        foreach ($attributeSmartData in $diskSmartData.SmartData)
        {
            $attribute = [ordered]@{}
            $attribute.Add('ID', $attributeSmartData.ID)
            $attribute.Add('Data', $attributeSmartData.Data)
            $attributes += [PSCustomObject]$attribute
        }

        # for ($attributeStart = $initialOffset; $attributeStart -lt $smartData.Count; $attributeStart += $attributeLength)
        # {
        #     $attribute = [ordered]@{}

        #     $attributeID = $smartData[$attributeStart]

        #     if ($attributeID)
        #     {
        #         $attribute.Add("ID", $attributeID)
        #         $attribute.Add("Data", $(inGetAttributeData -actualAttributesList $actualAttributesList -smartData $smartData -attributeStart $attributeStart))

        #         $attributes += [PSCustomObject]$attribute
        #     }
        # }

        if ($attributes)
        {
            $hash.Add("SmartData", $attributes)
            $historicalData.Add([PSCustomObject]$hash)
        }
    }

    if ($historicalData.Count)
    {
        # $fullname = inComposeHistoricalDataFileName -computerName $hostSmartData[0].computerName
        $fullname = inComposeHistoricalDataFileName -computerName $hostSmartData.computerName

        $hostHistoricalData = @{
            TimeStamp = Get-Date
            HistoricalData = $historicalData
        }

        inEnsureFolderExists -folder (Split-Path -Path $fullname -Parent)

        Set-Content -Path $fullname -Value (ConvertTo-Json -InputObject $hostHistoricalData -Depth 5)
    }
}
<#
function inUpdateHistoricalData
{
    Param (
        $hostSmartData
    )

    $historicalData = [System.Collections.Generic.List[PSCustomObject]]::new()

    foreach ($diskSmartData in $hostSmartData.disksSmartData)
    {
        $smartData = $diskSmartData.VendorSpecific
        $thresholdsData = $hostSmartData.disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName VendorSpecific

        $pNPDeviceId = $diskSmartData.InstanceName
        if ($pNPDeviceId -match '_\d$')
        {
            $pNPDeviceId = $pNPDeviceId.Remove($pNPDeviceId.Length - 2)
        }

        $diskDrive = $hostSmartData.diskDrives | Where-Object -FilterScript { $_.PNPDeviceID -eq $pNPDeviceId }

        $model = inTrimDiskDriveModel -Model $diskDrive.Model

        $hash = [ordered]@{}

        $hash.Add('PNPDeviceId', $pNPDeviceId)

        $attributes = @()

        $actualAttributesList = inUpdateActualAttributesList -model $model

        for ($attributeStart = $initialOffset; $attributeStart -lt $smartData.Count; $attributeStart += $attributeLength)
        {
            $attribute = [ordered]@{}

            $attributeID = $smartData[$attributeStart]

            if ($attributeID)
            {
                $attribute.Add("ID", $attributeID)
                $attribute.Add("Data", $(inGetAttributeData -actualAttributesList $actualAttributesList -smartData $smartData -attributeStart $attributeStart))

                $attributes += [PSCustomObject]$attribute
            }
        }

        if ($attributes)
        {
            $hash.Add("SmartData", $attributes)
            $historicalData.Add([PSCustomObject]$hash)
        }
    }

    if ($historicalData.Count)
    {
        $fullname = inComposeHistoricalDataFileName -computerName $hostSmartData.computerName

        $hostHistoricalData = @{
            TimeStamp = Get-Date
            HistoricalData = $historicalData
        }

        inEnsureFolderExists -folder (Split-Path -Path $fullname -Parent)

        Set-Content -Path $fullname -Value (ConvertTo-Json -InputObject $hostHistoricalData -Depth 5)
    }
}
#>
function inGetHistoricalData
{
    Param (
        $computerName
    )

    $fullname = inComposeHistoricalDataFileName -computerName $computerName

    if ($content = Get-Content -Path $fullname -Raw -ErrorAction SilentlyContinue)
    {
        $converted = ConvertFrom-Json -InputObject $content

        if ($IsCoreCLR)
        {
            $timestamp = $converted.TimeStamp
        }
        # Windows PowerShell 5.1 ConvertTo-Json converts DateTime objects differently
        else
        {
            $timestamp = $converted.TimeStamp.DateTime
        }

        $hostHistoricalData = @{
            TimeStamp = [datetime]$timestamp
            HistoricalData = @()
        }

        foreach ($object in $converted.HistoricalData)
        {
            $hash = [ordered]@{}
            $attributes = @()

            $hash.Add('PNPDeviceID', [string]$object.PNPDeviceID)

            foreach ($at in $object.SmartData)
            {
                $attribute = [ordered]@{}

                $attribute.Add('ID', [byte]$at.ID)

                if ($at.Data.Count -gt 1)
                {
                    $attribute.Add('Data', [long[]]$at.Data)
                }
                else
                {
                    $attribute.Add('Data', [long]$at.Data)
                }

                $attributes += [PSCustomObject]$attribute
            }

            $hash.Add('SmartData', $attributes)
            $hostHistoricalData.HistoricalData += [PSCustomObject]$hash
        }

        return $hostHistoricalData
    }
}

function inComposeHistoricalDataFileName
{
    Param (
        [string]$computerName
    )

    if ($computerName)
    {
        $filename = "$computerName.json"
    }
    else
    {
        $filename = 'localhost.json'
    }

    if ($IsCoreCLR)
    {
        if ([System.IO.Path]::IsPathFullyQualified($Config.DataHistoryPath))
        {
            $folder = $Config.DataHistoryPath
        }
        else
        {
            $folder = Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath $Config.DataHistoryPath
        }
    }
    # .NET Framework version 4 and lower does not have [System.IO.Path]::IsPathFullyQualified method
    else
    {
        $pathroot = [System.IO.Path]::GetPathRoot($Config.DataHistoryPath)

        # not '\folder' or 'c:folder'
        if ($pathroot -and $pathroot -ne '\' -and $pathroot -notlike "?:")
        {
            $folder = $Config.DataHistoryPath
        }
        else
        {
            $folder = Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath $Config.DataHistoryPath
        }
    }

    $fullname = Join-Path -Path $folder -ChildPath $filename

    return $fullname
}
