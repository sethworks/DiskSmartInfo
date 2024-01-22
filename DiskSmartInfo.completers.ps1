# using namespace System.Management.Automation

class AttributeNameCompleter : System.Management.Automation.IArgumentCompleter
{
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string] $commandName,
        [string] $parameterName,
        [string] $wordToComplete,
        [System.Management.Automation.Language.CommandAst] $commandAst,
        [System.Collections.IDictionary] $fakeBoundParameters
    )
    {
        $attributeNames = $Script:defaultAttributes.AttributeName
        # $wordToCompleteTrimmed = $wordToComplete.Trim("'").Trim('"')
        $result = New-Object -TypeName "System.Collections.Generic.List[System.Management.Automation.CompletionResult]"

        # if ($i = $commandAst.Parent.PipelineElements.IndexOf($commandAst))
        # {
        #     $endOffset = $commandAst.Parent.PipelineElements[$i-1].Extent.EndOffset
        #     $command = $commandAst.Parent.Extent.Text.Substring(0, $endOffset)
        #     $objects = [scriptblock]::Create($command).Invoke()

        #     $properties = $objects |
        #         Sort-Object -Property pstypenames -Unique |
        #         ForEach-Object {$_.psobject.Properties.Name} |
        #         Sort-Object -Unique
        # }

        [System.Collections.Generic.List[String]]$valuesToExclude = $null

        if ($commandParameterAst = $commandAst.Find({$args[0].GetType().Name -eq 'CommandParameterAst' -and $args[0].ParameterName -eq $parameterName}, $false))
        {
            $i = $commandAst.CommandElements.IndexOf($commandParameterAst)
            # $parameterValueAst = $commandAst.CommandElements[$i+1]

            # if ($parameterValueAst)
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
                    # if ($wordToCompleteTrimmed)
                    {
                        $valuesToExclude.Remove($wordToComplete) | Out-Null
                        # $valuesToExclude.Remove($wordToCompleteTrimmed) | Out-Null
                    }
                }
            }
        }
        # else
        # {
        #     $parameterValueAst = $commandAst.CommandElements[1]
        # }

        # if ($parameterValueAst)
        # {
        #     if ($parameterValueAst.GetType().Name -eq 'ArrayLiteralAst')
        #     {
        #         $values = $parameterValueAst.Elements
        #     }
        #     elseif ($parameterValueAst.GetType().Name -eq 'ErrorExpressionAst')
        #     {
        #         $values = $parameterValueAst.NestedAst
        #     }

        #     if ($values)
        #     {
        #         $valuesToExclude = $values |
        #         Where-Object { $_.GetType().Name -eq 'StringConstantExpressionAst' } |
        #         ForEach-Object { $_.SafeGetValue() }

        #         if ($wordToComplete)
        #         {
        #             $valuesToExclude.Remove($wordToComplete) | Out-Null
        #         }
        #     }
        # }

        foreach ($completionResult in $attributeNames)
        {
            if ($completionResult -like "$wordToComplete*" -and $completionResult -notin $valuesToExclude)
            # if ($completionResult -like "$wordToCompleteTrimmed*" -and $completionResult -notin $valuesToExclude)
            {
                if ($completionResult.Contains(" "))
                {
                    # $result += [System.Management.Automation.CompletionResult]::new("'$e'",$e, [System.Management.Automation.CompletionResultType]::ParameterValue ,$e)
                    $result.Add([System.Management.Automation.CompletionResult]::new("'$completionResult'", $completionResult, [System.Management.Automation.CompletionResultType]::ParameterValue, $completionResult))
                }
                else
                {
                    # $result += [System.Management.Automation.CompletionResult]::new($e)
                    $result.Add([System.Management.Automation.CompletionResult]::new($completionResult))
                }
            }
        }
        return $result
    }
}



# $ScriptBlockPropertyName = {

#     Param (
#         $commandName,
#         $parameterName,
#         $wordToComplete,
#         $commandAst,
#         $fakeBoundParameters
#     )

#     if ($i = $commandAst.Parent.PipelineElements.IndexOf($commandAst))
#     {
#         $endOffset = $commandAst.Parent.PipelineElements[$i-1].Extent.EndOffset
#         $command = $commandAst.Parent.Extent.Text.Substring(0, $endOffset)
#         $objects = [scriptblock]::Create($command).Invoke()

#         $properties = $objects |
#             Sort-Object -Property pstypenames -Unique |
#             ForEach-Object {$_.psobject.Properties.Name} |
#             Sort-Object -Unique
#     }

#     [System.Collections.Generic.List[String]]$valuesToExclude = $null

#     if ($commandParameterAst = $commandAst.Find({$args[0].GetType().Name -eq 'CommandParameterAst' -and $args[0].ParameterName -eq $parameterName}, $false))
#     {
#         $i = $commandAst.CommandElements.IndexOf($commandParameterAst)
#         $parameterValueAst = $commandAst.CommandElements[$i+1]
#     }
#     else
#     {
#         $parameterValueAst = $commandAst.CommandElements[1]
#     }

#     if ($parameterValueAst)
#     {
#         if ($parameterValueAst.GetType().Name -eq 'ArrayLiteralAst')
#         {
#             $values = $parameterValueAst.Elements
#         }
#         elseif ($parameterValueAst.GetType().Name -eq 'ErrorExpressionAst')
#         {
#             $values = $parameterValueAst.NestedAst
#         }

#         if ($values)
#         {
#             $valuesToExclude = $values |
#             Where-Object { $_.GetType().Name -eq 'StringConstantExpressionAst' } |
#             ForEach-Object { $_.SafeGetValue() }

#             if ($wordToComplete)
#             {
#                 $valuesToExclude.Remove($wordToComplete) | Out-Null
#             }
#         }
#     }

#     foreach ($p in $properties)
#     {
#         if ($p -like "$wordToComplete*" -and $p -notin $valuesToExclude)
#         {
#             [System.Management.Automation.CompletionResult]::new($p)
#         }
#     }

#     return $result
# }
