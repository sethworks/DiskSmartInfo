$PesterConfiguration = New-PesterConfiguration

# $PesterConfiguration.Run.Path = '.\tests\DiskSmartInfo.tests.ps1', '.\tests\DiskSmartAttributeDescription.tests.ps1', '.\tests\Attributes.tests.ps1'
$PesterConfiguration.Run.Path = '.\tests\DiskSmartInfo.tests.ps1', '.\tests\DiskSmartAttributeDescription.tests.ps1'
$PesterConfiguration.Output.Verbosity = 'Detailed'

$PesterConfiguration.Should.ErrorAction = 'Continue'
