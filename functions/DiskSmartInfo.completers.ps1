using namespace System.Management.Automation

class AttributeNameCompleter : IArgumentCompleter
{
    [System.Collections.Generic.IEnumerable[CompletionResult]] CompleteArgument(
        [string] $commandName,
        [string] $parameterName,
        [string] $wordToComplete,
        [Language.CommandAst] $commandAst,
        [System.Collections.IDictionary] $fakeBoundParameters
    )
    {
        $attributeNames = $Script:defaultAttributes.AttributeName
        $result = New-Object -TypeName "System.Collections.Generic.List[CompletionResult]"

        [System.Collections.Generic.List[String]]$valuesToExclude = $null

        if ($commandParameterAst = $commandAst.Find({$args[0].GetType().Name -eq 'CommandParameterAst' -and $args[0].ParameterName -eq $parameterName}, $false))
        {
            $i = $commandAst.CommandElements.IndexOf($commandParameterAst)

            if ($parameterValueAst = $commandAst.CommandElements[$i+1])
            {
                $values = $null
                if ($parameterValueAst.GetType().Name -eq 'ArrayLiteralAst')
                {
                    $values = $parameterValueAst.Elements
                }
                elseif ($parameterValueAst.GetType().Name -eq 'ErrorExpressionAst')
                {
                    $values = $parameterValueAst.NestedAst
                }

                if ($values)
                {
                    $valuesToExclude = $values |
                        Where-Object { $_.GetType().Name -eq 'StringConstantExpressionAst' } |
                        ForEach-Object { $_.SafeGetValue() }

                    if ($wordToComplete)
                    {
                        $valuesToExclude.Remove($wordToComplete) | Out-Null
                    }
                }
            }
        }

        foreach ($completionResult in $attributeNames)
        {
            if ($completionResult -like "$wordToComplete*" -and $completionResult -notin $valuesToExclude)
            {
                $id = ($Script:defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeName -eq $completionResult})).AttributeID
                if ($completionResult.Contains(" "))
                {
                    $result.Add([CompletionResult]::new("'$completionResult'", $completionResult, [CompletionResultType]::ParameterValue, "${id}: $completionResult"))
                }
                else
                {
                    $result.Add([CompletionResult]::new($completionResult, $completionResult, [CompletionResultType]::ParameterValue, "${id}: $completionResult"))
                }
            }
        }
        return $result
    }
}

class DiskCompleter : IArgumentCompleter
{
    [System.Collections.Generic.IEnumerable[CompletionResult]] CompleteArgument(
        [string] $commandName,
        [string] $parameterName,
        [string] $wordToComplete,
        [Language.CommandAst] $commandAst,
        [System.Collections.IDictionary] $fakeBoundParameters
    )
    {
        $result = New-Object -TypeName "System.Collections.Generic.List[CompletionResult]"
        [System.Collections.Generic.List[String]]$valuesToExclude = $null

        $parameters = @{
            ClassName = 'Win32_DiskDrive'
        }

        if (($fakeBoundParameters.ContainsKey('ComputerName') -and $fakeBoundParameters.ContainsKey('CimSession')) -or
           ($fakeBoundParameters.ContainsKey('ComputerName') -and $fakeBoundParameters.ComputerName.Count -gt 1) -or
           ($fakeBoundParameters.ContainsKey('CimSession') -and $fakeBoundParameters.CimSession.Count -gt 1) )
        {
            return $result
        }

        if ($fakeBoundParameters.ContainsKey('ComputerName'))
        {
            $parameters.Add('ComputerName', $fakeBoundParameters.ComputerName)
        }
        elseif  ($fakeBoundParameters.ContainsKey('CimSession'))
        {
            $parameters.Add('CimSession', $fakeBoundParameters.CimSession)
        }

        $diskDrive = Get-CimInstance @parameters | Sort-Object -Property Index

        if ($commandParameterAst = $commandAst.Find({$args[0].GetType().Name -eq 'CommandParameterAst' -and $args[0].ParameterName -eq $parameterName}, $false))
        {
            $i = $commandAst.CommandElements.IndexOf($commandParameterAst)

            if ($parameterValueAst = $commandAst.CommandElements[$i+1])
            {
                $values = $null
                if ($parameterValueAst.GetType().Name -eq 'ArrayLiteralAst')
                {
                    $values = $parameterValueAst.Elements
                }
                elseif ($parameterValueAst.GetType().Name -eq 'ErrorExpressionAst')
                {
                    $values = $parameterValueAst.NestedAst
                }

                if ($values)
                {
                    $valuesToExclude = $values |
                        Where-Object { ($_.GetType().Name -eq 'StringConstantExpressionAst') -or ($_.GetType().Name -eq 'ConstantExpressionAst') } |
                        ForEach-Object { $_.SafeGetValue() }

                    if ($wordToComplete)
                    {
                        $valuesToExclude.Remove($wordToComplete) | Out-Null
                    }
                }
            }
        }

        $diskDrives = @()
        foreach ($d in $diskDrive)
        {
            $diskDrives += @{
                Index = $d.Index
                Model = inTrimDiskDriveModel -Model $d.Model
            }
        }

        if ($parameterName -eq 'DiskNumber')
        {
            foreach ($completionResult in $diskDrives.Index)
            {
                if ($completionResult -like "$wordToComplete*" -and $completionResult -notin $valuesToExclude)
                {
                    $model = ($diskDrives.Where{$_.Index -eq $completionResult}).Model
                    $result.Add([CompletionResult]::new($completionResult, $completionResult, [CompletionResultType]::ParameterValue, "${completionResult}: $model"))
                }
            }
        }
        elseif ($parameterName -eq 'DiskModel')
        {
            foreach ($completionResult in $diskDrives.Model)
            {
                if ($completionResult -like "$wordToComplete*" -and $completionResult -notin $valuesToExclude)
                {
                    $index = ($diskDrives.Where{$_.Model -eq $completionResult}).Index
                    if ($completionResult.Contains(" "))
                    {
                        $result.Add([CompletionResult]::new("'$completionResult'", $completionResult, [CompletionResultType]::ParameterValue, "${index}: $completionResult"))
                    }
                    else
                    {
                        $result.Add([CompletionResult]::new($completionResult, $completionResult, [CompletionResultType]::ParameterValue, "${index}: $completionResult"))
                    }
                }
            }
        }

        return $result
    }
}
