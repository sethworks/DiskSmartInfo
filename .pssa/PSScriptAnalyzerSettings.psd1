@{
    ExcludeRules = @(
        'PSUseDeclaredVarsMoreThanAssignments',
        'PSReviewUnusedParameter',
        'PSAvoidUsingWMICmdlet',
        'PSPossibleIncorrectUsageOfAssignmentOperator',
        'PSPossibleIncorrectComparisonWithNull',
        'PSAvoidUsingComputerNameHardcoded',
        'PSAvoidUsingConvertToSecureStringWithPlainText'
    )
}