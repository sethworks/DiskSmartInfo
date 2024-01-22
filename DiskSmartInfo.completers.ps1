using namespace System.Management.Automation

class AttributeNameCompleter : System.Management.Automation.IArgumentCompleter
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
                if ($completionResult.Contains(" "))
                {
                    $result.Add([CompletionResult]::new("'$completionResult'", $completionResult, [CompletionResultType]::ParameterValue, $completionResult))
                }
                else
                {
                    $result.Add([CompletionResult]::new($completionResult))
                }
            }
        }
        return $result
    }
}
