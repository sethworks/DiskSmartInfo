function inSelectAttributeProperties
{
    Param (
        $attributes,
        [AttributeProperty[]]$properties,
        [scriptblock]$formatScriptBlock,
        [string]$diskType
    )

    $result = @()

    foreach ($attribute in $attributes)
    {
        $attributeSelected = [ordered]@{}
        foreach ($property in $properties)
        {
            switch ($property.value__)
            {
                ([AttributeProperty]::AttributeName.value__)
                {
                    $attributeSelected.Add('Name', $attribute.Name)
                    break
                }
                ([AttributeProperty]::History.value__)
                {
                    $attributeSelected.Add('DataHistory', $attribute.DataHistory)
                    break
                }
                ([AttributeProperty]::Converted.value__)
                {
                    $attributeSelected.Add('DataConverted', $attribute.DataConverted)
                    break
                }
                default
                {
                    $attributeSelected.Add($property, $attribute.$property)
                }
            }
        }

        $attributeObject = [PSCustomObject]$attributeSelected

        if ($diskType -eq 'ATA')
        {
            $attributeObject | Add-Member -TypeName "DiskSmartAttributeCustom"
        }
        elseif ($diskType -eq 'NVMe')
        {
            $attributeObject | Add-Member -TypeName "DiskSmartAttributeNVMeCustom"
        }

        $attributeObject | Add-Member -MemberType ScriptMethod -Name FormatTable -Value $formatScriptBlock

        $result += $attributeObject
    }

    return $result
}

function inTrimDiskDriveModel
{
    Param (
        $Model
    )

    $trimStrings = @(' ATA Device', ' SCSI Disk Device')

    if ($Script:Config.TrimDiskDriveModelSuffix)
    {
        foreach ($ts in $trimStrings)
        {
            if ($Model.EndsWith($ts))
            {
                return $Model.Remove($Model.LastIndexOf($ts))
            }
        }
    }

    return $Model
}

function inEnsureFolderExists
{
    Param (
        $folder
    )

    if (-not (Test-Path -Path $folder))
    {
        New-Item -ItemType Directory -Path $folder | Out-Null
    }
}

function inGetSmartCtlCommand
{
    Param (
        [string]$SSHHostName,
        # Can not use [bool]$Sudo here, because Windows PowerShell can not convert $null to [bool]
        $Sudo,
        [string]$SmartCtlOptions,
        [string]$SSHClientOptions
    )

    $command = ''

    if ($SSHHostName)
    {
        $command += 'ssh '

        if ($SSHClientOptions)
        {
            $command += "$SSHClientOptions "
        }

        $command += "$SSHHostName "
    }

    if ($Sudo)
    {
        $command += 'sudo '
    }

    $command += 'smartctl '

    if ($SmartCtlOptions)
    {
        $command += "$SmartCtlOptions "
    }

    $command += '--info --health --attributes'

    return $command
}

function inReportErrors
{
    Param (
        $Errors
    )

    foreach ($err in $Errors)
    {
        # CIMSession
        if ($err.GetType().FullName -eq 'System.Management.Automation.Runspaces.RemotingErrorRecord')
        {
            if ($err.OriginInfo.PSComputerName)
            {
                $message = "ComputerName: ""$($err.OriginInfo.PSComputerName)"". $($err.Exception.Message)"
            }
            else
            {
                $message = $err.Exception.Message
            }
        }
        # New-PSSession -ComputerName user@host
        elseif ($err.GetType().FullName -eq 'System.Management.Automation.CmdletInvocationException')
        {
            $err = $err.ErrorRecord
            if ($err.TargetObject)
            {
                $message = "ComputerName: ""$($err.TargetObject)"". $($err.Exception.Message)"
            }
            else
            {
                $message = $err.Exception.Message
            }
        }
        # New-PSSession -ComputerName nonexistenthost
        elseif ($err.Exception.GetType().FullName -eq 'System.Management.Automation.Remoting.PSRemotingTransportException')
        {
            if ($err.ErrorDetails.Message -match '\[(?<ComputerName>\S+)]')
            {
                $message = "ComputerName: ""$($Matches.ComputerName)"". $($err.Exception.Message)"
            }
            else
            {
                $message = $err.Exception.Message
            }
        }

        $exception = [System.Exception]::new($message, $err.Exception)
        $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, $err.FullyQualifiedErrorId, $err.CategoryInfo.Category, $err.TargetObject)
        $PSCmdlet.WriteError($errorRecord)
    }
}

function inClearRemotingErrorRecords
{
    if ($PSCmdlet.MyInvocation.BoundParameters.ErrorVariable)
    {
        $value = $PSCmdlet.SessionState.PSVariable.GetValue($PSCmdlet.MyInvocation.BoundParameters.ErrorVariable)
        while ($true)
        {
            $value.ForEach{
                if ($PSItem.GetType().FullName -eq 'System.Management.Automation.CmdletInvocationException' -or
                    $PSItem.GetType().FullName -eq 'System.Management.Automation.Runspaces.RemotingErrorRecord' -or
                    $PSItem.Exception.GetType().FullName -eq 'System.Management.Automation.Remoting.PSRemotingTransportException' -or
                    $PSItem.Exception.GetType().FullName -eq 'System.ArgumentException')
                {
                    $value.Remove($PSItem)
                    continue
                }
            }
            break
        }
    }
}
