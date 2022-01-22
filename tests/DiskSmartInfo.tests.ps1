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

            It "Has SMARTData property with 22 DiskSmartAttribute objects" {
                $diskSmartInfo.SMARTData | Should -HaveCount 22
                $diskSmartInfo.SMARTData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
            }

            It "Has correct DiskSmartAttribute objects" {
                $diskSmartInfo.SMARTData[0].ID | Should -Be 1
                $diskSmartInfo.SMARTData[12].IDHex | Should -BeExactly 'C0'
                $diskSmartInfo.SMARTData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
                $diskSmartInfo.SMARTData[2].Threshold | Should -Be 25
                $diskSmartInfo.SMARTData[2].Value | Should -Be 71
                $diskSmartInfo.SMARTData[2].Worst | Should -Be 69
                $diskSmartInfo.SMARTData[3].Data | Should -Be 25733
                $diskSmartInfo.SMARTData[13].Data | Should -HaveCount 3
                $diskSmartInfo.SMARTData[13].Data | Should -Be @(47, 14, 39)
            }
        }

        Context "-ShowConvertedData" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskInfoHDD1, $diskInfoSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSMARTData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
                $diskSmartInfo = Get-DiskSmartInfo -ShowConvertedData
            }

            It "Converts Spin-Up Time" {
                $diskSmartInfo[0].SMARTData[2].ConvertedData | Should -BeExactly '9.059 Sec'
            }

            It "Converts Power-On Hours" {
                $diskSmartInfo[0].SMARTData[7].ConvertedData | Should -BeExactly '3060.12 Days'
            }

            It "Converts Temperature Difference" {
                $diskSmartInfo[1].SMARTData[9].ConvertedData | Should -BeExactly '60 °C'
            }

            It "Converts Total LBAs Written" {
                $diskSmartInfo[1].SMARTData[13].ConvertedData | Should -BeExactly '5.933 Tb'
            }
        }
    }
}
