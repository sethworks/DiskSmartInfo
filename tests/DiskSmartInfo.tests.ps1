BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "DiskSmartInfo" {

    Context "Get-DiskSmartInfo" {

        BeforeAll {
            $testsData = Import-PowerShellDataFile -Path $PSScriptRoot\testsData.psd1

            # Class names
            $namespaceWMI = 'root/WMI'
            $classSMARTData = 'MSStorageDriver_ATAPISmartData'
            $classThresholds = 'MSStorageDriver_FailurePredictThresholds'
            $classDiskDrive = 'Win32_DiskDrive'

            # Class objects
            $cimClassSMARTData = Get-CimClass -Namespace $namespaceWMI -ClassName $classSMARTData
            $cimClassThresholds = Get-CimClass -Namespace $namespaceWMI -ClassName $classThresholds
            $cimClassDiskDrive = Get-CimClass -ClassName $classDiskDrive

            # Properties
            # HDD1
            $diskInfoPropertiesHDD1 = @{
                VendorSpecific = $testsData.AtapiSMARTData_VendorSpecific_HDD1
                InstanceName = $testsData.InstanceName_HDD1
            }

            $diskThresholdsPropertiesHDD1 = @{
                VendorSpecific = $testsData.FailurePredictThresholds_VendorSpecific_HDD1
                InstanceName = $testsData.InstanceName_HDD1
            }

            $diskDrivePropertiesHDD1 = @{
                PNPDeviceID = $testsData.PNPDeviceID_HDD1
                Model = $testsData.Model_HDD1
                BytesPerSector = $testsData.BytesPerSector_HDD1
            }

            # HDD2
            $diskInfoPropertiesHDD2 = @{
                VendorSpecific = $testsData.AtapiSMARTData_VendorSpecific_HDD2
                InstanceName = $testsData.InstanceName_HDD2
            }

            $diskThresholdsPropertiesHDD2 = @{
                VendorSpecific = $testsData.FailurePredictThresholds_VendorSpecific_HDD2
                InstanceName = $testsData.InstanceName_HDD2
            }

            $diskDrivePropertiesHDD2 = @{
                PNPDeviceID = $testsData.PNPDeviceID_HDD2
                Model = $testsData.Model_HDD2
                BytesPerSector = $testsData.BytesPerSector_HDD2
            }

            # SSD1
            $diskInfoPropertiesSSD1 = @{
                VendorSpecific = $testsData.AtapiSMARTData_VendorSpecific_SSD1
                InstanceName = $testsData.InstanceName_SSD1
            }

            $diskThresholdsPropertiesSSD1 = @{
                VendorSpecific = $testsData.FailurePredictThresholds_VendorSpecific_SSD1
                InstanceName = $testsData.InstanceName_SSD1
            }

            $diskDrivePropertiesSSD1 = @{
                PNPDeviceID = $testsData.PNPDeviceID_SSD1
                Model = $testsData.Model_SSD1
                BytesPerSector = $testsData.BytesPerSector_SSD1
            }

            # CIM object
            $diskInfoHDD1 = New-CimInstance -CimClass $cimClassSMARTData -Property $diskInfoPropertiesHDD1 -ClientOnly
            $diskInfoHDD2 = New-CimInstance -CimClass $cimClassSMARTData -Property $diskInfoPropertiesHDD2 -ClientOnly
            $diskInfoSSD1 = New-CimInstance -CimClass $cimClassSMARTData -Property $diskInfoPropertiesSSD1 -ClientOnly

            $diskThresholdsHDD1 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesHDD1 -ClientOnly
            $diskThresholdsHDD2 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesHDD2 -ClientOnly
            $diskThresholdsSSD1 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesSSD1 -ClientOnly

            $diskDriveHDD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHDD1 -ClientOnly
            $diskDriveHDD2 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHDD2 -ClientOnly
            $diskDriveSSD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesSSD1 -ClientOnly
        }

        Context "Without parameters" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskInfoHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSMARTData } -ModuleName DiskSmartInfo
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

        }

        It "Should return something" {
            $result = Get-DiskSmartInfo
            $result | Should -BeTrue
        }
    }
}
