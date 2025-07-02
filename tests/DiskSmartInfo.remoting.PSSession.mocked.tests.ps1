BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "DiskSmartInfo remoting mocked tests" {

    Context "ComputerName" {

        BeforeAll {

            $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
            $psSessionHost2 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            mock New-PSSession -MockWith { $psSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

            mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq " `$errorParameters = @{ ErrorVariable = 'cimInstanceErrors'; ErrorAction = 'SilentlyContinue' } " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classSmartData @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classThresholds @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classFailurePredictStatus @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskDriveHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -ClassName $Using:classDiskDrive @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq ' $cimInstanceErrors ' } -ModuleName DiskSmartInfo

            # $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            # $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            # mock New-CimSession -MockWith { $cimSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            # mock New-CimSession -MockWith { $cimSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            # mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            # mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames -Transport PSSession
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].Name | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(39, 14, 47)
        }

        It "DiskSmartInfo object has correct types and properties" {
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'

            $diskSmartInfo[0].psobject.properties['ComputerName'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].ComputerName | Should -BeOfType 'System.String'

            $diskSmartInfo[0].psobject.properties['DiskModel'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].DiskModel | Should -BeOfType 'System.String'

            $diskSmartInfo[0].psobject.properties['DiskNumber'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].DiskNumber | Should -BeOfType 'System.UInt32'

            $diskSmartInfo[0].psobject.properties['PNPDeviceId'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].PNPDeviceId | Should -BeOfType 'System.String'

            $diskSmartInfo[0].psobject.properties['PredictFailure'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].PredictFailure | Should -BeOfType 'System.Boolean'

            $diskSmartInfo[0].psobject.properties['SmartData'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData | Should -Not -BeNullOrEmpty
        }

        It "DiskSmartInfo object is formatted correctly" {
            $format = $diskSmartInfo[0] | Format-Custom

            $propertyValues = $format.formatEntryInfo.formatValueList.formatValueList.formatValuelist.propertyValue -replace '\e\[[0-9]+(;[0-9]+)*m', ''

            $propertyValues | Should -HaveCount 4

            $propertyValues[0] | Should -BeLikeExactly 'ComputerName:*'
            $propertyValues[1] | Should -BeExactly 'Disk:         0: HDD1'
            $propertyValues[2] | Should -BeExactly 'PNPDeviceId:  IDE\HDD1_________________________12345678\1&12345000&0&1.0.0'
            $propertyValues[3] | Should -BeLikeExactly 'SMARTData:*'
        }
    }

    Context "ComputerName IP Address" {

        BeforeAll {

            $psSessionHost3 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $ipAddresses[0]}
            $psSessionHost4 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $ipAddresses[1]}
            mock New-PSSession -MockWith { $psSessionHost3 } -ParameterFilter {$ComputerName -eq $ipAddresses[0]} -ModuleName DiskSmartInfo
            mock New-PSSession -MockWith { $psSessionHost4 } -ParameterFilter {$ComputerName -eq $ipAddresses[1]} -ModuleName DiskSmartInfo
            mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

            mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq " `$errorParameters = @{ ErrorVariable = 'cimInstanceErrors'; ErrorAction = 'SilentlyContinue' } " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classSmartData @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classThresholds @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classFailurePredictStatus @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskDriveHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -ClassName $Using:classDiskDrive @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq ' $cimInstanceErrors ' } -ModuleName DiskSmartInfo

            # $cimSessionHost3 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $ipAddresses[0]}
            # $cimSessionHost4 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $ipAddresses[1]}
            # mock New-CimSession -MockWith { $cimSessionHost3 } -ParameterFilter {$ComputerName -eq $ipAddresses[0]} -ModuleName DiskSmartInfo
            # mock New-CimSession -MockWith { $cimSessionHost4 } -ParameterFilter {$ComputerName -eq $ipAddresses[1]} -ModuleName DiskSmartInfo
            # mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            # mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo -ComputerName $ipAddresses -Transport PSSession
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $ipAddresses
            $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $ipAddresses.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].Name | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(39, 14, 47)
        }
    }

    Context "ComputerName positional" {

        BeforeAll {
            $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
            $psSessionHost2 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            mock New-PSSession -MockWith { $psSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

            mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq " `$errorParameters = @{ ErrorVariable = 'cimInstanceErrors'; ErrorAction = 'SilentlyContinue' } " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classSmartData @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classThresholds @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classFailurePredictStatus @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskDriveHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -ClassName $Using:classDiskDrive @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq ' $cimInstanceErrors ' } -ModuleName DiskSmartInfo

            # $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            # $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            # mock New-CimSession -MockWith { $cimSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            # mock New-CimSession -MockWith { $cimSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            # mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            # mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo $computerNames -Transport PSSession
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].Name | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(39, 14, 47)
        }
    }

    Context "ComputerName positional IP Address" {

        BeforeAll {

            $psSessionHost3 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $ipAddresses[0]}
            $psSessionHost4 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $ipAddresses[1]}
            mock New-PSSession -MockWith { $psSessionHost3 } -ParameterFilter {$ComputerName -eq $ipAddresses[0]} -ModuleName DiskSmartInfo
            mock New-PSSession -MockWith { $psSessionHost4 } -ParameterFilter {$ComputerName -eq $ipAddresses[1]} -ModuleName DiskSmartInfo
            mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

            mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq " `$errorParameters = @{ ErrorVariable = 'cimInstanceErrors'; ErrorAction = 'SilentlyContinue' } " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classSmartData @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classThresholds @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classFailurePredictStatus @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $diskDriveHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -ClassName $Using:classDiskDrive @errorParameters ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq ' $cimInstanceErrors ' } -ModuleName DiskSmartInfo

            # $cimSessionHost3 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $ipAddresses[0]}
            # $cimSessionHost4 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $ipAddresses[1]}
            # mock New-CimSession -MockWith { $cimSessionHost3 } -ParameterFilter {$ComputerName -eq $ipAddresses[0]} -ModuleName DiskSmartInfo
            # mock New-CimSession -MockWith { $cimSessionHost4 } -ParameterFilter {$ComputerName -eq $ipAddresses[1]} -ModuleName DiskSmartInfo
            # mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            # mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo $ipAddresses -Transport PSSession
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $ipAddresses
            $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $ipAddresses.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].Name | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(39, 14, 47)
        }
    }

    Context "ComputerName pipeline" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-CimSession -MockWith { $cimSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            mock New-CimSession -MockWith { $cimSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $diskSmartInfo = $computerNames | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].Name | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(39, 14, 47)
        }
    }

    Context "CimSession" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]} -Methods @{TestConnection = {$true}}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]} -Methods @{TestConnection = {$true}}
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -CimSession $cimSessionHost1, $cimSessionHost2
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].Name | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(39, 14, 47)
        }
    }

    Context "CimSession IP Address" {

        BeforeAll {
            $cimSessionHost3 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $ipAddresses[0]} -Methods @{TestConnection = {$true}}
            $cimSessionHost4 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $ipAddresses[1]} -Methods @{TestConnection = {$true}}
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -CimSession $cimSessionHost3, $cimSessionHost4
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $ipAddresses
            $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $ipAddresses.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[1].SmartData | Should -HaveCount 22
            $diskSmartInfo[1].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[1].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[1].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[1].SmartData[2].Name | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[1].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[1].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[1].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[1].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[1].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[1].SmartData[13].Data | Should -Be @(39, 14, 47)
        }
    }

    Context "CimSession pipeline" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]} -Methods @{TestConnection = {$true}}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]} -Methods @{TestConnection = {$true}}
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $cimSessionHost1, $cimSessionHost2 | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].Name | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(39, 14, 47)
        }
    }

    Context "Win32_DiskDrive pipeline" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-CimSession -MockWith { $cimSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            mock New-CimSession -MockWith { $cimSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $diskDriveHost1, $diskDriveHost2 | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            if ($diskSmartInfo[0].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD2
                $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD2
                $diskSmartInfo[0].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[0].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_SSD1
                $diskSmartInfo[0].InstanceId | Should -BeExactly $testData.PNPDeviceID_SSD1
                $diskSmartInfo[0].SmartData | Should -HaveCount 15
            }

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            if ($diskSmartInfo[1].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD2
                $diskSmartInfo[1].InstanceId | Should -BeExactly $testData.PNPDeviceID_HDD2
                $diskSmartInfo[1].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[1].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_SSD1
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
                $diskSmartInfo[1].SmartData | Should -HaveCount 15
            }
        }
    }

    Context "MSFT_Disk pipeline" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-CimSession -MockWith { $cimSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            mock New-CimSession -MockWith { $cimSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $diskHost1, $diskHost2 | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            if ($diskSmartInfo[0].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD2
                $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD2
                $diskSmartInfo[0].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[0].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_SSD1
                $diskSmartInfo[0].InstanceId | Should -BeExactly $testData.PNPDeviceID_SSD1
                $diskSmartInfo[0].SmartData | Should -HaveCount 15
            }

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            if ($diskSmartInfo[1].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD2
                $diskSmartInfo[1].InstanceId | Should -BeExactly $testData.PNPDeviceID_HDD2
                $diskSmartInfo[1].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[1].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_SSD1
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
                $diskSmartInfo[1].SmartData | Should -HaveCount 15
            }
        }
    }

    Context "MSFT_PhysicalDisk pipeline" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-CimSession -MockWith { $cimSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            mock New-CimSession -MockWith { $cimSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $physicalDiskHost1, $physicalDiskHost2 | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            if ($diskSmartInfo[0].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD2
                $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD2
                $diskSmartInfo[0].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[0].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_SSD1
                $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
                $diskSmartInfo[0].SmartData | Should -HaveCount 15
            }

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            if ($diskSmartInfo[1].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD2
                $diskSmartInfo[1].InstanceId | Should -BeExactly $testData.PNPDeviceID_HDD2
                $diskSmartInfo[1].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[1].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_SSD1
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
                $diskSmartInfo[1].SmartData | Should -HaveCount 15
            }
        }
    }

    Context "History ComputerName" {

        Context "-UpdateHistory" {

            BeforeAll {
                $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
                mock New-CimSession -MockWith { $cimSessionHost1 } -ModuleName DiskSmartInfo
                mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.DataHistoryPath = $TestDrive
                }

                Get-DiskSmartInfo -ComputerName $computerNames[0] -UpdateHistory | Out-Null
                $filepath = Join-Path -Path $TestDrive -ChildPath "$($computerNames[0]).json"
            }

            It "Historical data file exists" {
                $filepath | Should -Exist
            }

            It "Historical data file contains proper data" {
                if ($IsCoreCLR)
                {
                    $filepath | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD1_________________________12345678\\1&12345000&0&1.0.0"'))
                }
                else
                {
                    $filepath | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\HDD1_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                }
            }
        }

        Context "-ShowHistory" {

            BeforeAll {
                $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
                mock New-CimSession -MockWith { $cimSessionHost1 } -ModuleName DiskSmartInfo
                mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.DataHistoryPath = $TestDrive
                    $Config.ShowUnchangedDataHistory = $true
                }

                Get-DiskSmartInfo -ComputerName $computerNames[0] -UpdateHistory | Out-Null
                $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames[0] -ShowHistory
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoryDate | Should -Not -BeNullOrEmpty
            }

            It "Attribute data" {
                $diskSmartInfo[0].SmartData[20].DataHistory | Should -Be 702
                $diskSmartInfo[0].SmartData[20].Data | Should -Be 702
            }

            It "DiskSmartInfo object has correct types and properties" {
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo#DataHistory'

                $diskSmartInfo.psobject.properties['ComputerName'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.ComputerName | Should -BeOfType 'System.String'

                $diskSmartInfo.psobject.properties['DiskModel'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.DiskModel | Should -BeOfType 'System.String'

                $diskSmartInfo.psobject.properties['DiskNumber'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.DiskNumber | Should -BeOfType 'System.UInt32'

                $diskSmartInfo.psobject.properties['PNPDeviceId'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.PNPDeviceId | Should -BeOfType 'System.String'

                $diskSmartInfo.psobject.properties['PredictFailure'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.PredictFailure | Should -BeOfType 'System.Boolean'

                $diskSmartInfo.psobject.properties['HistoryDate'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.HistoryDate | Should -BeOfType 'System.DateTime'

                $diskSmartInfo.psobject.properties['SmartData'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.SmartData | Should -Not -BeNullOrEmpty
            }

            It "DiskSmartInfo object is formatted correctly" {
                $format = $diskSmartInfo | Format-Custom

                $propertyValues = $format.formatEntryInfo.formatValueList.formatValueList.formatValuelist.propertyValue -replace '\e\[[0-9]+(;[0-9]+)*m', ''

                $propertyValues | Should -HaveCount 5

                $propertyValues[0] | Should -BeLikeExactly 'ComputerName:*'
                $propertyValues[1] | Should -BeExactly 'Disk:         0: HDD1'
                $propertyValues[2] | Should -BeExactly 'PNPDeviceId:  IDE\HDD1_________________________12345678\1&12345000&0&1.0.0'
                $propertyValues[3] | Should -BeLikeExactly 'HistoryDate:*'
                $propertyValues[4] | Should -BeLikeExactly 'SMARTData:*'
            }
        }
    }
}
