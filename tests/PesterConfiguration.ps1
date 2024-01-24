$PesterConfiguration = New-PesterConfiguration

$PesterConfiguration.Run.Path = '.\tests\DiskSmartInfo.tests.ps1', '.\tests\DiskSmartInfo.completers.tests.ps1', '.\tests\DiskSmartInfo.config.tests.ps1', '.\tests\DiskSmartAttributeDescription.tests.ps1'
$PesterConfiguration.Output.Verbosity = 'Detailed'

$PesterConfiguration.Should.ErrorAction = 'Continue'
