BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "History" {

    Context "-ShowHistory before updating" {
        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            InModuleScope DiskSmartInfo {
                $Config.HistoricalDataPath = $TestDrive
            }

            $diskSmartInfo = Get-DiskSmartInfo -ShowHistory
        }

        It "Attribute data" {
            $diskSmartInfo[0].SmartData[10].DataHistory | Should -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[10].Data | Should -Be 358

            $diskSmartInfo[0].SmartData[20].DataHistory | Should -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[20].Data | Should -Be 702
        }

        It "DiskSmartInfo object has correct types and properties" {
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#DataHistory'

            $diskSmartInfo[0].psobject.properties['ComputerName'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].ComputerName | Should -BeNullOrEmpty

            $diskSmartInfo[0].psobject.properties['DiskModel'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].DiskModel | Should -BeOfType 'System.String'

            $diskSmartInfo[0].psobject.properties['DiskNumber'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].DiskNumber | Should -BeOfType 'System.UInt32'

            $diskSmartInfo[0].psobject.properties['PNPDeviceId'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].PNPDeviceId | Should -BeOfType 'System.String'

            $diskSmartInfo[0].psobject.properties['PredictFailure'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].PredictFailure | Should -BeOfType 'System.Boolean'

            $diskSmartInfo[0].psobject.properties['HistoryDate'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].HistoryDate | Should -BeNullOrEmpty

            $diskSmartInfo[0].psobject.properties['SmartData'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData | Should -Not -BeNullOrEmpty
        }

        It "DiskSmartInfo object is formatted correctly" {
            $format = $diskSmartInfo[0] | Format-Custom

            $propertyValues = $format.formatEntryInfo.formatValueList.formatValueList.formatValuelist.propertyValue -replace '\e\[[0-9]+(;[0-9]+)*m', ''

            $propertyValues | Should -HaveCount 4

            $propertyValues[0] | Should -BeExactly 'Disk:         0: HDD1'
            $propertyValues[1] | Should -BeExactly 'PNPDeviceId:  IDE\HDD1_________________________12345678\1&12345000&0&1.0.0'
            $propertyValues[2] | Should -BeLikeExactly 'HistoryDate:*'
            $propertyValues[3] | Should -BeLikeExactly 'SMARTData:*'
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute#DataHistory'

            $diskSmartInfo[0].SmartData[0].psobject.properties | Should -HaveCount 8

            $diskSmartInfo[0].SmartData[0].psobject.properties['ID'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].ID | Should -BeOfType 'System.Byte'

            $diskSmartInfo[0].SmartData[0].psobject.properties['IDHex'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].IDHex | Should -BeOfType 'System.String'

            $diskSmartInfo[0].SmartData[0].psobject.properties['AttributeName'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].AttributeName | Should -BeOfType 'System.String'

            $diskSmartInfo[0].SmartData[0].psobject.properties['Threshold'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].Threshold | Should -BeOfType 'System.Byte'

            $diskSmartInfo[0].SmartData[0].psobject.properties['Value'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].Value | Should -BeOfType 'System.Byte'

            $diskSmartInfo[0].SmartData[0].psobject.properties['Worst'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].Worst | Should -BeOfType 'System.Byte'

            $diskSmartInfo[0].SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].Data | Should -BeOfType 'System.Int64'

            $diskSmartInfo[0].SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data[0] | Should -BeOfType 'System.Int64'

            $diskSmartInfo[0].SmartData[0].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].DataHistory | Should -BeNullOrEmpty

            $diskSmartInfo[0].SmartData[13].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[13].DataHistory | Should -BeNullOrEmpty
        }

        It "DiskSmartAttribute object is formatted correctly" {
            $format = $diskSmartInfo[0].SmartData | Format-Table

            $labels = $format.shapeInfo.tableColumnInfoList.Label

            $labels | Should -BeExactly @('ID', 'IDHex', 'AttributeName', 'Threshold', 'Value', 'Worst', 'Data', 'History')
        }
    }

    Context "-UpdateHistory" {
        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            InModuleScope DiskSmartInfo {
                $Config.HistoricalDataPath = $TestDrive
            }
            Get-DiskSmartInfo -UpdateHistory | Out-Null
        }
        It "Historical data file exists" {
            'TestDrive:\localhost.txt' | Should -Exist
        }
        It "Historical data file contains proper data" {
            if ($IsCoreCLR)
            {
                'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD1_________________________12345678\\1&12345000&0&1.0.0"'))
                'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD2_________________________12345678\\1&12345000&0&1.0.0"'))
                'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\SSD1_________________________12345678\\1&12345000&0&1.0.0"'))
            }
            else
            {
                'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\HDD1_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\HDD2_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\SSD1_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
            }
        }
    }

    Context "-ShowHistory" {

        Context "ShowUnchangedHistoricalData = `$true" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedHistoricalData = $true
                    $Config.HistoricalDataPath = $TestDrive
                }

                Get-DiskSmartInfo -UpdateHistory | Out-Null

                if ($IsCoreCLR)
                {
                    (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data": 358', '"Data": 357' | Set-Content -Path 'TestDrive:/localhost.txt'
                }
                else
                {
                    (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data":  358', '"Data":  357' | Set-Content -Path 'TestDrive:/localhost.txt'
                }

                $diskSmartInfo = Get-DiskSmartInfo -ShowHistory
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[10].DataHistory | Should -Be 357
                $diskSmartInfo[0].SmartData[10].Data | Should -Be 358
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[20].DataHistory | Should -Be 702
                $diskSmartInfo[0].SmartData[20].Data | Should -Be 702
            }

            It "DiskSmartInfo object has correct types and properties" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#DataHistory'

                $diskSmartInfo[0].psobject.properties['ComputerName'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].ComputerName | Should -BeNullOrEmpty

                $diskSmartInfo[0].psobject.properties['DiskModel'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].DiskModel | Should -BeOfType 'System.String'

                $diskSmartInfo[0].psobject.properties['DiskNumber'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].DiskNumber | Should -BeOfType 'System.UInt32'

                $diskSmartInfo[0].psobject.properties['PNPDeviceId'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].PNPDeviceId | Should -BeOfType 'System.String'

                $diskSmartInfo[0].psobject.properties['PredictFailure'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].PredictFailure | Should -BeOfType 'System.Boolean'

                $diskSmartInfo[0].psobject.properties['HistoryDate'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].HistoryDate | Should -BeOfType 'System.DateTime'

                $diskSmartInfo[0].psobject.properties['SmartData'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData | Should -Not -BeNullOrEmpty
            }

            It "DiskSmartInfo object is formatted correctly" {
                $format = $diskSmartInfo[0] | Format-Custom

                $propertyValues = $format.formatEntryInfo.formatValueList.formatValueList.formatValuelist.propertyValue -replace '\e\[[0-9]+(;[0-9]+)*m', ''

                $propertyValues | Should -HaveCount 4

                $propertyValues[0] | Should -BeExactly 'Disk:         0: HDD1'
                $propertyValues[1] | Should -BeExactly 'PNPDeviceId:  IDE\HDD1_________________________12345678\1&12345000&0&1.0.0'
                $propertyValues[2] | Should -BeLikeExactly 'HistoryDate:*'
                $propertyValues[3] | Should -BeLikeExactly 'SMARTData:*'
            }

            It "DiskSmartAttribute object has correct types and properties" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute#DataHistory'

                $diskSmartInfo[0].SmartData[0].psobject.properties | Should -HaveCount 8

                $diskSmartInfo[0].SmartData[0].psobject.properties['ID'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].ID | Should -BeOfType 'System.Byte'

                $diskSmartInfo[0].SmartData[0].psobject.properties['IDHex'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].IDHex | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['AttributeName'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].AttributeName | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Threshold'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Threshold | Should -BeOfType 'System.Byte'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Value'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Value | Should -BeOfType 'System.Byte'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Worst'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Worst | Should -BeOfType 'System.Byte'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Data | Should -BeOfType 'System.Int64'

                $diskSmartInfo[0].SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
                $diskSmartInfo[0].SmartData[13].Data[0] | Should -BeOfType 'System.Int64'

                $diskSmartInfo[0].SmartData[0].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].DataHistory | Should -BeOfType 'System.Int64'

                $diskSmartInfo[0].SmartData[13].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].DataHistory | Should -HaveCount 3
                $diskSmartInfo[0].SmartData[13].DataHistory[0] | Should -BeOfType 'System.Int64'
            }

            It "DiskSmartAttribute object is formatted correctly" {
                $format = $diskSmartInfo[0].SmartData | Format-Table

                $labels = $format.shapeInfo.tableColumnInfoList.Label

                $labels | Should -BeExactly @('ID', 'IDHex', 'AttributeName', 'Threshold', 'Value', 'Worst', 'Data', 'History')
            }
        }

        Context "ShowUnchangedHistoricalData = `$false" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedHistoricalData = $false
                    $Config.HistoricalDataPath = $TestDrive
                }

                Get-DiskSmartInfo -UpdateHistory | Out-Null

                if ($IsCoreCLR)
                {
                    (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data": 358', '"Data": 357' | Set-Content -Path 'TestDrive:/localhost.txt'
                }
                else
                {
                    (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data":  358', '"Data":  357' | Set-Content -Path 'TestDrive:/localhost.txt'
                }

                $diskSmartInfo = Get-DiskSmartInfo -ShowHistory
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedHistoricalData = $true
                }
            }

            It "Object is of proper type" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#DataHistory'
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoryDate | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].HistoryDate | Should -BeOfType 'System.DateTime'
            }

            It "Attribute object is of proper type" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute#DataHistory'
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[10].DataHistory | Should -Be 357
                $diskSmartInfo[0].SmartData[10].Data | Should -Be 358
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[20].DataHistory | Should -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[20].Data | Should -Be 702
            }
        }

        Context "-ShowHistory -ShowConverted" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedHistoricalData = $true
                    $Config.HistoricalDataPath = $TestDrive
                }

                Get-DiskSmartInfo -UpdateHistory | Out-Null

                if ($IsCoreCLR)
                {
                    (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data": 358', '"Data": 357' | Set-Content -Path 'TestDrive:/localhost.txt'
                }
                else
                {
                    (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data":  358', '"Data":  357' | Set-Content -Path 'TestDrive:/localhost.txt'
                }

                $diskSmartInfo = Get-DiskSmartInfo -ShowHistory -ShowConverted
            }

            It "Object is of proper type" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#DataHistory'
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoryDate | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].HistoryDate | Should -BeOfType 'System.DateTime'
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[10].DataHistory | Should -Be 357
                $diskSmartInfo[0].SmartData[10].Data | Should -Be 358
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[20].DataHistory | Should -Be 702
                $diskSmartInfo[0].SmartData[20].Data | Should -Be 702
            }

            It "DiskSmartAttribute object has correct types and properties" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute#DataHistoryDataConverted'

                $diskSmartInfo[0].SmartData[0].psobject.properties | Should -HaveCount 9

                $diskSmartInfo[0].SmartData[0].psobject.properties['ID'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].ID | Should -BeOfType 'System.Byte'

                $diskSmartInfo[0].SmartData[0].psobject.properties['IDHex'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].IDHex | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['AttributeName'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].AttributeName | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Threshold'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Threshold | Should -BeOfType 'System.Byte'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Value'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Value | Should -BeOfType 'System.Byte'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Worst'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Worst | Should -BeOfType 'System.Byte'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Data | Should -BeOfType 'System.Int64'

                $diskSmartInfo[0].SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
                $diskSmartInfo[0].SmartData[13].Data[0] | Should -BeOfType 'System.Int64'

                $diskSmartInfo[0].SmartData[0].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].DataHistory | Should -BeOfType 'System.Int64'

                $diskSmartInfo[0].SmartData[13].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].DataHistory | Should -HaveCount 3
                $diskSmartInfo[0].SmartData[13].DataHistory[0] | Should -BeOfType 'System.Int64'

                $diskSmartInfo[0].SmartData[0].psobject.properties['DataConverted'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].DataConverted | Should -BeNullOrEmpty

                $diskSmartInfo[0].SmartData[7].psobject.properties['DataConverted'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[7].DataConverted | Should -BeOfType 'System.String'
            }

            It "DiskSmartAttribute object is formatted correctly" {
                $format = $diskSmartInfo[0].SmartData | Format-Table

                $labels = $format.shapeInfo.tableColumnInfoList.Label

                $labels | Should -BeExactly @('ID', 'IDHex', 'AttributeName', 'Threshold', 'Value', 'Worst', 'Data', 'History', 'Converted')
            }
        }
    }
}
