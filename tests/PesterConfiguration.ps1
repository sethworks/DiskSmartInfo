$PesterConfiguration = New-PesterConfiguration

$PesterConfiguration.Run.Path = '.\tests\DiskSmartInfo.tests.ps1'
$PesterConfiguration.Output.Verbosity = 'Detailed'

$PesterConfiguration.Should.ErrorAction = 'Continue'
