BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "Get-DiskSmartInfo NVMe" {

    Context "Without parameters" {

        BeforeAll {
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

            if (-not $IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
    
                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl
            }
            elseif ($IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
    
                $diskSmartInfo = Get-DiskSmartInfo
            }
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

        It "Has SmartData property with 19 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 19
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMe'
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
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMe'

            $diskSmartInfo.SmartData[0].psobject.properties | Should -HaveCount 2

            $diskSmartInfo.SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Name | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Data | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[12].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[12].Data | Should -BeOfType 'System.String'
        }

        It "DiskSmartAttribute object is formatted correctly" {
            $format = $diskSmartInfo.SmartData | Format-Table

            $labels = $format.shapeInfo.tableColumnInfoList.Label

            $labels | Should -BeExactly @('AttributeName', 'Data')
        }
    }

    Context "-Convert" {

        BeforeAll {
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

            if (-not $IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                
                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Convert
            }
            elseif ($IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                
                $diskSmartInfo = Get-DiskSmartInfo -Convert
            }
        }

        It "DiskSmartAttribute object has correct types and properties" {
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMe'

            $diskSmartInfo.SmartData[0].psobject.properties | Should -HaveCount 2

            $diskSmartInfo.SmartData[0].psobject.properties['Name'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Name | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[0].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[0].Data | Should -BeOfType 'System.String'

            $diskSmartInfo.SmartData[12].psobject.properties['Data'] | Should -Not -BeNullOrEmpty
            $diskSmartInfo.SmartData[12].Data | Should -BeOfType 'System.String'

            $diskSmartInfo[0].SmartData[12].psobject.properties['DataConverted'] | Should -BeNullOrEmpty
        }

        It "DiskSmartAttribute object is formatted correctly" {
            $format = $diskSmartInfo.SmartData | Format-Table

            $labels = $format.shapeInfo.tableColumnInfoList.Label

            $labels | Should -BeExactly @('AttributeName', 'Data')
        }
    }

    Context "-Critical" {

        BeforeAll {
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

            if (-not $IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
    
                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Critical
            }
            elseif ($IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
    
                $diskSmartInfo = Get-DiskSmartInfo -Critical
            }
        }

        It "Has SmartData property with 5 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 1
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMe'
        }

        It "Has critical attributes only" {
            $diskSmartInfo.SmartData[0].Name | Should -BeExactly 'Critical Warning'
        }
    }

    Context "-Quiet" {

        BeforeAll {
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

            if (-not $IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
                
                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Quiet
            }
            elseif ($IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
                
                $diskSmartInfo = Get-DiskSmartInfo -Quiet
            }
        }

        It "Has 1 DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 1
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has SmartData property with 3 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 1
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMe'
        }

        It "Consists of attributes in Warning or Critical state only" {
            $diskSmartInfo.SmartData.Name | Should -BeExactly 'Critical Warning'
            $diskSmartInfo.SmartData.Data | Should -BeExactly '0x01'
        }
    }

    Context "-Critical -Quiet" {

        BeforeAll {
            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

            if (-not $IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
                
                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Critical -Quiet
            }
            elseif ($IsLinux)
            {
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
                
                $diskSmartInfo = Get-DiskSmartInfo -Critical -Quiet
            }
        }

        It "Has 1 DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 1
            $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
        }

        It "Has SmartData property with 1 DiskSmartAttribute objects" {
            $diskSmartInfo.SmartData | Should -HaveCount 1
            $diskSmartInfo.SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttributeNVMe'
        }

        It "Has only critical attributes that are in Warning or Critical state" {
            $diskSmartInfo.SmartData.Name | Should -BeExactly 'Critical Warning'
            $diskSmartInfo.SmartData.Data | Should -BeExactly '0x01'
        }
    }

    Context "Select attributes" {

        Context "AttributeID does not have an impact on NVMe data" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeID (1..10)
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeID (1..10)
                }
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 19
                $diskSmartInfo.SmartData[0].Name | Should -BeExactly 'Critical Warning'
                $diskSmartInfo.SmartData[9].Name | Should -BeExactly 'Controller Busy Time'
            }
        }

        Context "AttributeIDHex does not have an impact on NVMe data" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeIDHex df, e1, e3
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeIDHex df, e1, e3
                }
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 19
                $diskSmartInfo.SmartData[0].Name | Should -BeExactly 'Critical Warning'
                $diskSmartInfo.SmartData[9].Name | Should -BeExactly 'Controller Busy Time'
            }
        }

        Context "AttributeName" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeName 'Available Spare', 'Power-off Retract Count', 'Controller Busy Time'
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeName 'Available Spare', 'Power-off Retract Count', 'Controller Busy Time'
                }
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 2
                $diskSmartInfo.SmartData[0].Data | Should -BeExactly '100%'
                $diskSmartInfo.SmartData[1].Data | Should -Be 715
            }
        }

        Context "AttributeName wildcards" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                }
            }

            It "Has requested attribute" {
                if (-not $IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeName '*Read*'
                }
                elseif ($IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeName '*Read*'
                }

                $diskSmartInfo.SmartData | Should -HaveCount 2
                $diskSmartInfo.SmartData[0].Name | Should -BeExactly 'Data Units Read'
                $diskSmartInfo.SmartData[1].Name | Should -BeExactly 'Host Read Commands'
            }

            It "Has 2 requested attributes" {
                if (-not $IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeName 'p*'
                }
                elseif ($IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeName 'p*'
                }

                $diskSmartInfo.SmartData | Should -HaveCount 3
                $diskSmartInfo.SmartData[0].Name | Should -BeExactly 'Percentage Used'
                $diskSmartInfo.SmartData[1].Name | Should -BeExactly 'Power Cycles'
                $diskSmartInfo.SmartData[2].Name | Should -BeExactly 'Power On Hours'
            }

            It "Has 5 requested attributes" {
                if (-not $IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeName 'p*','t*'
                }
                elseif ($IsLinux)
                {
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeName 'p*','t*'
                }

                $diskSmartInfo.SmartData | Should -HaveCount 6
                $diskSmartInfo.SmartData[0].Name | Should -BeExactly 'Temperature'
                $diskSmartInfo.SmartData[4].Name | Should -BeExactly 'Temperature Sensor 1'
                $diskSmartInfo.SmartData[5].Name | Should -BeExactly 'Temperature Sensor 2'
            }
        }

        Context "Nonexistent attributes" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeName '*SomeNonexistentAttribute*'
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeName '*SomeNonexistentAttribute*'
                }
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
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeID 1 -AttributeIDHex A -AttributeName 'Available Spare', 'Controller Busy Time'
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeID 1 -AttributeIDHex A -AttributeName 'Available Spare', 'Controller Busy Time'
                }
            }

            It "Has requested attributes" {
                $diskSmartInfo.SmartData | Should -HaveCount 2
                $diskSmartInfo.SmartData[0].Data | Should -BeExactly '100%'
                $diskSmartInfo.SmartData[1].Data | Should -BeExactly '715'
            }
        }
    }

    Context "Select disks" {

        Context "DiskNumber" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -DiskNumber 0, 2
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -DiskNumber 0, 2
                }
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD1
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD1
            }
        }

        Context "Pipeline Win32_DiskDrive" -Skip:$IsLinux {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

                $diskSmartInfo = $diskDriveNVMe1, $diskDriveSSD1 | Get-DiskSmartInfo -Source SmartCtl
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD1
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD1
            }
        }

        Context "Pipeline MSFT_Disk" -Skip:$IsLinux {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

                $diskSmartInfo = $diskNVMe1, $diskSSD1 | Get-DiskSmartInfo -Source SmartCtl
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD1
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD1
            }
        }

        Context "Pipeline MSFT_PhysicalDisk" -Skip:$IsLinux {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

                $diskSmartInfo = $physicalDiskNVMe1, $physicalDiskSSD1 | Get-DiskSmartInfo -Source SmartCtl
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD1
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD1
            }
        }

        Context "DiskModel" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -DiskModel "HDD*", "Samsung SSD 970*"
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -DiskModel "HDD*", "Samsung SSD 970*"
                }
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD2
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD2
            }
        }

        Context "DiskNumber and DiskModel" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -DiskNumber 0 -DiskModel "SSD1"
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -DiskNumber 0 -DiskModel "SSD1"
                }
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_SSD1
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_SSD1
            }
        }

        Context "Device" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Device "/dev/sdb", "*nvm*"
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Device "/dev/sdb", "*nvm*"
                }
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 2

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1

                $diskSmartInfo[1].DiskNumber | Should -Be $testDataCtl.CtlIndex_HDD2
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_HDD2
            }
        }

        Context "DiskNumber, DiskModel, and Device" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1, $testDataCtl.CtlScan_SSD2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdd" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -DiskNumber 0 -DiskModel "SSD1" -Device "*sdd"
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdd" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -DiskNumber 0 -DiskModel "SSD1" -Device "*sdd"
                }
            }

            It "Has data for selected disks" {
                $diskSmartInfo | Should -HaveCount 3

                $diskSmartInfo[0].DiskNumber | Should -Be $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1

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
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    
                    $diskSmartInfo = Get-DiskSmartInfo
                }
            }

            It "Returns DiskSmartInfo object" {
                $diskSmartInfo | Should -HaveCount 1
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            }

            It "Has DiskSmartInfo object properties" {
                $diskSmartInfo.DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo.DiskModel | Should -BeExactly $testDataCtl.CtlModel_NVMe1
                $diskSmartInfo.Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1
                $diskSmartInfo.PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailureTrue_NVMe1
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

                $propertyValues[0] | Should -BeExactly 'Disk:         0: Samsung SSD 970 EVO Plus 500GB'
                $propertyValues[1] | Should -BeExactly 'Device:       /dev/nvme0'
                $propertyValues[2] | Should -BeExactly "Failure:      True`n"
                $propertyValues[3] | Should -BeLikeExactly 'SMARTData:*'
            }
        }

        Context "Empty SmartData property" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -AttributeName 'Nonexistent Attribute'
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeName 'Nonexistent Attribute'
                }
            }

            It "Returns DiskSmartInfo object" {
                $diskSmartInfo | Should -HaveCount 1
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            }

            It "Has DiskSmartInfo object properties" {
                $diskSmartInfo.DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo.DiskModel | Should -BeExactly $testDataCtl.CtlModel_NVMe1
                $diskSmartInfo.Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1
                $diskSmartInfo.PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailureTrue_NVMe1
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

                $propertyValues[0] | Should -BeExactly 'Disk:         0: Samsung SSD 970 EVO Plus 500GB'
                $propertyValues[1] | Should -BeExactly 'Device:       /dev/nvme0'
                $propertyValues[2] | Should -BeExactly "Failure:      True`n"
            }
        }

        Context "-Quiet" {

            BeforeAll {
                mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Quiet
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Quiet
                }
            }

            It "Returns DiskSmartInfo objects" {
                $diskSmartInfo | Should -HaveCount 2
            }

            It "Has DiskSmartInfo object properties" {
                $diskSmartInfo[0].DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo[0].DiskModel | Should -BeExactly $testDataCtl.CtlModel_NVMe1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1
                $diskSmartInfo[0].PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailureTrue_NVMe1

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
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo

                if (-not $IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -Critical -Quiet
                }
                elseif ($IsLinux)
                {
                    mock Invoke-Command -MockWith { $ctlDataPredictFailureTrueNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo
    
                    $diskSmartInfo = Get-DiskSmartInfo -Critical -Quiet
                }
            }

            It "Returns DiskSmartInfo objects" {
                $diskSmartInfo | Should -HaveCount 2
            }

            It "Has DiskSmartInfo object properties" {
                $diskSmartInfo[0].DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_NVMe1
                $diskSmartInfo[0].DiskModel | Should -BeExactly $testDataCtl.CtlModel_NVMe1
                $diskSmartInfo[0].Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe1
                $diskSmartInfo[0].PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailureTrue_NVMe1

                $diskSmartInfo[1].DiskNumber | Should -BeExactly $testDataCtl.CtlIndex_NVMe2
                $diskSmartInfo[1].DiskModel | Should -BeExactly $testDataCtl.CtlModel_NVMe2
                $diskSmartInfo[1].Device | Should -BeExactly $testDataCtl.CtlDevice_NVMe2
                $diskSmartInfo[1].PredictFailure | Should -BeExactly $testDataCtl.CtlPredictFailure_NVMe2
            }

            It "Has empty SmartData property" {
                $diskSmartInfo[0].SmartData | Should -BeNullOrEmpty
                $diskSmartInfo[1].SmartData | Should -HaveCount 1
            }
        }
    }
}
