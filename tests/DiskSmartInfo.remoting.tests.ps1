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

        $diskPropertiesHDD1 = @{
            Number = $testsData.Index_HDD1
        }

        $physicalDiskPropertiesHDD1 = @{
            DeviceId = $testsData.Index_HDD1
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

        $diskPropertiesHDD2 = @{
            Number = $testsData.Index_HDD2
        }

        $physicalDiskPropertiesHDD2 = @{
            DeviceId = $testsData.Index_HDD2
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

        $diskPropertiesSSD1 = @{
            Number = $testsData.Index_SSD1
        }

        $physicalDiskPropertiesSSD1 = @{
            DeviceId = $testsData.Index_SSD1
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

        $diskPropertiesHFSSSD1 = @{
            Number = $testsData.Index_HFSSSD1
        }

        $physicalDiskPropertiesHFSSSDD1 = @{
            DeviceId = $testsData.Index_HFSSSD1
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

        $diskHDD1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHDD1 -ClientOnly
        $diskHDD2 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHDD2 -ClientOnly
        $diskSSD1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesSSD1 -ClientOnly
        $diskHFSSSD1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHFSSSD1 -ClientOnly

        $physicalDiskHDD1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHDD1 -ClientOnly
        $physicalDiskHDD2 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHDD2 -ClientOnly
        $physicalDiskSSD1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesSSD1 -ClientOnly
        $physicalDiskHFSSSD1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHFSSSD1 -ClientOnly

        $computerNames = $env:computername, 'localhost'
    }

    Context "ComputerName" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            $diskSmartInfo[0].Model | Should -BeExactly $testsData.Model_HDD1
            $diskSmartInfo[0].InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].Model | Should -BeExactly $testsData.Model_HDD1
            $diskSmartInfo[1].InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 22
            $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[0].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[0].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[0].SmartData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[0].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[0].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[0].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[0].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[0].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[0].SmartData[13].Data | Should -Be @(47, 14, 39)
        }
    }
}
