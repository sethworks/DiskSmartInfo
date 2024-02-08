BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "Get-DiskSmartInfo" {

    Context "Without parameters" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has DiskSmartInfo object properties" {
            $diskSmartInfo.DiskNumber | Should -BeExactly $testData.Index_HDD1
            $diskSmartInfo.DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo.PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
            $diskSmartInfo.PredictFailure | Should -BeExactly $testData.FailurePredictStatus_PredictFailure_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 22
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData[0].ID | Should -Be 1
            $diskSmartInfo.SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo.SmartData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo.SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo.SmartData[2].Value | Should -Be 71
            $diskSmartInfo.SmartData[2].Worst | Should -Be 69
            $diskSmartInfo.SmartData[3].Data | Should -Be 25733
            $diskSmartInfo.SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo.SmartData[13].Data | Should -Be @(39, 14, 47)
        }

        It "DiskSmartInfo object has correct types and properties" {
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'

            $diskSmartInfo.psobject.properties['ComputerName'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.ComputerName | Should -BeNullOrEmpty

            $diskSmartInfo.psobject.properties['DiskModel'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.DiskModel | Should -BeOfType 'System.String'

            $diskSmartInfo.psobject.properties['DiskNumber'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.DiskNumber | Should -BeOfType 'System.UInt32'

            $diskSmartInfo.psobject.properties['PNPDeviceId'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.PNPDeviceId | Should -BeOfType 'System.String'

            $diskSmartInfo.psobject.properties['PredictFailure'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.PredictFailure | Should -BeOfType 'System.Boolean'

            $diskSmartInfo.psobject.properties['SmartData'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData | Should -Not -BeNullOrEmpty
        }

        It "DiskSmartInfo object is formatted correctly" {
            $format = $diskSmartInfo | Format-Custom

            $propertyValues = $format.formatEntryInfo.formatValueList.formatValueList.formatValuelist.propertyValue -replace '\e\[[0-9]+(;[0-9]+)*m', ''

            $propertyValues | Should -HaveCount 3

            $propertyValues[0] | Should -BeExactly 'Disk:         0: HDD1'
            $propertyValues[1] | Should -BeExactly 'PNPDeviceId:  IDE\HDD1_________________________12345678\1&12345000&0&1.0.0'
            $propertyValues[2] | Should -BeLikeExactly 'SMARTData:*'
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'

            $diskSmartInfo.SmartData[0].psobject.properties | Should -HaveCount 7

            $diskSmartInfo.SmartData[0].psobject.properties['ID'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].ID | Should -BeOfType 'System.Byte'

            $diskSmartInfo.SmartData[0].psobject.properties['IDHex'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].IDHex | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[0].psobject.properties['AttributeName'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].AttributeName | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[0].psobject.properties['Threshold'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Threshold | Should -BeOfType 'System.Byte'

            $diskSmartInfo.SmartData[0].psobject.properties['Value'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Value | Should -BeOfType 'System.Byte'

            $diskSmartInfo.SmartData[0].psobject.properties['Worst'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Worst | Should -BeOfType 'System.Byte'

            $diskSmartInfo.SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Data | Should -BeOfType 'System.Int64'

            $diskSmartInfo.SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo.SmartData[13].Data[0] | Should -BeOfType 'System.Int64'
        }

        It "DiskSmartAttribute object is formatted correctly" {
            $format = $diskSmartInfo.SmartData | Format-Table

            $labels = $format.shapeInfo.tableColumnInfoList.Label

            $labels | Should -BeExactly @('ID', 'IDHex', 'AttributeName', 'Threshold', 'Value', 'Worst', 'Data')
        }
    }

    Context "-ShowConverted" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -ShowConverted
        }

        It "Converts Spin-Up Time" {
            $diskSmartInfo[0].SmartData[2].DataConverted | Should -BeExactly '9.059 Sec'
        }

        It "Converts Power-On Hours" {
            $diskSmartInfo[0].SmartData[7].DataConverted | Should -BeExactly '3060.25 Days'
        }

        It "Converts Temperature Difference" {
            $diskSmartInfo[1].SmartData[9].DataConverted | Should -BeExactly "60 $([char]0xB0)C"
        }

        It "Converts Total LBAs Written" {
            $diskSmartInfo[1].SmartData[13].DataConverted | Should -BeExactly '5.933 TB'
        }

        It "Converts Total LBAs Read" {
            $diskSmartInfo[1].SmartData[14].DataConverted | Should -BeExactly '4.450 TB'
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute#DataConverted'

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

            $diskSmartInfo[0].SmartData[0].psobject.properties['DataConverted'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].DataConverted | Should -BeNullOrEmpty

            $diskSmartInfo[0].SmartData[7].psobject.properties['DataConverted'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[7].DataConverted | Should -BeOfType 'System.String'
        }

        It "DiskSmartAttribute object is formatted correctly" {
            $format = $diskSmartInfo[0].SmartData | Format-Table

            $labels = $format.shapeInfo.tableColumnInfoList.Label

            $labels | Should -BeExactly @('ID', 'IDHex', 'AttributeName', 'Threshold', 'Value', 'Worst', 'Data', 'Converted')
        }
    }

    Context "-CriticalAttributesOnly" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -CriticalAttributesOnly
        }

        It "Has SmartData property with 5 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 5
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has critical attributes only" {
            $diskSmartInfo.SmartData.Id | Should -Be @(5, 10, 196, 197, 198)
        }
    }

    Context "-Quiet" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -Quiet
        }

        It "Has 1 DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 1
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has SmartData property with 3 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 3
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Consists of attributes in Warning or Critical state only" {
            $diskSmartInfo.SmartData.Id | Should -Be @(3, 197, 198)
            $diskSmartInfo.SmartData.Data | Should -Be @(6825, 20, 20)
        }
    }

    Context "-CriticalAttributesOnly -Quiet" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -CriticalAttributesOnly -Quiet
        }

        It "Has 1 DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 1
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has SmartData property with 2 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 2
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has only critical attributes that are in Warning or Critical state" {
            $diskSmartInfo.SmartData.Id | Should -Be @(197, 198)
            $diskSmartInfo.SmartData.Data | Should -Be @(20, 20)
        }
    }

    Context "Overwrite attribute definitions" {

        Context "Attribute names for overwritten attributes" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1, $diskSmartDataSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1, $diskThresholdsSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusSSD1, $diskFailurePredictStatusHFSSSD1, $diskFailurePredictStatusSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1, $diskDriveSSD2 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
                $diskSmartInfo = Get-DiskSmartInfo
            }

            It "Has 3 DiskSmartInfo objects" {
                $diskSmartInfo | Should -HaveCount 3
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'

                $diskSmartInfo[0].DiskNumber | Should -Be $testData.Index_SSD1
                $diskSmartInfo[1].DiskNumber | Should -Be $testData.Index_HFSSSD1
                $diskSmartInfo[2].DiskNumber | Should -Be $testData.Index_SSD2
            }

            It "Has default attribute definitions" {
                $diskSmartInfo[0].SmartData | Should -HaveCount 15
                $diskSmartInfo[0].SmartData[13].ID | Should -Be 241
                $diskSmartInfo[0].SmartData[13].AttributeName | Should -BeExactly "Total LBAs Written"
                $diskSmartInfo[0].SmartData[14].ID | Should -Be 242
                $diskSmartInfo[0].SmartData[14].AttributeName | Should -BeExactly "Total LBAs Read"
            }

            It "Has overwritten attrubute definitions" {
                $diskSmartInfo[1].SmartData | Should -HaveCount 30
                $diskSmartInfo[1].SmartData[27].ID | Should -Be 241
                $diskSmartInfo[1].SmartData[27].AttributeName | Should -BeExactly "Total Writes GB"
                $diskSmartInfo[1].SmartData[28].ID | Should -Be 242
                $diskSmartInfo[1].SmartData[28].AttributeName | Should -BeExactly "Total Reads GB"
                $diskSmartInfo[1].SmartData[29].ID | Should -Be 249
                $diskSmartInfo[1].SmartData[29].AttributeName | Should -BeExactly "NAND Writes GiB"
            }

            It "Has default attribute definitions" {
                $diskSmartInfo[2].SmartData | Should -HaveCount 15
                $diskSmartInfo[2].SmartData[13].ID | Should -Be 241
                $diskSmartInfo[2].SmartData[13].AttributeName | Should -BeExactly "Total LBAs Written"
                $diskSmartInfo[2].SmartData[14].ID | Should -Be 242
                $diskSmartInfo[2].SmartData[14].AttributeName | Should -BeExactly "Total LBAs Read"
            }
        }

        Context "Converted data for overwritten attributes" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1, $diskSmartDataSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1, $diskThresholdsSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusSSD1, $diskFailurePredictStatusHFSSSD1, $diskFailurePredictStatusSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1, $diskDriveSSD2 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
                $diskSmartInfo = Get-DiskSmartInfo -ShowConverted
            }

            It "Has 3 DiskSmartInfo objects" {
                $diskSmartInfo | Should -HaveCount 3
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'

                $diskSmartInfo[0].DiskNumber | Should -Be $testData.Index_SSD1
                $diskSmartInfo[1].DiskNumber | Should -Be $testData.Index_HFSSSD1
                $diskSmartInfo[2].DiskNumber | Should -Be $testData.Index_SSD2
            }

            It "Has default attribute definitions" {
                $diskSmartInfo[0].SmartData | Should -HaveCount 15
                $diskSmartInfo[0].SmartData[13].ID | Should -Be 241
                $diskSmartInfo[0].SmartData[13].AttributeName | Should -BeExactly "Total LBAs Written"
                $diskSmartInfo[0].SmartData[13].Data | Should -Be 12740846422
                $diskSmartInfo[0].SmartData[13].DataConverted | Should -BeExactly "5.933 TB"
                $diskSmartInfo[0].SmartData[14].ID | Should -Be 242
                $diskSmartInfo[0].SmartData[14].AttributeName | Should -BeExactly "Total LBAs Read"
                $diskSmartInfo[0].SmartData[14].Data | Should -Be 9556432520
                $diskSmartInfo[0].SmartData[14].DataConverted | Should -BeExactly "4.450 TB"
            }

            It "Has overwritten attrubute definitions" {
                $diskSmartInfo[1].SmartData | Should -HaveCount 30
                $diskSmartInfo[1].SmartData[27].ID | Should -Be 241
                $diskSmartInfo[1].SmartData[27].AttributeName | Should -BeExactly "Total Writes GB"
                $diskSmartInfo[1].SmartData[27].Data | Should -Be 2034
                $diskSmartInfo[1].SmartData[27].DataConverted | Should -BeExactly "1.986 TB"
                $diskSmartInfo[1].SmartData[28].ID | Should -Be 242
                $diskSmartInfo[1].SmartData[28].AttributeName | Should -BeExactly "Total Reads GB"
                $diskSmartInfo[1].SmartData[28].Data | Should -Be 2596
                $diskSmartInfo[1].SmartData[28].DataConverted | Should -BeExactly "2.535 TB"
                $diskSmartInfo[1].SmartData[29].AttributeName | Should -BeExactly "NAND Writes GiB"
                $diskSmartInfo[1].SmartData[29].Data | Should -Be 1745
                $diskSmartInfo[1].SmartData[29].DataConverted | Should -BeExactly "1.704 TB"
            }

            It "Has default attribute definitions" {
                $diskSmartInfo[2].SmartData | Should -HaveCount 15
                $diskSmartInfo[2].SmartData[13].ID | Should -Be 241
                $diskSmartInfo[2].SmartData[13].AttributeName | Should -BeExactly "Total LBAs Written"
                $diskSmartInfo[2].SmartData[13].Data | Should -Be 12757689431
                $diskSmartInfo[2].SmartData[13].DataConverted | Should -BeExactly "5.941 TB"
                $diskSmartInfo[2].SmartData[14].ID | Should -Be 242
                $diskSmartInfo[2].SmartData[14].AttributeName | Should -BeExactly "Total LBAs Read"
                $diskSmartInfo[2].SmartData[14].Data | Should -Be 9573275529
                $diskSmartInfo[2].SmartData[14].DataConverted | Should -BeExactly "4.458 TB"
            }
        }

        Context "IsCritical property for overwritten attributes" {

            Context "Default attributes" {

                BeforeAll {
                    mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskFailurePredictStatusSSD1, $diskFailurePredictStatusHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
                    $diskSmartInfo = Get-DiskSmartInfo -CriticalAttributesOnly
                }

                It "Retains IsCritical property value during attribute overwriting" {
                    $diskSmartInfo[1].SmartData | Should -HaveCount 6
                    $diskSmartInfo[1].SmartData[0].ID | Should -Be 5
                    $diskSmartInfo[1].SmartData[0].AttributeName | Should -BeExactly "Retired Block Count"
                }
            }

            Context "Overwrite attributes IsCritical = `$false" {

                BeforeAll {
                    mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskFailurePredictStatusSSD1, $diskFailurePredictStatusHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                    InModuleScope DiskSmartInfo {
                        $proprietaryAttributes.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Add("IsCritical", $false)
                    }

                    $diskSmartInfo = Get-DiskSmartInfo -CriticalAttributesOnly
                }

                AfterAll {
                    InModuleScope DiskSmartInfo {
                        $proprietaryAttributes.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Remove("IsCritical")
                    }
                }

                It "Update IsCritical property value during attribute overwriting" {
                    $diskSmartInfo[1].SmartData | Should -HaveCount 5
                    $diskSmartInfo[1].SmartData[0].ID | Should -Be 184
                    $diskSmartInfo[1].SmartData[0].AttributeName | Should -BeExactly "End-to-End Error"

                    $diskSmartInfo[1].SmartData.AttributeName | Should -Not -Contain 'Retired Block Count'
                }
            }

            Context "Overwrite attributes IsCritical = `$true" {

                BeforeAll {
                    mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskFailurePredictStatusSSD1, $diskFailurePredictStatusHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                    InModuleScope DiskSmartInfo {
                        $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeID -eq 5}).IsCritical = $false
                        $proprietaryAttributes.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Add("IsCritical", $true)
                    }

                    $diskSmartInfo = Get-DiskSmartInfo -CriticalAttributesOnly
                }

                AfterAll {
                    InModuleScope DiskSmartInfo {
                        $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeID -eq 5}).IsCritical = $true
                        $proprietaryAttributes.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Remove("IsCritical")
                    }
                }

                It "Update IsCritical property value during attribute overwriting" {
                    $diskSmartInfo[1].SmartData | Should -HaveCount 6
                    $diskSmartInfo[1].SmartData[0].ID | Should -Be 5
                    $diskSmartInfo[1].SmartData[0].AttributeName | Should -BeExactly "Retired Block Count"
                }
            }
        }
    }

    Context "Select attributes" {

        Context "AttributeID" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -AttributeID (1..10)
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 9
                $diskSmartInfo.SmartData[0].ID | Should -Be 1
                $diskSmartInfo.SmartData[8].ID | Should -Be 10
            }
        }

        Context "AttributeIDHex" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -AttributeIDHex df, e1, e3
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 2
                $diskSmartInfo.SmartData[0].ID | Should -Be 223
                $diskSmartInfo.SmartData[1].ID | Should -Be 225
            }
        }

        Context "AttributeName" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -AttributeName 'Throughput Performance', 'Power-off Retract Count', 'Non existing attribute name'
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 2
                $diskSmartInfo.SmartData[0].ID | Should -Be 2
                $diskSmartInfo.SmartData[1].ID | Should -Be 192
            }
        }

        Context "AttributeName wildcard" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -AttributeName '*put*'
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 1
                $diskSmartInfo.SmartData.ID | Should -Be 2
                $diskSmartInfo.SmartData.AttributeName | Should -BeExactly 'Throughput Performance'
            }
        }

        Context "Non-existing attributes" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -AttributeName '*SomeNonExistingAttribute*'
            }

            It "Has empty result" {
                $diskSmartInfo | Should -BeNullOrEmpty
            }
        }

        Context "Attribute parameters" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -AttributeID 1 -AttributeIDHex A -AttributeName 'Power-off Retract Count', 'Spin-Up Time'
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 4
                $diskSmartInfo.SmartData[0].ID | Should -Be 1
                $diskSmartInfo.SmartData[1].ID | Should -Be 3
                $diskSmartInfo.SmartData[2].ID | Should -Be 10
                $diskSmartInfo.SmartData[3].ID | Should -Be 192
            }
        }
    }

    Context "Select disks" {

        Context "DiskNumber" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -DiskNumber 0, 2
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testData.Index_HDD1
                $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testData.Index_SSD1
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
            }
        }

        Context "Pipeline Win32_DiskDrive" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = $diskDriveHDD1, $diskDriveSSD1 | Get-DiskSmartInfo
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testData.Index_HDD1
                $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testData.Index_SSD1
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
            }
        }

        Context "Pipeline MSFT_Disk" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = $diskHDD1, $diskSSD1 | Get-DiskSmartInfo
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testData.Index_HDD1
                $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testData.Index_SSD1
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
            }
        }

        Context "Pipeline MSFT_PhysicalDisk" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = $physicalDiskHDD1, $physicalDiskSSD1 | Get-DiskSmartInfo
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testData.Index_HDD1
                $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testData.Index_SSD1
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
            }
        }

        Context "DiskModel" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -DiskModel "HDD*"
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testData.Index_HDD1
                $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testData.Index_HDD2
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD2
            }
        }

        Context "DiskNumber and DiskModel" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -DiskNumber 0 -DiskModel "SSD1"
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testData.Index_HDD1
                $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testData.Index_SSD1
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_SSD1
            }
        }
    }

    Context "PredictFailure property" {

        Context "Filled SmartData property" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusTrueHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo
            }

            It "Returns DiskSmartInfo object" {
                $diskSmartInfo | Should -HaveCount 1
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            }

            It "Has DiskSmartInfo object properties" {
                $diskSmartInfo.DiskNumber | Should -BeExactly $testData.Index_HDD1
                $diskSmartInfo.DiskModel | Should -BeExactly $testData.Model_HDD1
                $diskSmartInfo.PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
                $diskSmartInfo.PredictFailure | Should -BeExactly $testData.FailurePredictStatus_PredictFailureTrue_HDD1
            }

            It "DiskSmartInfo object has correct types and properties" {
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'

                $diskSmartInfo.psobject.properties['ComputerName'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.ComputerName | Should -BeNullOrEmpty

                $diskSmartInfo.psobject.properties['DiskModel'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.DiskModel | Should -BeOfType 'System.String'

                $diskSmartInfo.psobject.properties['DiskNumber'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.DiskNumber | Should -BeOfType 'System.UInt32'

                $diskSmartInfo.psobject.properties['PNPDeviceId'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.PNPDeviceId | Should -BeOfType 'System.String'

                $diskSmartInfo.psobject.properties['PredictFailure'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.PredictFailure | Should -BeOfType 'System.Boolean'

                $diskSmartInfo.psobject.properties['SmartData'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.SmartData | Should -Not -BeNullOrEmpty
            }

            It "DiskSmartInfo object is formatted correctly" {
                $format = $diskSmartInfo | Format-Custom

                $propertyValues = $format.formatEntryInfo.formatValueList.formatValueList.formatValuelist.propertyValue -replace '\e\[[0-9]+(;[0-9]+)*m', ''

                $propertyValues | Should -HaveCount 4

                $propertyValues[0] | Should -BeExactly 'Disk:         0: HDD1'
                $propertyValues[1] | Should -BeExactly 'PNPDeviceId:  IDE\HDD1_________________________12345678\1&12345000&0&1.0.0'
                $propertyValues[2] | Should -BeExactly "Failure:      True`n"
                $propertyValues[3] | Should -BeLikeExactly 'SMARTData:*'
            }
        }

        Context "Empty SmartData property" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusTrueHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -AttributeID 14
            }

            It "Returns DiskSmartInfo object" {
                $diskSmartInfo | Should -HaveCount 1
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            }

            It "Has DiskSmartInfo object properties" {
                $diskSmartInfo.DiskNumber | Should -BeExactly $testData.Index_HDD1
                $diskSmartInfo.DiskModel | Should -BeExactly $testData.Model_HDD1
                $diskSmartInfo.PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
                $diskSmartInfo.PredictFailure | Should -BeExactly $testData.FailurePredictStatus_PredictFailureTrue_HDD1
            }

            It "DiskSmartInfo object has correct types and properties" {
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'

                $diskSmartInfo.psobject.properties['ComputerName'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.ComputerName | Should -BeNullOrEmpty

                $diskSmartInfo.psobject.properties['DiskModel'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.DiskModel | Should -BeOfType 'System.String'

                $diskSmartInfo.psobject.properties['DiskNumber'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.DiskNumber | Should -BeOfType 'System.UInt32'

                $diskSmartInfo.psobject.properties['PNPDeviceId'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.PNPDeviceId | Should -BeOfType 'System.String'

                $diskSmartInfo.psobject.properties['PredictFailure'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.PredictFailure | Should -BeOfType 'System.Boolean'

                $diskSmartInfo.psobject.properties['SmartData'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo.SmartData | Should -BeNullOrEmpty
            }

            It "DiskSmartInfo object is formatted correctly" {
                $format = $diskSmartInfo | Format-Custom

                $propertyValues = $format.formatEntryInfo.formatValueList.formatValueList.formatValuelist.propertyValue -replace '\e\[[0-9]+(;[0-9]+)*m', ''

                $propertyValues | Should -HaveCount 3

                $propertyValues[0] | Should -BeExactly 'Disk:         0: HDD1'
                $propertyValues[1] | Should -BeExactly 'PNPDeviceId:  IDE\HDD1_________________________12345678\1&12345000&0&1.0.0'
                $propertyValues[2] | Should -BeExactly "Failure:      True`n"
            }
        }

        Context "-Quiet" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusTrueHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Quiet
            }

            It "Returns DiskSmartInfo objects" {
                $diskSmartInfo | Should -HaveCount 2
            }

            It "Has DiskSmartInfo object properties" {
                $diskSmartInfo[0].DiskNumber | Should -BeExactly $testData.Index_HDD1
                $diskSmartInfo[0].DiskModel | Should -BeExactly $testData.Model_HDD1
                $diskSmartInfo[0].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD1
                $diskSmartInfo[0].PredictFailure | Should -BeExactly $testData.FailurePredictStatus_PredictFailureTrue_HDD1

                $diskSmartInfo[1].DiskNumber | Should -BeExactly $testData.Index_HDD2
                $diskSmartInfo[1].DiskModel | Should -BeExactly $testData.Model_HDD2
                $diskSmartInfo[1].PNPDeviceID | Should -BeExactly $testData.PNPDeviceID_HDD2
                $diskSmartInfo[1].PredictFailure | Should -BeExactly $testData.FailurePredictStatus_PredictFailure_HDD2
            }

            It "Has empty SmartData property" {
                $diskSmartInfo[0].SmartData | Should -BeNullOrEmpty
                $diskSmartInfo[1].SmartData | Should -HaveCount 3
            }
        }
    }
}
