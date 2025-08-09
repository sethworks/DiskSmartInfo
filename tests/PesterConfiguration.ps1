$PesterConfiguration = New-PesterConfiguration

$PesterConfiguration.Run.Path = '.\tests\DiskSmartInfo.completers.tests.ps1',
                                '.\tests\DiskSmartInfo.tests.ps1',
                                '.\tests\DiskSmartInfo.ctl.tests.ps1',
                                '.\tests\DiskSmartInfo.ctl.nvme.tests.ps1',
                                '.\tests\DiskSmartInfo.attributes.tests.ps1',
                                '.\tests\DiskSmartInfo.attributeproperties.tests.ps1',
                                '.\tests\DiskSmartInfo.history.tests.ps1',
                                '.\tests\DiskSmartInfo.archive.tests.ps1',
                                '.\tests\DiskSmartInfo.remoting.CIMSession.tests.ps1',
                                '.\tests\DiskSmartInfo.remoting.CIMSession.mocked.tests.ps1',
                                '.\tests\DiskSmartInfo.remoting.PSSession.mocked.tests.ps1',
                                '.\tests\DiskSmartInfo.remoting.SSHSession.mocked.tests.ps1',
                                '.\tests\DiskSmartInfo.remoting.PSSession.ctl.mocked.tests.ps1',
                                '.\tests\DiskSmartInfo.remoting.SSHSession.ctl.mocked.tests.ps1',
                                '.\tests\DiskSmartInfo.config.tests.ps1',
                                '.\tests\DiskSmartInfo.errors.tests.ps1',
                                '.\tests\DiskSmartAttributeDescription.tests.ps1'

$PesterConfiguration.Output.Verbosity = 'Detailed'

$PesterConfiguration.Should.ErrorAction = 'Continue'
