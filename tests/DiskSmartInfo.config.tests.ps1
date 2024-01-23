BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "Config" {

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

    Context "Suppress empty SmartData" {

        Context "SuppressEmptySmartData = `$true" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.SuppressEmptySmartData = $true
                }
            }

            Context "AttributeID depends on SuppressEmptySmartData" {
                BeforeAll {
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeID 4, 6, 8
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

            Context "QuietIfOK not depends on SuppressEmptySmartData" {
                BeforeAll {
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
        }

        Context "SuppressEmptySmartData = `$false" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.SuppressEmptySmartData = $false
                }

                $diskSmartInfo = Get-DiskSmartInfo -AttributeID 4, 6, 8
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $Config.SuppressEmptySmartData = $true
                }
            }

            Context "AttributeID depends on SuppressEmptySmartData" {
                BeforeAll {
                    $diskSmartInfo = Get-DiskSmartInfo -AttributeID 4, 6, 8
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

                It "Has empty SmartData property" {
                    $diskSmartInfo[2].SmartData | Should -BeNullOrEmpty
                }
            }

            Context "QuietIfOK not depends on SuppressEmptySmartData" {
                BeforeAll {
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
        }
    }
}
