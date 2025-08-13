BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "AttributeProperty" {

    Context "Default properties" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -AttributeProperty ID, IDHex, AttributeName, Threshold, Value, Worst, Data
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has DiskSmartInfo object properties" {
            $diskSmartInfo.DiskNumber | Should -BeExactly $testData.Index_HDD1
            $diskSmartInfo.DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo.Device | Should -BeExactly $testData.Device_HDD1
            $diskSmartInfo.PredictFailure | Should -BeExactly $testData.FailurePredictStatus_PredictFailure_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 22
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeCustom'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData[0].ID | Should -Be 1
            $diskSmartInfo.SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo.SmartData[2].Name | Should -BeExactly 'Spin-Up Time'
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

            $diskSmartInfo.psobject.properties['Device'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.Device | Should -BeOfType 'System.String'

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
            $propertyValues[1] | Should -BeExactly 'Device:       IDE\HDD1_________________________12345678\1&12345000&0&1.0.0'
            $propertyValues[2] | Should -BeLikeExactly 'SMARTData:*'
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeCustom'

            $diskSmartInfo.SmartData[0].psobject.properties | Should -HaveCount 7

            $diskSmartInfo.SmartData[0].psobject.properties['ID'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].ID | Should -BeOfType 'System.Byte'

            $diskSmartInfo.SmartData[0].psobject.properties['IDHex'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].IDHex | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Name | Should -BeOfType 'System.String'

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
            $format = $diskSmartInfo.SmartData.FormatTable()

            $propertyNames = $format.shapeInfo.tableColumnInfoList.propertyName

            $propertyNames | Should -BeExactly @('ID', 'IDHex', 'AttributeName', 'Threshold', 'Value', 'Worst', 'Data')
        }
    }

    Context "-Convert" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -AttributeProperty ID, IDHex, AttributeName, Threshold, Value, Worst, Data, Converted
        }

        It "Converts Spin-Up Time" {
            $diskSmartInfo[0].SmartData[2].DataConverted | Should -BeExactly '9.059 Sec'
        }

        It "Converts Power-On Hours" {
            $diskSmartInfo[0].SmartData[7].DataConverted | Should -BeExactly '3060.25 Days'
        }

        It "Converts Airflow Temperature Celsius" {
            $diskSmartInfo[1].SmartData[9].DataConverted | Should -BeExactly "40 $([char]0xB0)C"
        }

        It "Converts Total LBAs Written" {
            $diskSmartInfo[1].SmartData[13].DataConverted | Should -BeExactly '5.933 TB'
        }

        It "Converts Total LBAs Read" {
            $diskSmartInfo[1].SmartData[14].DataConverted | Should -BeExactly '4.450 TB'
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeCustom'

            $diskSmartInfo[0].SmartData[0].psobject.properties | Should -HaveCount 8

            $diskSmartInfo[0].SmartData[0].psobject.properties['ID'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].ID | Should -BeOfType 'System.Byte'

            $diskSmartInfo[0].SmartData[0].psobject.properties['IDHex'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].IDHex | Should -BeOfType 'System.String'

            $diskSmartInfo[0].SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].Name | Should -BeOfType 'System.String'

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
            $format = $diskSmartInfo[0].SmartData.FormatTable()

            $propertyNames = $format.shapeInfo.tableColumnInfoList.propertyName

            $propertyNames | Should -BeExactly @('ID', 'IDHex', 'AttributeName', 'Threshold', 'Value', 'Worst', 'Data', 'Converted')
        }
    }

    Context "Subset of the properties" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -AttributeProperty ID, AttributeName, Data, Value, Threshold
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has DiskSmartInfo object properties" {
            $diskSmartInfo.DiskNumber | Should -BeExactly $testData.Index_HDD1
            $diskSmartInfo.DiskModel | Should -BeExactly $testData.Model_HDD1
            $diskSmartInfo.Device | Should -BeExactly $testData.Device_HDD1
            $diskSmartInfo.PredictFailure | Should -BeExactly $testData.FailurePredictStatus_PredictFailure_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 22
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeCustom'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData[0].ID | Should -Be 1
            $diskSmartInfo.SmartData[2].Name | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo.SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo.SmartData[2].Value | Should -Be 71
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

            $diskSmartInfo.psobject.properties['Device'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.Device | Should -BeOfType 'System.String'

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
            $propertyValues[1] | Should -BeExactly 'Device:       IDE\HDD1_________________________12345678\1&12345000&0&1.0.0'
            $propertyValues[2] | Should -BeLikeExactly 'SMARTData:*'
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeCustom'

            $diskSmartInfo.SmartData[0].psobject.properties | Should -HaveCount 5

            $diskSmartInfo.SmartData[0].psobject.properties['ID'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].ID | Should -BeOfType 'System.Byte'

            $diskSmartInfo.SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Name | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[0].psobject.properties['Threshold'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Threshold | Should -BeOfType 'System.Byte'

            $diskSmartInfo.SmartData[0].psobject.properties['Value'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Value | Should -BeOfType 'System.Byte'

            $diskSmartInfo.SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Data | Should -BeOfType 'System.Int64'

            $diskSmartInfo.SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo.SmartData[13].Data[0] | Should -BeOfType 'System.Int64'
        }

        It "DiskSmartAttribute object is formatted correctly" {
            $format = $diskSmartInfo.SmartData.FormatTable()

            $propertyNames = $format.shapeInfo.tableColumnInfoList.propertyName

            $propertyNames | Should -BeExactly @('ID', 'AttributeName', 'Data', 'Value', 'Threshold')
        }
    }
}
