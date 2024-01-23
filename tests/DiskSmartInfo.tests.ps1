BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "DiskSmartInfo" {

    BeforeAll {
        $testsData = Import-PowerShellDataFile -Path $PSScriptRoot\testsData.psd1

        # Class names
        $namespaceWMI = 'root/WMI'
        $classSmartData = 'MSStorageDriver_ATAPISmartData'
        $classThresholds = 'MSStorageDriver_FailurePredictThresholds'
        $classDiskDrive = 'Win32_DiskDrive'

        # Class objects
        $cimClassSmartData = Get-CimClass -Namespace $namespaceWMI -ClassName $classSmartData
        $cimClassThresholds = Get-CimClass -Namespace $namespaceWMI -ClassName $classThresholds
        $cimClassDiskDrive = Get-CimClass -ClassName $classDiskDrive

        # Properties
        # HDD1
        $diskSmartDataPropertiesHDD1 = @{
            VendorSpecific = $testsData.AtapiSmartData_VendorSpecific_HDD1
            InstanceName = $testsData.InstanceName_HDD1
        }

        $diskThresholdsPropertiesHDD1 = @{
            VendorSpecific = $testsData.FailurePredictThresholds_VendorSpecific_HDD1
            InstanceName = $testsData.InstanceName_HDD1
        }

        $diskDrivePropertiesHDD1 = @{
            Index = $testsData.Index_HDD1
            PNPDeviceID = $testsData.PNPDeviceID_HDD1
            Model = $testsData.Model_HDD1
            BytesPerSector = $testsData.BytesPerSector_HDD1
        }

        # HDD2
        $diskSmartDataPropertiesHDD2 = @{
            VendorSpecific = $testsData.AtapiSmartData_VendorSpecific_HDD2
            InstanceName = $testsData.InstanceName_HDD2
        }

        $diskThresholdsPropertiesHDD2 = @{
            VendorSpecific = $testsData.FailurePredictThresholds_VendorSpecific_HDD2
            InstanceName = $testsData.InstanceName_HDD2
        }

        $diskDrivePropertiesHDD2 = @{
            Index = $testsData.Index_HDD2
            PNPDeviceID = $testsData.PNPDeviceID_HDD2
            Model = $testsData.Model_HDD2
            BytesPerSector = $testsData.BytesPerSector_HDD2
        }

        # SSD1
        $diskSmartDataPropertiesSSD1 = @{
            VendorSpecific = $testsData.AtapiSmartData_VendorSpecific_SSD1
            InstanceName = $testsData.InstanceName_SSD1
        }

        $diskThresholdsPropertiesSSD1 = @{
            VendorSpecific = $testsData.FailurePredictThresholds_VendorSpecific_SSD1
            InstanceName = $testsData.InstanceName_SSD1
        }

        $diskDrivePropertiesSSD1 = @{
            Index = $testsData.Index_SSD1
            PNPDeviceID = $testsData.PNPDeviceID_SSD1
            Model = $testsData.Model_SSD1
            BytesPerSector = $testsData.BytesPerSector_SSD1
        }

        # HFSSSD1
        $diskSmartDataPropertiesHFSSSD1 = @{
            VendorSpecific = $testsData.AtapiSmartData_VendorSpecific_HFSSSD1
            InstanceName = $testsData.InstanceName_HFSSSD1
        }

        $diskThresholdsPropertiesHFSSSD1 = @{
            VendorSpecific = $testsData.FailurePredictThresholds_VendorSpecific_HFSSSD1
            InstanceName = $testsData.InstanceName_HFSSSD1
        }

        $diskDrivePropertiesHFSSSD1 = @{
            Index = $testsData.Index_HFSSSD1
            PNPDeviceID = $testsData.PNPDeviceID_HFSSSD1
            Model = $testsData.Model_HFSSSD1
            BytesPerSector = $testsData.BytesPerSector_HFSSSD1
        }

        # CIM object
        $diskSmartDataHDD1 = New-CimInstance -CimClass $cimClassSmartData -Property $diskSmartDataPropertiesHDD1 -ClientOnly
        $diskSmartDataHDD2 = New-CimInstance -CimClass $cimClassSmartData -Property $diskSmartDataPropertiesHDD2 -ClientOnly
        $diskSmartDataSSD1 = New-CimInstance -CimClass $cimClassSmartData -Property $diskSmartDataPropertiesSSD1 -ClientOnly
        $diskSmartDataHFSSSD1 = New-CimInstance -CimClass $cimClassSmartData -Property $diskSmartDataPropertiesHFSSSD1 -ClientOnly

        $diskThresholdsHDD1 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesHDD1 -ClientOnly
        $diskThresholdsHDD2 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesHDD2 -ClientOnly
        $diskThresholdsSSD1 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesSSD1 -ClientOnly
        $diskThresholdsHFSSSD1 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesHFSSSD1 -ClientOnly

        $diskDriveHDD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHDD1 -ClientOnly
        $diskDriveHDD2 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHDD2 -ClientOnly
        $diskDriveSSD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesSSD1 -ClientOnly
        $diskDriveHFSSSD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHFSSSD1 -ClientOnly
    }

    Context "Get-DiskSmartInfo" {

        Context "Without parameters" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
                $diskSmartInfo = Get-DiskSmartInfo
            }

            It "Returns DiskSmartInfo object" {
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
            }

            It "Has Model and InstanceId properties" {
                $diskSmartInfo.Model | Should -BeExactly $testsData.Model_HDD1
                $diskSmartInfo.InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD1
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
                $diskSmartInfo.SmartData[13].Data | Should -Be @(47, 14, 39)
            }
        }

        Context "-ShowConvertedData" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
                $diskSmartInfo = Get-DiskSmartInfo -ShowConvertedData
            }

            It "Converts Spin-Up Time" {
                $diskSmartInfo[0].SmartData[2].ConvertedData | Should -BeExactly '9.059 Sec'
            }

            It "Converts Power-On Hours" {
                $diskSmartInfo[0].SmartData[7].ConvertedData | Should -BeExactly '3060.25 Days'
            }

            It "Converts Temperature Difference" {
                $diskSmartInfo[1].SmartData[9].ConvertedData | Should -BeExactly '60 °C'
            }

            It "Converts Total LBAs Written" {
                $diskSmartInfo[1].SmartData[13].ConvertedData | Should -BeExactly '5.933 TB'
            }

            It "Converts Total LBAs Read" {
                $diskSmartInfo[1].SmartData[14].ConvertedData | Should -BeExactly '4.450 TB'
            }
        }

        Context "-CriticalAttributesOnly" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
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

        Context "-QuietIfOK" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
                $diskSmartInfo = Get-DiskSmartInfo -QuietIfOK
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

        Context "-CriticalAttributesOnly -QuietIfOK" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
                $diskSmartInfo = Get-DiskSmartInfo -CriticalAttributesOnly -QuietIfOK
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
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
                $diskSmartInfo = Get-DiskSmartInfo
            }

            It "Has 2 DiskSmartInfo objects" {
                $diskSmartInfo | Should -HaveCount 2
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
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
            }
        }

        Context "Converted data for overwritten attributes" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
                $diskSmartInfo = Get-DiskSmartInfo -ShowConvertedData
            }

            It "Has default attribute definitions" {
                $diskSmartInfo[0].SmartData | Should -HaveCount 15
                $diskSmartInfo[0].SmartData[13].ID | Should -Be 241
                $diskSmartInfo[0].SmartData[13].AttributeName | Should -BeExactly "Total LBAs Written"
                $diskSmartInfo[0].SmartData[13].Data | Should -Be 12740846422
                $diskSmartInfo[0].SmartData[13].ConvertedData | Should -BeExactly "5.933 TB"
                $diskSmartInfo[0].SmartData[14].ID | Should -Be 242
                $diskSmartInfo[0].SmartData[14].AttributeName | Should -BeExactly "Total LBAs Read"
                $diskSmartInfo[0].SmartData[14].Data | Should -Be 9556432520
                $diskSmartInfo[0].SmartData[14].ConvertedData | Should -BeExactly "4.450 TB"
            }

            It "Has overwritten attrubute definitions" {
                $diskSmartInfo[1].SmartData | Should -HaveCount 30
                $diskSmartInfo[1].SmartData[27].ID | Should -Be 241
                $diskSmartInfo[1].SmartData[27].AttributeName | Should -BeExactly "Total Writes GB"
                $diskSmartInfo[1].SmartData[27].Data | Should -Be 2034
                $diskSmartInfo[1].SmartData[27].ConvertedData | Should -BeExactly "1.986 TB"
                $diskSmartInfo[1].SmartData[28].ID | Should -Be 242
                $diskSmartInfo[1].SmartData[28].AttributeName | Should -BeExactly "Total Reads GB"
                $diskSmartInfo[1].SmartData[28].Data | Should -Be 2596
                $diskSmartInfo[1].SmartData[28].ConvertedData | Should -BeExactly "2.535 TB"
            }
        }

        Context "IsCritical property for overwritten attributes" {
            Context "Default attributes" {
                BeforeAll {
                    mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
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
                    mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                    InModuleScope DiskSmartInfo {
                        $overwrites.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Add("IsCritical", $false)
                    }

                    $diskSmartInfo = Get-DiskSmartInfo -CriticalAttributesOnly
                }
                AfterAll {
                    InModuleScope DiskSmartInfo {
                        $overwrites.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Remove("IsCritical")
                    }
                }
                It "Update IsCritical property value during attribute overwriting" {
                    $diskSmartInfo[1].SmartData | Should -HaveCount 5
                    $diskSmartInfo[1].SmartData[0].ID | Should -Be 184
                    $diskSmartInfo[1].SmartData[0].AttributeName | Should -BeExactly "End-to-End Error"
                }
            }

            Context "Overwrite attributes IsCritical = `$true" {
                BeforeAll {
                    mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                    InModuleScope DiskSmartInfo {
                        $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeID -eq 5}).IsCritical = $false
                        $overwrites.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Add("IsCritical", $true)
                    }

                    $diskSmartInfo = Get-DiskSmartInfo -CriticalAttributesOnly
                }
                AfterAll {
                    InModuleScope DiskSmartInfo {
                        $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeID -eq 5}).IsCritical = $true
                        $overwrites.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Remove("IsCritical")
                    }
                }
                It "Update IsCritical property value during attribute overwriting" {
                    $diskSmartInfo[1].SmartData | Should -HaveCount 6
                    $diskSmartInfo[1].SmartData[0].ID | Should -Be 5
                    $diskSmartInfo[1].SmartData[0].AttributeName | Should -BeExactly "Retired Block Count"
                }
            }
        }

        Context "Select attributes" {

            Context "AttributeID" {
                BeforeAll {
                    mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
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
                    mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                    $diskSmartInfo = Get-DiskSmartInfo -AttributeName 'Throughput Performance', 'Power-off Retract Count', 'Non existing attribute name'
                }

                It "Has requested attributes" {
                    $diskSmartInfo.SmartData | Should -HaveCount 2
                    $diskSmartInfo.SmartData[0].ID | Should -Be 2
                    $diskSmartInfo.SmartData[1].ID | Should -Be 192
                }
            }

            Context "Attribute parameters" {
                BeforeAll {
                    mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
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
                    mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                    $diskSmartInfo = Get-DiskSmartInfo -DiskNumber 0, 2
                }
                It "Has data for selected disks" {
                    $diskSmartInfo | Should -HaveCount 2
                    $diskSmartInfo[0].InstanceId | Should -BeExactly 'IDE\HDD1_________________________12345678\1&12345000&0&1.0.0'
                    $diskSmartInfo[1].InstanceId | Should -BeExactly 'IDE\SSD1_________________________12345678\1&12345000&0&1.0.0'
                }
            }
        }
    }
}
