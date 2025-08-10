BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "Get-DiskSmartInfo Ctl" {

    Context "Without parameters" {

        BeforeAll {
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has DiskSmartInfo object properties" {
            $diskSmartInfo.DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_HDD1
            $diskSmartInfo.DiskModel | Should -BeExactly $testDataCtl.CtlModel_HDD1
            $diskSmartInfo.Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1
            $diskSmartInfo.PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailure_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 22
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
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
            $propertyValues[1] | Should -BeExactly 'Device:       /dev/sda'
            $propertyValues[2] | Should -BeLikeExactly 'SMARTData:*'
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'

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
            $format = $diskSmartInfo.SmartData | Format-Table

            $labels = $format.shapeInfo.tableColumnInfoList.Label

            $labels | Should -BeExactly @('ID', 'IDHex', 'AttributeName', 'Threshold', 'Value', 'Worst', 'Data')
        }
    }

    Context "ReplaceSmartCtlAttributeNames = `$false" {

        BeforeAll {
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

            InModuleScope DiskSmartInfo {
                $Config.ReplaceSmartCtlAttributeNames = $false
            }

            $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl
        }

        AfterAll {
            InModuleScope DiskSmartInfo {
                $Config.ReplaceSmartCtlAttributeNames = $true
            }
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has DiskSmartInfo object properties" {
            $diskSmartInfo.DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_HDD1
            $diskSmartInfo.DiskModel | Should -BeExactly $testDataCtl.CtlModel_HDD1
            $diskSmartInfo.Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1
            $diskSmartInfo.PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailure_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 22
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData[0].Name | Should -BeExactly 'Raw_Read_Error_Rate'
            $diskSmartInfo.SmartData[0].ID | Should -Be 1
            $diskSmartInfo.SmartData[2].Name | Should -BeExactly 'Spin_Up_Time'
            $diskSmartInfo.SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo.SmartData[2].Value | Should -Be 71
            $diskSmartInfo.SmartData[2].Worst | Should -Be 69
            $diskSmartInfo.SmartData[3].Name | Should -BeExactly 'Start_Stop_Count'
            $diskSmartInfo.SmartData[3].Data | Should -Be 25733
            $diskSmartInfo.SmartData[12].Name | Should -BeExactly 'Power-Off_Retract_Count'
            $diskSmartInfo.SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo.SmartData[13].Name | Should -BeExactly 'Temperature_Celsius'
            $diskSmartInfo.SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo.SmartData[13].Data | Should -Be @(39, 14, 47)
        }
    }

    Context "-Convert" {

        BeforeAll {
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Convert
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
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute#Converted'

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
            $format = $diskSmartInfo[0].SmartData | Format-Table

            $labels = $format.shapeInfo.tableColumnInfoList.Label

            $labels | Should -BeExactly @('ID', 'IDHex', 'AttributeName', 'Threshold', 'Value', 'Worst', 'Data', 'Converted')
        }
    }

    Context "-Critical" {

        BeforeAll {
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Critical
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
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Quiet
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

    Context "-Critical -Quiet" {

        BeforeAll {
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Critical -Quiet
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

    Context "-Quiet with CriticalThreshold" {

        BeforeAll {
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

            InModuleScope DiskSmartInfo {
                $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeID -eq 197}).CriticalThreshold = 18
                $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeID -eq 198}).CriticalThreshold = 20
            }

            $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Quiet
        }

        AfterAll {
            InModuleScope DiskSmartInfo {
                $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeID -eq 197}).CriticalThreshold = 0
                $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeID -eq 198}).CriticalThreshold = 0
            }
        }

        It "Has 1 DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 1
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has SmartData property with 2 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 2
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Consists of attributes in Warning or Critical state only" {
            $diskSmartInfo.SmartData.Id | Should -Be @(3, 197)
            $diskSmartInfo.SmartData.Data | Should -Be @(6825, 20)
        }
    }


    Context "Select attributes" {

        Context "AttributeID" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeID (1..10)
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 9
                $diskSmartInfo.SmartData[0].ID | Should -Be 1
                $diskSmartInfo.SmartData[8].ID | Should -Be 10
            }
        }

        Context "AttributeIDHex" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeIDHex df, e1, e3
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 2
                $diskSmartInfo.SmartData[0].ID | Should -Be 223
                $diskSmartInfo.SmartData[1].ID | Should -Be 225
            }
        }

        Context "AttributeName" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeName 'Throughput Performance', 'Power-off Retract Count', 'Non existing attribute name'
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 2
                $diskSmartInfo.SmartData[0].ID | Should -Be 2
                $diskSmartInfo.SmartData[1].ID | Should -Be 192
            }
        }

        Context "AttributeName wildcards" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            }

            It "Has requested attribute" {
                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeName '*put*'

                $diskSmartInfo.SmartData | Should -HaveCount 1
                $diskSmartInfo.SmartData.ID | Should -Be 2
                $diskSmartInfo.SmartData.Name | Should -BeExactly 'Throughput Performance'
            }

            It "Has 2 requested attributes" {
                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeName 't*'

                $diskSmartInfo.SmartData | Should -HaveCount 2
                $diskSmartInfo.SmartData[0].ID | Should -Be 2
                $diskSmartInfo.SmartData[0].Name | Should -BeExactly 'Throughput Performance'
                $diskSmartInfo.SmartData[1].ID | Should -Be 194
                $diskSmartInfo.SmartData[1].Name | Should -BeExactly 'Temperature Celsius'
            }

            It "Has 5 requested attributes" {
                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeName 't*','r*'

                $diskSmartInfo.SmartData | Should -HaveCount 5
                $diskSmartInfo.SmartData[0].ID | Should -Be 1
                $diskSmartInfo.SmartData[0].Name | Should -BeExactly 'Raw Read Error Rate'
                $diskSmartInfo.SmartData[4].ID | Should -Be 196
                $diskSmartInfo.SmartData[4].Name | Should -BeExactly 'Reallocation Event Count'
            }
        }

        Context "Nonexistent attributes" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeName '*SomeNonexistentAttribute*'
            }

            It "Has empty result" {
                if ($Config.SuppressResultsWithEmptySmartData)
                {
                    $diskSmartInfo | Should -BeNullOrEmpty
                }
                else
                {
                    $diskSmartInfo.SmartData | Should -BeNullOrEmpty
                }
            }
        }

        Context "Attribute parameters" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeID 1 -AttributeIDHex A -AttributeName 'Power-off Retract Count', 'Spin-Up Time'
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
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo


                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -DiskNumber 0, 2
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD1
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD1
            }
        }

        Context "Pipeline Win32_DiskDrive" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

                $diskSmartInfo = $diskDriveHDD1, $diskDriveSSD1 | Get-DiskSmartInfo -Source SmartCtl
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD1
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD1
            }
        }

        Context "Pipeline MSFT_Disk" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

                $diskSmartInfo = $diskHDD1, $diskSSD1 | Get-DiskSmartInfo -Source SmartCtl
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD1
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD1
            }
        }

        Context "Pipeline MSFT_PhysicalDisk" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

                $diskSmartInfo = $physicalDiskHDD1, $physicalDiskSSD1 | Get-DiskSmartInfo -Source SmartCtl
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD1
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD1
            }
        }

        Context "DiskModel" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -DiskModel "HDD*"
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD2
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD2
            }
        }

        Context "DiskNumber and DiskModel" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -DiskNumber 0 -DiskModel "SSD1"
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD1
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD1
            }
        }

        Context "Device" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Device "/dev/sda", "*sdb"
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD2
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD2
            }
        }

        Context "DiskNumber, DiskModel, and Device" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1, $testDataCtl.CtlScan_SSD2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdd" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -DiskNumber 0 -DiskModel "SSD1" -Device "*sdd"
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 3

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD1
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD1

                $diskSmartInfo[2].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD2
                $diskSmartInfo[2].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD2
            }
        }
    }

    Context "PredictFailure property" {

        Context "Filled SmartData property" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl
            }

            It "Returns DiskSmartInfo object" {
                $diskSmartInfo | Should -HaveCount 1
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            }

            It "Has DiskSmartInfo object properties" {
                $diskSmartInfo.DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo.DiskModel | Should -BeExactly $testDataCtl.CtlModel_HDD1
                $diskSmartInfo.Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1
                $diskSmartInfo.PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailureTrue_HDD1
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

                $propertyValues | Should -HaveCount 4

                $propertyValues[0] | Should -BeExactly 'Disk:         0: HDD1'
                $propertyValues[1] | Should -BeExactly 'Device:       /dev/sda'
                $propertyValues[2] | Should -BeExactly "Failure:      True`n"
                $propertyValues[3] | Should -BeLikeExactly 'SMARTData:*'
            }
        }

        Context "Empty SmartData property" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeID 14
            }

            It "Returns DiskSmartInfo object" {
                $diskSmartInfo | Should -HaveCount 1
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            }

            It "Has DiskSmartInfo object properties" {
                $diskSmartInfo.DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo.DiskModel | Should -BeExactly $testDataCtl.CtlModel_HDD1
                $diskSmartInfo.Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1
                $diskSmartInfo.PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailureTrue_HDD1
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
                $diskSmartInfo.SmartData | Should -BeNullOrEmpty
            }

            It "DiskSmartInfo object is formatted correctly" {
                $format = $diskSmartInfo | Format-Custom

                $propertyValues = $format.formatEntryInfo.formatValueList.formatValueList.formatValuelist.propertyValue -replace '\e\[[0-9]+(;[0-9]+)*m', ''

                $propertyValues | Should -HaveCount 3

                $propertyValues[0] | Should -BeExactly 'Disk:         0: HDD1'
                $propertyValues[1] | Should -BeExactly 'Device:       /dev/sda'
                $propertyValues[2] | Should -BeExactly "Failure:      True`n"
            }
        }

        Context "-Quiet" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Quiet
            }

            It "Returns DiskSmartInfo objects" {
                $diskSmartInfo | Should -HaveCount 2
            }

            It "Has DiskSmartInfo object properties" {
                $diskSmartInfo[0].DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo[0].DiskModel | Should -BeExactly $testDataCtl.CtlModel_HDD1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1
                $diskSmartInfo[0].PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailureTrue_HDD1

                $diskSmartInfo[1].DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_HDD2
                $diskSmartInfo[1].DiskModel | Should -BeExactly $testDataCtl.CtlModel_HDD2
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD2
                $diskSmartInfo[1].PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailure_HDD2
            }

            It "Has empty SmartData property" {
                $diskSmartInfo[0].SmartData | Should -BeNullOrEmpty
                $diskSmartInfo[1].SmartData | Should -HaveCount 3
            }
        }

        Context "-Critical -Quiet" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Critical -Quiet
            }

            It "Returns DiskSmartInfo objects" {
                $diskSmartInfo | Should -HaveCount 2
            }

            It "Has DiskSmartInfo object properties" {
                $diskSmartInfo[0].DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_HDD1
                $diskSmartInfo[0].DiskModel | Should -BeExactly $testDataCtl.CtlModel_HDD1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD1
                $diskSmartInfo[0].PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailureTrue_HDD1

                $diskSmartInfo[1].DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_HDD2
                $diskSmartInfo[1].DiskModel | Should -BeExactly $testDataCtl.CtlModel_HDD2
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD2
                $diskSmartInfo[1].PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailure_HDD2
            }

            It "Has empty SmartData property" {
                $diskSmartInfo[0].SmartData | Should -BeNullOrEmpty
                $diskSmartInfo[1].SmartData | Should -HaveCount 2
            }
        }
    }
}
