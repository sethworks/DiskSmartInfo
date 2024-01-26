BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "DiskSmartInfo remocking tests" {

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

    Context "ComputerName" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-CimSession -MockWith { $cimSessionHost1, $cimSessionHost2 } -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

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
    Context "ComputerName IP Address" {

        BeforeAll {
            $cimSessionHost3 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $ipAddresses[0]}
            $cimSessionHost4 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $ipAddresses[1]}
            mock New-CimSession -MockWith { $cimSessionHost3, $cimSessionHost4 } -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $diskSmartInfo = Get-DiskSmartInfo -ComputerName $ipAddresses
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $ipAddresses
            $diskSmartInfo[0].Model | Should -BeExactly $testsData.Model_HDD1
            $diskSmartInfo[0].InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $ipAddresses.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
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
    Context "ComputerName pipeline" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-CimSession -MockWith { $cimSessionHost1, $cimSessionHost2 } -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $diskSmartInfo = $computerNames | Get-DiskSmartInfo
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
    Context "CimSession" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]} -Methods @{TestConnection = {$true}}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]} -Methods @{TestConnection = {$true}}
            # mock New-CimSession -MockWith { $cimSessionHost1, $cimSessionHost2 } -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -CimSession $cimSessionHost1, $cimSessionHost2
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
    Context "CimSession IP Address" {

        BeforeAll {
            $cimSessionHost3 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $ipAddresses[0]} -Methods @{TestConnection = {$true}}
            $cimSessionHost4 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $ipAddresses[1]} -Methods @{TestConnection = {$true}}
            # mock New-CimSession -MockWith { $cimSessionHost3, $cimSessionHost4 } -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -CimSession $cimSessionHost3, $cimSessionHost4
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $ipAddresses
            $diskSmartInfo[0].Model | Should -BeExactly $testsData.Model_HDD1
            $diskSmartInfo[0].InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD1

            $diskSmartInfo[1].ComputerName | Should -BeExactly $ipAddresses.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            $diskSmartInfo[1].Model | Should -BeExactly $testsData.Model_HDD1
            $diskSmartInfo[1].InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD1
        }

        It "Has SmartData property with 22 DiskSmartAttribute objects" {
            $diskSmartInfo[1].SmartData | Should -HaveCount 22
            $diskSmartInfo[1].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute'
        }

        It "Has correct DiskSmartAttribute objects" {
            $diskSmartInfo[1].SmartData[0].ID | Should -Be 1
            $diskSmartInfo[1].SmartData[12].IDHex | Should -BeExactly 'C0'
            $diskSmartInfo[1].SmartData[2].AttributeName | Should -BeExactly 'Spin-Up Time'
            $diskSmartInfo[1].SmartData[2].Threshold | Should -Be 25
            $diskSmartInfo[1].SmartData[2].Value | Should -Be 71
            $diskSmartInfo[1].SmartData[2].Worst | Should -Be 69
            $diskSmartInfo[1].SmartData[3].Data | Should -Be 25733
            $diskSmartInfo[1].SmartData[13].Data | Should -HaveCount 3
            $diskSmartInfo[1].SmartData[13].Data | Should -Be @(47, 14, 39)
        }
    }
    Context "CimSession pipeline" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]} -Methods @{TestConnection = {$true}}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]} -Methods @{TestConnection = {$true}}
            # mock New-CimSession -MockWith { $cimSessionHost1, $cimSessionHost2 } -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $cimSessionHost1, $cimSessionHost2 | Get-DiskSmartInfo
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
    Context "Win32_DiskDrive pipeline" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-CimSession -MockWith { $cimSessionHost1, $cimSessionHost2 } -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $diskDriveHost1, $diskDriveHost2 | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            if ($diskSmartInfo[0].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testsData.Model_HDD2
                $diskSmartInfo[0].InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD2
                $diskSmartInfo[0].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[0].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testsData.Model_SSD1
                $diskSmartInfo[0].InstanceId | Should -BeExactly $testsData.PNPDeviceID_SSD1
                $diskSmartInfo[0].SmartData | Should -HaveCount 15
            }

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            if ($diskSmartInfo[1].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testsData.Model_HDD2
                $diskSmartInfo[1].InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD2
                $diskSmartInfo[1].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[1].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testsData.Model_SSD1
                $diskSmartInfo[1].InstanceId | Should -BeExactly $testsData.PNPDeviceID_SSD1
                $diskSmartInfo[1].SmartData | Should -HaveCount 15
            }
        }
    }
    Context "MSFT_Disk pipeline" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-CimSession -MockWith { $cimSessionHost1, $cimSessionHost2 } -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $diskHost1, $diskHost2 | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            if ($diskSmartInfo[0].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testsData.Model_HDD2
                $diskSmartInfo[0].InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD2
                $diskSmartInfo[0].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[0].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testsData.Model_SSD1
                $diskSmartInfo[0].InstanceId | Should -BeExactly $testsData.PNPDeviceID_SSD1
                $diskSmartInfo[0].SmartData | Should -HaveCount 15
            }

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            if ($diskSmartInfo[1].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testsData.Model_HDD2
                $diskSmartInfo[1].InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD2
                $diskSmartInfo[1].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[1].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testsData.Model_SSD1
                $diskSmartInfo[1].InstanceId | Should -BeExactly $testsData.PNPDeviceID_SSD1
                $diskSmartInfo[1].SmartData | Should -HaveCount 15
            }
        }
    }
    Context "MSFT_PhysicalDisk pipeline" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-CimSession -MockWith { $cimSessionHost1, $cimSessionHost2 } -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = $physicalDiskHost1, $physicalDiskHost2 | Get-DiskSmartInfo
        }

        It "Returns DiskSmartInfo object" {
            $diskSmartInfo | Should -HaveCount 2
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
            $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#ComputerName'
        }

        It "Has ComputerName, Model, and InstanceId properties" {
            $diskSmartInfo[0].ComputerName | Should -BeIn $computerNames
            if ($diskSmartInfo[0].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testsData.Model_HDD2
                $diskSmartInfo[0].InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD2
                $diskSmartInfo[0].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[0].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[0].Model | Should -BeExactly $testsData.Model_SSD1
                $diskSmartInfo[0].InstanceId | Should -BeExactly $testsData.PNPDeviceID_SSD1
                $diskSmartInfo[0].SmartData | Should -HaveCount 15
            }

            $diskSmartInfo[1].ComputerName | Should -BeExactly $computerNames.Where{$_ -notlike $diskSmartInfo[0].ComputerName}
            if ($diskSmartInfo[1].ComputerName -eq $computerNames[0])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testsData.Model_HDD2
                $diskSmartInfo[1].InstanceId | Should -BeExactly $testsData.PNPDeviceID_HDD2
                $diskSmartInfo[1].SmartData | Should -HaveCount 18
            }
            elseif ($diskSmartInfo[1].ComputerName -eq $computerNames[1])
            {
                $diskSmartInfo[1].Model | Should -BeExactly $testsData.Model_SSD1
                $diskSmartInfo[1].InstanceId | Should -BeExactly $testsData.PNPDeviceID_SSD1
                $diskSmartInfo[1].SmartData | Should -HaveCount 15
            }
        }
    }
}
