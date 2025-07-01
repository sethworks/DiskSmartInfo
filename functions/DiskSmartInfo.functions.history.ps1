function inUpdateHistoricalData
{
    Param (
        $hostSmartData
        # $disksSmartData,
        # $disksThresholds,
        # $diskDrives,
        # $session
        # $computerName
    )

    $historicalData = [System.Collections.Generic.List[PSCustomObject]]::new()

    # foreach ($diskSmartData in $disksSmartData)
    foreach ($diskSmartData in $hostSmartData.disksSmartData)
    {
        $smartData = $diskSmartData.VendorSpecific
        # $thresholdsData = $disksThresholds | Where-Object -FilterScript { $_.InstanceName -eq $diskSmartData.InstanceName} | ForEach-Object -MemberName VendorSpecific
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

        $smartAttributes = inOverwriteAttributes -model $model

        for ($a = $initialOffset; $a -lt $smartData.Count; $a += $attributeLength)
        {
            $attribute = [ordered]@{}

            $attributeID = $smartData[$a]

            if ($attributeID)
            {
                $attribute.Add("ID", $attributeID)
                $attribute.Add("Data", $(inGetAttributeData -smartAttributes $smartAttributes -smartData $smartData -a $a))

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
        # $fullname = inComposeHistoricalDataFileName -session $session
        # $fullname = inComposeHistoricalDataFileName -computerName $computerName
        $fullname = inComposeHistoricalDataFileName -computerName $hostSmartData.computerName

        $hostHistoricalData = @{
            TimeStamp = Get-Date
            HistoricalData = $historicalData
        }

        Set-Content -Path $fullname -Value (ConvertTo-Json -InputObject $hostHistoricalData -Depth 5)
    }
}

function inGetHistoricalData
{
    Param (
        # $session
        $computerName
    )

    # $fullname = inComposeHistoricalDataFileName -session $session
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
        # $session
        [string]$computerName
    )

    # if ($session)
    if ($computerName)
    {
        # $filename = "$($session.ComputerName).json"
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
            $filepath = $Config.DataHistoryPath
        }
        else
        {
            $filepath = Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath $Config.DataHistoryPath
        }
    }
    # .NET Framework version 4 and lower does not have [System.IO.Path]::IsPathFullyQualified method
    else
    {
        $pathroot = [System.IO.Path]::GetPathRoot($Config.DataHistoryPath)
        if ($pathroot -and $pathroot[-1] -eq '\')
        {
            $filepath = $Config.DataHistoryPath
        }
        else
        {
            $filepath = Join-Path -Path (Split-Path -Path $PSScriptRoot) -ChildPath $Config.DataHistoryPath
        }
    }

    if (-not (Test-Path -Path $filepath))
    {
        New-Item -ItemType Directory -Path $filepath | Out-Null
    }

    $fullname = Join-Path -Path $filepath -ChildPath $filename

    return $fullname
}
