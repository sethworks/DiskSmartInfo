BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

# Skip if remoting is disabled
$skipRemoting = !(Test-WSMan -ComputerName localhost -ErrorAction SilentlyContinue)

Describe "DiskSmartInfo remoting tests" -Skip:$skipRemoting {

    Context "ComputerName" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(47, 14, 39)
        }
    }
    Context "ComputerName IP Address" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -ComputerName $ipAddresses
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $ipAddresses
            $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $ipAddresses.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[1].SmartData | Should -HaveCount 22
            $diskSmartInfo[1].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[1].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[1].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[1].SmartData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[1].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[1].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[1].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[1].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[1].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[1].SmartData[13].Data | Should -Be @(47, 14, 39)
        }
    }

    Context "ComputerName positional" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo $computerNames
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(47, 14, 39)
        }
    }
    Context "ComputerName positional IP Address" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo $ipAddresses
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $ipAddresses
            $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $ipAddresses.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[1].SmartData | Should -HaveCount 22
            $diskSmartInfo[1].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[1].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[1].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[1].SmartData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[1].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[1].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[1].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[1].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[1].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[1].SmartData[13].Data | Should -Be @(47, 14, 39)
        }
    }
    Context "ComputerName pipeline" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $computerNames | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(47, 14, 39)
        }
    }
    Context "CimSession" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $cim = New-CimSession -ComputerName $computerNames
            $diskSmartInfo = Get-DiskSmartInfo -CimSession $cim
        }

        AfterAll {
            Remove-CimSession -CimSession $cim
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(47, 14, 39)
        }
    }
    Context "CimSession IP Address" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $cim = New-CimSession -ComputerName $ipAddresses
            $diskSmartInfo = Get-DiskSmartInfo -CimSession $cim
        }

        AfterAll {
            Remove-CimSession -CimSession $cim
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $ipAddresses
            $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $ipAddresses.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[1].SmartData | Should -HaveCount 22
            $diskSmartInfo[1].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[1].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[1].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[1].SmartData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[1].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[1].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[1].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[1].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[1].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[1].SmartData[13].Data | Should -Be @(47, 14, 39)
        }
    }
    Context "CimSession pipeline" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $cim = New-CimSession -ComputerName $computerNames
            $diskSmartInfo = $cim | Get-DiskSmartInfo
        }

        AfterAll {
            Remove-CimSession -CimSession $cim
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(47, 14, 39)
        }
    }
    Context "Win32_DiskDrive pipeline" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $diskDriveHost1, $diskDriveHost2 | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            if ($diskSmartInfo[0].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD2
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
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD2
                $diskSmartInfo[1].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[1].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_SSD1
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
                $diskSmartInfo[1].SmartData | Should -HaveCount 15
            }
        }
    }
    Context "MSFT_Disk pipeline" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $diskHost1, $diskHost2 | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            if ($diskSmartInfo[0].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD2
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
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD2
                $diskSmartInfo[1].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[1].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_SSD1
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
                $diskSmartInfo[1].SmartData | Should -HaveCount 15
            }
        }
    }
    Context "MSFT_PhysicalDisk pipeline" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $physicalDiskHost1, $physicalDiskHost2 | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            if ($diskSmartInfo[0].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD2
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
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD2
                $diskSmartInfo[1].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[1].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_SSD1
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
                $diskSmartInfo[1].SmartData | Should -HaveCount 15
            }
        }
    }

    Context "History ComputerName" {

        Context "-UpdateHistory" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.HistoricalDataPath = $TestDrive
                }

                Get-DiskSmartInfo -ComputerName $computerNames[0] -UpdateHistory | Out-Null
                $filepath = Join-Path -Path $TestDrive -ChildPath "$($computerNames[0]).txt"
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
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.HistoricalDataPath = $TestDrive
                }

                Get-DiskSmartInfo -ComputerName $computerNames[0] -UpdateHistory | Out-Null
                $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames[0] -ShowHistory
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoricalDate | Should -Not -BeNullOrEmpty
            }

            It "Attribute data" {
                $diskSmartInfo[0].SmartData[21].DataHistory | Should -Be 26047
                $diskSmartInfo[0].SmartData[21].Data | Should -Be 26047
            }
        }
    }
}
