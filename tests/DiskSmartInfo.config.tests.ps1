BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "Config" {

    BeforeAll {
        $testData = Import-PowerShellDataFile -Path $PSScriptRoot\testData.psd1

        # Class names
        $namespaceWMI = 'root/WMI'
        $classSmartData = 'MSStorageDriver_ATAPISmartData'
        $classThresholds = 'MSStorageDriver_FailurePredictThresholds'
        $classDiskDrive = 'Win32_DiskDrive'

        $namespaceStorage = 'root/Microsoft/Windows/Storage'
        $classDisk = 'MSFT_Disk'
        $classPhysicalDisk = 'MSFT_PhysicalDisk'

        # Class objects
        $cimClassSmartData = Get-CimClass -Namespace $namespaceWMI -ClassName $classSmartData
        $cimClassThresholds = Get-CimClass -Namespace $namespaceWMI -ClassName $classThresholds
        $cimClassDiskDrive = Get-CimClass -ClassName $classDiskDrive

        $cimClassDisk = Get-CimClass -Namespace $namespaceStorage -ClassName $classDisk
        $cimClassPhysicalDisk = Get-CimClass -Namespace $namespaceStorage -ClassName $classPhysicalDisk

        # Properties
        # HDD1
        $diskSmartDataPropertiesHDD1 = @{
            VendorSpecific = $testData.AtapiSmartData_VendorSpecific_HDD1
            InstanceName = $testData.InstanceName_HDD1
        }

        $diskThresholdsPropertiesHDD1 = @{
            VendorSpecific = $testData.FailurePredictThresholds_VendorSpecific_HDD1
            InstanceName = $testData.InstanceName_HDD1
        }

        $diskDrivePropertiesHDD1 = @{
            Index = $testData.Index_HDD1
            PNPDeviceID = $testData.PNPDeviceID_HDD1
            Model = $testData.Model_HDD1
            BytesPerSector = $testData.BytesPerSector_HDD1
        }

        $diskDrivePropertiesATAHDD1 = @{
            Index = $testData.Index_HDD1
            PNPDeviceID = $testData.PNPDeviceID_HDD1
            Model = $testData.ModelATA_HDD1
            BytesPerSector = $testData.BytesPerSector_HDD1
        }

        $diskPropertiesHDD1 = @{
            Number = $testData.Index_HDD1
        }

        $physicalDiskPropertiesHDD1 = @{
            DeviceId = $testData.Index_HDD1
        }

        # HDD2
        $diskSmartDataPropertiesHDD2 = @{
            VendorSpecific = $testData.AtapiSmartData_VendorSpecific_HDD2
            InstanceName = $testData.InstanceName_HDD2
        }

        $diskThresholdsPropertiesHDD2 = @{
            VendorSpecific = $testData.FailurePredictThresholds_VendorSpecific_HDD2
            InstanceName = $testData.InstanceName_HDD2
        }

        $diskDrivePropertiesHDD2 = @{
            Index = $testData.Index_HDD2
            PNPDeviceID = $testData.PNPDeviceID_HDD2
            Model = $testData.Model_HDD2
            BytesPerSector = $testData.BytesPerSector_HDD2
        }

        $diskPropertiesHDD2 = @{
            Number = $testData.Index_HDD2
        }

        $physicalDiskPropertiesHDD2 = @{
            DeviceId = $testData.Index_HDD2
        }

        # SSD1
        $diskSmartDataPropertiesSSD1 = @{
            VendorSpecific = $testData.AtapiSmartData_VendorSpecific_SSD1
            InstanceName = $testData.InstanceName_SSD1
        }

        $diskThresholdsPropertiesSSD1 = @{
            VendorSpecific = $testData.FailurePredictThresholds_VendorSpecific_SSD1
            InstanceName = $testData.InstanceName_SSD1
        }

        $diskDrivePropertiesSSD1 = @{
            Index = $testData.Index_SSD1
            PNPDeviceID = $testData.PNPDeviceID_SSD1
            Model = $testData.Model_SSD1
            BytesPerSector = $testData.BytesPerSector_SSD1
        }

        $diskPropertiesSSD1 = @{
            Number = $testData.Index_SSD1
        }

        $physicalDiskPropertiesSSD1 = @{
            DeviceId = $testData.Index_SSD1
        }

        # HFSSSD1
        $diskSmartDataPropertiesHFSSSD1 = @{
            VendorSpecific = $testData.AtapiSmartData_VendorSpecific_HFSSSD1
            InstanceName = $testData.InstanceName_HFSSSD1
        }

        $diskThresholdsPropertiesHFSSSD1 = @{
            VendorSpecific = $testData.FailurePredictThresholds_VendorSpecific_HFSSSD1
            InstanceName = $testData.InstanceName_HFSSSD1
        }

        $diskDrivePropertiesHFSSSD1 = @{
            Index = $testData.Index_HFSSSD1
            PNPDeviceID = $testData.PNPDeviceID_HFSSSD1
            Model = $testData.Model_HFSSSD1
            BytesPerSector = $testData.BytesPerSector_HFSSSD1
        }

        $diskPropertiesHFSSSD1 = @{
            Number = $testData.Index_HFSSSD1
        }

        $physicalDiskPropertiesHFSSSDD1 = @{
            DeviceId = $testData.Index_HFSSSD1
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
        $diskDriveATAHDD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesATAHDD1 -ClientOnly
        $diskDriveHDD2 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHDD2 -ClientOnly
        $diskDriveSSD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesSSD1 -ClientOnly
        $diskDriveHFSSSD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHFSSSD1 -ClientOnly

        $diskHDD1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHDD1 -ClientOnly
        $diskHDD2 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHDD2 -ClientOnly
        $diskSSD1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesSSD1 -ClientOnly
        $diskHFSSSD1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHFSSSD1 -ClientOnly

        $physicalDiskHDD1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHDD1 -ClientOnly
        $physicalDiskHDD2 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHDD2 -ClientOnly
        $physicalDiskSSD1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesSSD1 -ClientOnly
        $physicalDiskHFSSSD1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHFSSSD1 -ClientOnly

        # Remoting
        $computerNames = $env:computername, 'localhost'
        $ipAddresses = '127.0.0.1', '127.0.0.2'

        $diskDrivePropertiesHost1 = @{
            Index = 1
        }
        $diskDrivePropertiesHost2 = @{
            Index = 2
        }

        $diskDriveHost1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHost1 -ClientOnly
        $diskDriveHost1 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[0] -Force

        $diskDriveHost2 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHost2 -ClientOnly
        $diskDriveHost2 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[1] -Force

        $diskPropertiesHost1 = @{
            Number = 1
        }
        $diskPropertiesHost2 = @{
            Number = 2
        }
        $diskHost1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHost1 -ClientOnly
        $diskHost1 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[0] -Force

        $diskHost2 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHost2 -ClientOnly
        $diskHost2 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[1] -Force

        $PhysicalDiskPropertiesHost1 = @{
            DeviceId = 1
        }
        $PhysicalDiskPropertiesHost2 = @{
            DeviceId = 2
        }
        $physicalDiskHost1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHost1 -ClientOnly
        $physicalDiskHost1 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[0] -Force

        $physicalDiskHost2 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHost2 -ClientOnly
        $physicalDiskHost2 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[1] -Force
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

            Context "AttributeID parameter results depend on SuppressEmptySmartData" {
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

            Context "Quiet parameter results not depend on SuppressEmptySmartData" {
                BeforeAll {
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
        }

        Context "SuppressEmptySmartData = `$false" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.SuppressEmptySmartData = $false
                }
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $Config.SuppressEmptySmartData = $true
                }
            }

            Context "AttributeID parameter results depend on SuppressEmptySmartData" {
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

            Context "Quiet parameter results not depend on SuppressEmptySmartData" {
                BeforeAll {
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
        }
    }

    Context "Trim Win32_DiskDrive Model property" {

        Context "TrimDiskDriveModel = `$true" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveATAHDD1, $diskDriveHDD2 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.TrimDiskDriveModel = $true
                }
            }

            Context "DiskSmartInfo Model property depends on TrimDiskDriveModel" {
                BeforeAll {
                    $diskSmartInfo = Get-DiskSmartInfo
                }

                It "Has 2 DiskSmartInfo object" {
                    $diskSmartInfo | Should -HaveCount 2
                    $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
                }

                It "Has trimmed models" {
                    $diskSmartInfo[0].Model | Should -BeExactly $testData.Model_HDD1
                    $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD2
                }
            }
        }

        Context "TrimDiskDriveModel = `$false" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveATAHDD1, $diskDriveHDD2 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.TrimDiskDriveModel = $false
                }
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $Config.TrimDiskDriveModel = $true
                }
            }

            Context "DiskSmartInfo Model property depends on TrimDiskDriveModel" {
                BeforeAll {
                    $diskSmartInfo = Get-DiskSmartInfo
                }

                It "Has 2 DiskSmartInfo object" {
                    $diskSmartInfo | Should -HaveCount 2
                    $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
                }

                It "Has untrimmed models" {
                    $diskSmartInfo[0].Model | Should -BeExactly $testData.ModelATA_HDD1
                    $diskSmartInfo[1].Model | Should -BeExactly $testData.Model_HDD2
                }
            }
        }
    }
}
