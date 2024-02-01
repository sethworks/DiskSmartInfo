BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "DiskSmartInfo" {

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

    Context "History" {

        Context "-UpdateHistory" {

            Context "localhost" {
                BeforeAll {
                    mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                    InModuleScope DiskSmartInfo {
                        $Config.HistoricalDataPath = $TestDrive
                    }
                    Get-DiskSmartInfo -UpdateHistory | Out-Null
                }
                It "Historical data file exists" {
                    'TestDrive:\localhost.txt' | Should -Exist
                }
                It "Historical data file contains proper data" {
                    'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD1_________________________12345678\\1&12345000&0&1.0.0"'))
                    'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD2_________________________12345678\\1&12345000&0&1.0.0"'))
                    'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\SSD1_________________________12345678\\1&12345000&0&1.0.0"'))
                }
            }
        }
    }

    Context "-ShowHistory" {

        Context "ShowUnchangedHistoricalData = `$true" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedHistoricalData = $true
                    $Config.HistoricalDataPath = $TestDrive
                }

                Get-DiskSmartInfo -UpdateHistory | Out-Null

                (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data": 358.0', '"Data": 357.0' | Set-Content -Path 'TestDrive:/localhost.txt'

                $diskSmartInfo = Get-DiskSmartInfo -ShowHistory
            }

            It "Object is of proper type" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#HistoricalData'
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoricalDate | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].HistoricalDate | Should -BeOfType 'System.DateTime'
            }

            It "Attribute object is of proper type" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute#HistoricalData'
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[10].HistoricalData | Should -Be 357
                $diskSmartInfo[0].SmartData[10].Data | Should -Be 358
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[21].HistoricalData | Should -Be 26047
                $diskSmartInfo[0].SmartData[21].Data | Should -Be 26047
            }
        }

        Context "ShowUnchangedHistoricalData = `$false" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedHistoricalData = $false
                    $Config.HistoricalDataPath = $TestDrive
                }

                Get-DiskSmartInfo -UpdateHistory | Out-Null

                (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data": 358.0', '"Data": 357.0' | Set-Content -Path 'TestDrive:/localhost.txt'

                $diskSmartInfo = Get-DiskSmartInfo -ShowHistory
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedHistoricalData = $true
                }
            }

            It "Object is of proper type" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#HistoricalData'
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoricalDate | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].HistoricalDate | Should -BeOfType 'System.DateTime'
            }

            It "Attribute object is of proper type" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute#HistoricalData'
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[10].HistoricalData | Should -Be 357
                $diskSmartInfo[0].SmartData[10].Data | Should -Be 358
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[21].HistoricalData | Should -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[21].Data | Should -Be 26047
            }
        }
    }
}
