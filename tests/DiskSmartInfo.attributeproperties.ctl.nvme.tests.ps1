BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "AttributeProperty NVMe" {

    Context "Default properties" {

        BeforeAll {

            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeProperty ID, IDHex, AttributeName, Threshold, Value, Worst, Data
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has DiskSmartInfo object properties" {
            $diskSmartInfo.DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_NVMe1
            $diskSmartInfo.DiskModel | Should -BeExactly $testDataCtl.CtlModel_NVMe1
            $diskSmartInfo.Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1
            $diskSmartInfo.PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailure_NVMe1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 19
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMeCustom'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData[9].Name | Should -BeExactly 'Controller Busy Time'
            $diskSmartInfo.SmartData[10].Data | Should -BeExactly '600'
            $diskSmartInfo.SmartData[12].Data | Should -BeExactly '45'
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

            $propertyValues[0] | Should -BeExactly 'Disk:         0: Samsung SSD 970 EVO Plus 500GB'
            $propertyValues[1] | Should -BeExactly 'Device:       /dev/nvme0'
            $propertyValues[2] | Should -BeLikeExactly 'SMARTData:*'
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMeCustom'

            $diskSmartInfo.SmartData[0].psobject.properties | Should -HaveCount 2

            $diskSmartInfo.SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Name | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Data | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[13].Data | Should -BeOfType 'System.String'
        }

        It "DiskSmartAttribute object is formatted correctly" {
            $format = $diskSmartInfo.SmartData.FormatTable()

            $propertyNames = $format.shapeInfo.tableColumnInfoList.propertyName

            $propertyNames | Should -BeExactly @('AttributeName', 'Data')
        }
    }

    Context "-Convert" {

        BeforeAll {

            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeProperty ID, IDHex, AttributeName, Threshold, Value, Worst, Data, Converted
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMeCustom'

            $diskSmartInfo[0].SmartData[0].psobject.properties | Should -HaveCount 2

            $diskSmartInfo[0].SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].Name | Should -BeOfType 'System.String'

            $diskSmartInfo[0].SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].Data | Should -BeOfType 'System.String'

            $diskSmartInfo[0].SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[13].Data | Should -BeOfType 'System.String'

            $diskSmartInfo[0].SmartData[0].psobject.properties['DataConverted'] | Should -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[7].psobject.properties['DataConverted'] | Should -BeNullOrEmpty
        }

        It "DiskSmartAttribute object is formatted correctly" {
            $format = $diskSmartInfo[0].SmartData.FormatTable()

            $propertyNames = $format.shapeInfo.tableColumnInfoList.propertyName

            $propertyNames | Should -BeExactly @('AttributeName', 'Data' )
        }
    }

    Context "Subset of the properties" {

        BeforeAll {

            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeProperty Data, ID, AttributeName, Value, Threshold
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has DiskSmartInfo object properties" {
            $diskSmartInfo.DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_NVMe1
            $diskSmartInfo.DiskModel | Should -BeExactly $testDataCtl.CtlModel_NVMe1
            $diskSmartInfo.Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1
            $diskSmartInfo.PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailure_NVMe1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 19
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMeCustom'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData[2].Name | Should -BeExactly 'Available Spare'
            $diskSmartInfo.SmartData[2].Data | Should -BeExactly '100%'
            $diskSmartInfo.SmartData[12].Name | Should -BeExactly 'Unsafe Shutdowns'
            $diskSmartInfo.SmartData[12].Data | Should -BeExactly '45'
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

            $propertyValues[0] | Should -BeExactly 'Disk:         0: Samsung SSD 970 EVO Plus 500GB'
            $propertyValues[1] | Should -BeExactly 'Device:       /dev/nvme0'
            $propertyValues[2] | Should -BeLikeExactly 'SMARTData:*'
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMeCustom'

            $diskSmartInfo.SmartData[0].psobject.properties | Should -HaveCount 2

            $diskSmartInfo.SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Name | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Data | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[13].Data | Should -BeOfType 'System.String'
        }

        It "DiskSmartAttribute object is formatted correctly" {
            $format = $diskSmartInfo.SmartData.FormatTable()

            $propertyNames = $format.shapeInfo.tableColumnInfoList.propertyName

            $propertyNames | Should -BeExactly @('Data', 'AttributeName')
        }
    }
}
