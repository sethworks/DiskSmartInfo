BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "Config" {

    Context "Suppress empty SmartData" {

        Context "SuppressResultsWithEmptySmartData = `$true" {

            BeforeAll {

                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
                }

                InModuleScope DiskSmartInfo {
                    $Config.SuppressResultsWithEmptySmartData = $true
                }
            }

            Context "AttributeID parameter results depend on SuppressResultsWithEmptySmartData" {

                BeforeAll {
                    if (-not $IsLinux)
                    {
                        $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeID 4, 6, 8
                    }
                    elseif ($IsLinux)
                    {
                        $diskSmartInfo = Get-DiskSmartInfo -AttributeID 4, 6, 8
                    }
                }

                It "Has 2 DiskSmartInfo object" {
                    $diskSmartInfo | Should -HaveCount 2
                    $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
                }

                It "Has SmartData property with DiskSmartAttribute objects" {
                    $diskSmartInfo[0].SmartData | Should -HaveCount 2
                    $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
                    $diskSmartInfo[1].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
                }

                It "Has requested attributes only" {
                    $diskSmartInfo[0].SmartData[0].ID | Should -Be 4
                    $diskSmartInfo[0].SmartData[0].Data | Should -Be 25733
                    $diskSmartInfo[0].SmartData[1].ID | Should -Be 8
                    $diskSmartInfo[0].SmartData[1].Data | Should -Be 0

                    $diskSmartInfo[1].SmartData | Should -HaveCount 1
                    $diskSmartInfo[1].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
                    $diskSmartInfo[1].SmartData[0].ID | Should -Be 4
                    $diskSmartInfo[1].SmartData[0].Data | Should -Be 73592
                }
            }

            Context "Quiet parameter results do not depend on SuppressResultsWithEmptySmartData" {

                BeforeAll {
                    if (-not $IsLinux)
                    {
                        $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Quiet
                    }
                    elseif ($IsLinux)
                    {
                        $diskSmartInfo = Get-DiskSmartInfo -Quiet
                    }
                }

                It "Has 1 DiskSmartInfo object" {
                    $diskSmartInfo | Should -HaveCount 1
                    $diskSmartInfo.DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD2
                    $diskSmartInfo.Device | Should -BeExactly $testDataCtl.CtlDevice_HDD2
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
        }

        Context "SuppressResultsWithEmptySmartData = `$false" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
                }

                InModuleScope DiskSmartInfo {
                    $Config.SuppressResultsWithEmptySmartData = $false
                }
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $Config.SuppressResultsWithEmptySmartData = $true
                }
            }

            Context "AttributeID parameter results depend on SuppressResultsWithEmptySmartData" {

                BeforeAll {
                    if (-not $IsLinux)
                    {
                        $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeID 4, 6, 8
                    }
                    elseif ($IsLinux)
                    {
                        $diskSmartInfo = Get-DiskSmartInfo -AttributeID 4, 6, 8
                    }
                }

                It "Has 3 DiskSmartInfo object" {
                    $diskSmartInfo | Should -HaveCount 3
                    $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
                }

                It "Has SmartData property with DiskSmartAttribute objects" {
                    $diskSmartInfo[0].SmartData | Should -HaveCount 2
                    $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
                    $diskSmartInfo[1].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
                }

                It "Has requested attributes only" {
                    $diskSmartInfo[0].SmartData[0].ID | Should -Be 4
                    $diskSmartInfo[0].SmartData[0].Data | Should -Be 25733
                    $diskSmartInfo[0].SmartData[1].ID | Should -Be 8
                    $diskSmartInfo[0].SmartData[1].Data | Should -Be 0

                    $diskSmartInfo[1].SmartData | Should -HaveCount 1
                    $diskSmartInfo[1].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
                    $diskSmartInfo[1].SmartData[0].ID | Should -Be 4
                    $diskSmartInfo[1].SmartData[0].Data | Should -Be 73592
                }

                It "DiskSmartInfo object has correct types and properties" {
                    $diskSmartInfo[2].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'

                    $diskSmartInfo[2].psobject.properties['ComputerName'] | Should -Not -BeNullOrEmpty
                    $diskSmartInfo[2].ComputerName | Should -BeNullOrEmpty

                    $diskSmartInfo[2].psobject.properties['DiskModel'] | Should -Not -BeNullOrEmpty
                    $diskSmartInfo[2].DiskModel | Should -BeOfType 'System.String'

                    $diskSmartInfo[2].psobject.properties['DiskNumber'] | Should -Not -BeNullOrEmpty
                    $diskSmartInfo[2].DiskNumber | Should -BeOfType 'System.UInt32'

                    $diskSmartInfo[2].psobject.properties['Device'] | Should -Not -BeNullOrEmpty
                    $diskSmartInfo[2].Device | Should -BeOfType 'System.String'

                    $diskSmartInfo[2].psobject.properties['PredictFailure'] | Should -Not -BeNullOrEmpty
                    $diskSmartInfo[2].PredictFailure | Should -BeOfType 'System.Boolean'

                    $diskSmartInfo[2].psobject.properties['SmartData'] | Should -Not -BeNullOrEmpty
                    $diskSmartInfo[2].SmartData | Should -BeNullOrEmpty
                }

                It "DiskSmartInfo object is formatted correctly" {
                    $format = $diskSmartInfo[2] | Format-Custom

                    $propertyValues = $format.formatEntryInfo.formatValueList.formatValueList.formatValuelist.propertyValue -replace '\e\[[0-9]+(;[0-9]+)*m', ''

                    $propertyValues | Should -HaveCount 2

                    $propertyValues[0] | Should -BeExactly 'Disk:         2: SSD1'
                    $propertyValues[1] | Should -BeExactly 'Device:       /dev/sdc'
                }
            }

            Context "Quiet parameter results not depend on SuppressResultsWithEmptySmartData" {

                BeforeAll {
                    if (-not $IsLinux)
                    {
                        $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Quiet
                    }
                    elseif ($IsLinux)
                    {
                        $diskSmartInfo = Get-DiskSmartInfo -Quiet
                    }
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
        }
    }
}
