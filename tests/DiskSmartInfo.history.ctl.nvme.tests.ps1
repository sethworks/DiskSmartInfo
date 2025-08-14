BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "History NVMe" {

    Context "-ShowHistory before updating" {

        BeforeAll {

            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

            if (-not $IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
            }
            elseif ($IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
            }

            InModuleScope DiskSmartInfo {
                $Config.DataHistoryPath = $TestDrive
            }

            if (-not $IsLinux)
            {
                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -ShowHistory
            }
            elseif ($IsLinux)
            {
                $diskSmartInfo = Get-DiskSmartInfo -ShowHistory
            }
        }

        It "Attribute data" {
            $diskSmartInfo[0].SmartData[9].DataHistory | Should -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[9].Data | Should -BeExactly '715'

            $diskSmartInfo[0].SmartData[12].DataHistory | Should -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[12].Data | Should -BeExactly '45'
        }

        It "DiskSmartInfo object has correct types and properties" {
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#History'

            $diskSmartInfo[0].psobject.properties['ComputerName'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].ComputerName | Should -BeNullOrEmpty

            $diskSmartInfo[0].psobject.properties['DiskModel'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].DiskModel | Should -BeOfType 'System.String'

            $diskSmartInfo[0].psobject.properties['DiskNumber'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].DiskNumber | Should -BeOfType 'System.UInt32'

            $diskSmartInfo[0].psobject.properties['Device'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].Device | Should -BeOfType 'System.String'

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

            $propertyValues[0] | Should -BeExactly 'Disk:         0: Samsung SSD 970 EVO Plus 500GB'
            $propertyValues[1] | Should -BeExactly 'Device:       /dev/nvme0'
            $propertyValues[2] | Should -BeLikeExactly 'HistoryDate:*'
            $propertyValues[3] | Should -BeLikeExactly 'SMARTData:*'
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMe#History'

            $diskSmartInfo[0].SmartData[0].psobject.properties | Should -HaveCount 3

            $diskSmartInfo[0].SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].Name | Should -BeOfType 'System.String'

            $diskSmartInfo[0].SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].Data | Should -BeOfType 'System.String'

            $diskSmartInfo[0].SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[13].Data | Should -BeOfType 'System.String'

            $diskSmartInfo[0].SmartData[0].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[0].DataHistory | Should -BeNullOrEmpty

            $diskSmartInfo[0].SmartData[13].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo[0].SmartData[13].DataHistory | Should -BeNullOrEmpty
        }

        It "DiskSmartAttribute object is formatted correctly" {
            $format = $diskSmartInfo[0].SmartData | Format-Table

            $labels = $format.shapeInfo.tableColumnInfoList.Label

            $labels | Should -BeExactly @('AttributeName', 'Data', 'History')
        }
    }

    Context "-UpdateHistory" {

        BeforeAll {

            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

            if (-not $IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
            }
            elseif ($IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
            }

            InModuleScope DiskSmartInfo {
                $Config.DataHistoryPath = $TestDrive
            }

            if (-not $IsLinux)
            {
                Get-DiskSmartInfo -Source SmartCtl -UpdateHistory | Out-Null
            }
            elseif ($IsLinux)
            {
                Get-DiskSmartInfo -UpdateHistory | Out-Null
            }
        }

        It "Historical data file exists" {
            'TestDrive:/localhost.json' | Should -Exist
        }

        It "Historical data file contains proper data" {
            if ($IsCoreCLR)
            {
                'TestDrive:/localhost.json' | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme0"'))
                'TestDrive:/localhost.json' | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme1"'))
            }
            else
            {
                'TestDrive:/localhost.json' | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme0"'))
                'TestDrive:/localhost.json' | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme1"'))
            }
        }
    }

    Context "-ShowHistory" {

        Context "ShowUnchangedDataHistory = `$true" {

            BeforeAll {

                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }

                InModuleScope DiskSmartInfo {
                    $Config.DataHistoryPath = $TestDrive
                    $Config.ShowUnchangedDataHistory = $true
                }

                if (-not $IsLinux)
                {
                    Get-DiskSmartInfo -Source SmartCtl -UpdateHistory | Out-Null
                }
                elseif ($IsLinux)
                {
                    Get-DiskSmartInfo -UpdateHistory | Out-Null
                }

                if ($IsCoreCLR)
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data": "715"', '"Data": "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }
                else
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data":  "715"', '"Data":  "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }

                if (-not $IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -ShowHistory
                }
                elseif ($IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -ShowHistory
                }
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[9].DataHistory | Should -BeExactly '714'
                $diskSmartInfo[0].SmartData[9].Data | Should -BeExactly '715'
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[12].DataHistory | Should -BeExactly '45'
                $diskSmartInfo[0].SmartData[12].Data | Should -BeExactly '45'
            }

            It "DiskSmartInfo object has correct types and properties" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#History'

                $diskSmartInfo[0].psobject.properties['ComputerName'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].ComputerName | Should -BeNullOrEmpty

                $diskSmartInfo[0].psobject.properties['DiskModel'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].DiskModel | Should -BeOfType 'System.String'

                $diskSmartInfo[0].psobject.properties['DiskNumber'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].DiskNumber | Should -BeOfType 'System.UInt32'

                $diskSmartInfo[0].psobject.properties['Device'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].Device | Should -BeOfType 'System.String'

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

                $propertyValues[0] | Should -BeExactly 'Disk:         0: Samsung SSD 970 EVO Plus 500GB'
                $propertyValues[1] | Should -BeExactly 'Device:       /dev/nvme0'
                $propertyValues[2] | Should -BeLikeExactly 'HistoryDate:*'
                $propertyValues[3] | Should -BeLikeExactly 'SMARTData:*'
            }

            It "DiskSmartAttribute object has correct types and properties" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMe#History'

                $diskSmartInfo[0].SmartData[0].psobject.properties | Should -HaveCount 3

                $diskSmartInfo[0].SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Name | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Data | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].Data | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].DataHistory | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[13].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].DataHistory | Should -BeOfType 'System.String'
            }

            It "DiskSmartAttribute object is formatted correctly" {
                $format = $diskSmartInfo[0].SmartData | Format-Table

                $labels = $format.shapeInfo.tableColumnInfoList.Label

                $labels | Should -BeExactly @('AttributeName', 'Data', 'History')
            }
        }

        Context "ShowUnchangedDataHistory = `$false" {

            BeforeAll {

                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }

                InModuleScope DiskSmartInfo {
                    $Config.DataHistoryPath = $TestDrive
                    $Config.ShowUnchangedDataHistory = $false
                }

                if (-not $IsLinux)
                {
                    Get-DiskSmartInfo -Source SmartCtl -UpdateHistory | Out-Null
                }
                elseif ($IsLinux)
                {
                    Get-DiskSmartInfo -UpdateHistory | Out-Null
                }

                if ($IsCoreCLR)
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data": "715"', '"Data": "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }
                else
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data":  "715"', '"Data":  "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }

                if (-not $IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -ShowHistory
                }
                elseif ($IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -ShowHistory
                }
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedDataHistory = $true
                }
            }

            It "Object is of proper type" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#History'
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoryDate | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].HistoryDate | Should -BeOfType 'System.DateTime'
            }

            It "Attribute object is of proper type" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMe#History'
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[9].DataHistory | Should -BeExactly '714'
                $diskSmartInfo[0].SmartData[9].Data | Should -BeExactly '715'
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[10].DataHistory | Should -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[10].Data | Should -BeExactly '600'
                $diskSmartInfo[0].SmartData[12].DataHistory | Should -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[12].Data | Should -BeExactly '45'
            }
        }

        Context "-ShowHistory -Convert" {

            BeforeAll {

                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }

                InModuleScope DiskSmartInfo {
                    $Config.DataHistoryPath = $TestDrive
                    $Config.ShowUnchangedDataHistory = $true
                }

                if (-not $IsLinux)
                {
                    Get-DiskSmartInfo -Source SmartCtl -UpdateHistory | Out-Null
                }
                elseif ($IsLinux)
                {
                    Get-DiskSmartInfo -UpdateHistory | Out-Null
                }

                if ($IsCoreCLR)
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data": "715"', '"Data": "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }
                else
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data":  "715"', '"Data":  "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }

                if (-not $IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -ShowHistory -Convert
                }
                elseif ($IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -ShowHistory -Convert
                }
            }

            It "Object is of proper type" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#History'
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoryDate | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].HistoryDate | Should -BeOfType 'System.DateTime'
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[9].DataHistory | Should -BeExactly '714'
                $diskSmartInfo[0].SmartData[9].Data | Should -BeExactly '715'
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[12].DataHistory | Should -BeExactly '45'
                $diskSmartInfo[0].SmartData[12].Data | Should -BeExactly '45'
            }

            It "DiskSmartAttribute object has correct types and properties" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMe#History'

                $diskSmartInfo[0].SmartData[0].psobject.properties | Should -HaveCount 3

                $diskSmartInfo[0].SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Name | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Data | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].Data | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].DataHistory | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[13].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].DataHistory | Should -BeOfType 'System.String'
            }

            It "DiskSmartAttribute object is formatted correctly" {
                $format = $diskSmartInfo[0].SmartData | Format-Table

                $labels = $format.shapeInfo.tableColumnInfoList.Label

                $labels | Should -BeExactly @('AttributeName', 'Data', 'History')

            }
        }
    }

    Context "-AttributeProperty History" {

        Context "ShowUnchangedDataHistory = `$true" {

            BeforeAll {

                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }

                InModuleScope DiskSmartInfo {
                    $Config.DataHistoryPath = $TestDrive
                    $Config.ShowUnchangedDataHistory = $true
                }

                if (-not $IsLinux)
                {
                    Get-DiskSmartInfo -Source SmartCtl -UpdateHistory | Out-Null
                }
                elseif ($IsLinux)
                {
                    Get-DiskSmartInfo -UpdateHistory | Out-Null
                }

                if ($IsCoreCLR)
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data": "715"', '"Data": "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }
                else
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data":  "715"', '"Data":  "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }

                if (-not $IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeProperty ID, IDHex, AttributeName, Threshold, Value, Worst, Data, History
                }
                elseif ($IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeProperty ID, IDHex, AttributeName, Threshold, Value, Worst, Data, History
                }
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[9].DataHistory | Should -BeExactly '714'
                $diskSmartInfo[0].SmartData[9].Data | Should -BeExactly '715'
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[12].DataHistory | Should -BeExactly '45'
                $diskSmartInfo[0].SmartData[12].Data | Should -BeExactly '45'
            }

            It "DiskSmartInfo object has correct types and properties" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#History'

                $diskSmartInfo[0].psobject.properties['ComputerName'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].ComputerName | Should -BeNullOrEmpty

                $diskSmartInfo[0].psobject.properties['DiskModel'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].DiskModel | Should -BeOfType 'System.String'

                $diskSmartInfo[0].psobject.properties['DiskNumber'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].DiskNumber | Should -BeOfType 'System.UInt32'

                $diskSmartInfo[0].psobject.properties['Device'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].Device | Should -BeOfType 'System.String'

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

                $propertyValues[0] | Should -BeExactly 'Disk:         0: Samsung SSD 970 EVO Plus 500GB'
                $propertyValues[1] | Should -BeExactly 'Device:       /dev/nvme0'
                $propertyValues[2] | Should -BeLikeExactly 'HistoryDate:*'
                $propertyValues[3] | Should -BeLikeExactly 'SMARTData:*'
            }

            It "DiskSmartAttribute object has correct types and properties" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMeCustom'

                $diskSmartInfo[0].SmartData[0].psobject.properties | Should -HaveCount 3

                $diskSmartInfo[0].SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Name | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Data | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].Data | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].DataHistory | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[13].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].DataHistory | Should -BeOfType 'System.String'
            }

            It "DiskSmartAttribute object is formatted correctly" {
                $format = $diskSmartInfo[0].SmartData.FormatTable()

                $propertyNames = $format.shapeInfo.tableColumnInfoList.propertyName

                $propertyNames | Should -BeExactly @('AttributeName', 'Data', 'History')
            }
        }

        Context "ShowUnchangedDataHistory = `$false" {

            BeforeAll {

                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }

                InModuleScope DiskSmartInfo {
                    $Config.DataHistoryPath = $TestDrive
                    $Config.ShowUnchangedDataHistory = $false
                }

                if (-not $IsLinux)
                {
                    Get-DiskSmartInfo -Source SmartCtl -UpdateHistory | Out-Null
                }
                elseif ($IsLinux)
                {
                    Get-DiskSmartInfo -UpdateHistory | Out-Null
                }

                if ($IsCoreCLR)
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data": "715"', '"Data": "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }
                else
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data":  "715"', '"Data":  "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }

                if (-not $IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeProperty ID, IDHex, AttributeName, Threshold, Value, Worst, Data, History
                }
                elseif ($IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeProperty ID, IDHex, AttributeName, Threshold, Value, Worst, Data, History
                }
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedDataHistory = $true
                }
            }

            It "Object is of proper type" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#History'
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoryDate | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].HistoryDate | Should -BeOfType 'System.DateTime'
            }

            It "Attribute object is of proper type" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMeCustom'
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[9].DataHistory | Should -BeExactly '714'
                $diskSmartInfo[0].SmartData[9].Data | Should -BeExactly '715'
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[10].DataHistory | Should -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[10].Data | Should -BeExactly '600'
                $diskSmartInfo[0].SmartData[12].DataHistory | Should -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[12].Data | Should -BeExactly '45'
            }
        }

        Context "-ShowHistory -Convert" {

            BeforeAll {

                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                }

                InModuleScope DiskSmartInfo {
                    $Config.DataHistoryPath = $TestDrive
                    $Config.ShowUnchangedDataHistory = $true
                }

                if (-not $IsLinux)
                {
                    Get-DiskSmartInfo -Source SmartCtl -UpdateHistory | Out-Null
                }
                elseif ($IsLinux)
                {
                    Get-DiskSmartInfo -UpdateHistory | Out-Null
                }

                if ($IsCoreCLR)
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data": "715"', '"Data": "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }
                else
                {
                    (Get-Content -Path 'TestDrive:/localhost.json') -replace '"Data":  "715"', '"Data":  "714"' | Set-Content -Path 'TestDrive:/localhost.json'
                }

                if (-not $IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeProperty ID, IDHex, AttributeName, Threshold, Value, Worst, Data, History, Converted
                }
                elseif ($IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeProperty ID, IDHex, AttributeName, Threshold, Value, Worst, Data, History, Converted
                }
            }

            It "Object is of proper type" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#History'
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoryDate | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].HistoryDate | Should -BeOfType 'System.DateTime'
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[9].DataHistory | Should -BeExactly '714'
                $diskSmartInfo[0].SmartData[9].Data | Should -BeExactly '715'
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[12].DataHistory | Should -BeExactly '45'
                $diskSmartInfo[0].SmartData[12].Data | Should -BeExactly '45'
            }

            It "DiskSmartAttribute object has correct types and properties" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMeCustom'

                $diskSmartInfo[0].SmartData[0].psobject.properties | Should -HaveCount 3

                $diskSmartInfo[0].SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Name | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].Data | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[13].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].Data | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[0].DataHistory | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[13].psobject.properties['DataHistory'] | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[13].DataHistory | Should -BeOfType 'System.String'

                $diskSmartInfo[0].SmartData[0].psobject.properties['DataConverted'] | Should -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[7].psobject.properties['DataConverted'] | Should -BeNullOrEmpty
            }

            It "DiskSmartAttribute object is formatted correctly" {
                $format = $diskSmartInfo[0].SmartData.FormatTable()

                $propertyNames = $format.shapeInfo.tableColumnInfoList.propertyName

                $propertyNames | Should -BeExactly @('AttributeName', 'Data', 'History')
            }
        }
    }
}
