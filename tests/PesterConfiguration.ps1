$PesterConfiguration = New-PesterConfiguration

$PesterConfiguration.Run.Path = '.\tests\DiskSmartInfo.tests.ps1', '.\tests\DiskSmartInfo.completions.tests.ps1', '.\tests\DiskSmartAttributeDescription.tests.ps1'
$PesterConfiguration.Output.Verbosity = 'Detailed'

$PesterConfiguration.Should.ErrorAction = 'Continue'
