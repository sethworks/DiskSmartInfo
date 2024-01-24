BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "DiskSmartInfo completions tests" {

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
    }

    Context "AttributeName" {
        It "Suggests all values" {
            $command = "Get-DiskSmartInfo -AttributeName "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 64

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'Raw Read Error Rate'"
            $commandCompletion.CompletionMatches[0].ListItemText | Should -BeExactly "Raw Read Error Rate"
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly "1: Raw Read Error Rate"

            $commandCompletion.CompletionMatches[63].CompletionText | Should -BeExactly "'Free Fall Sensor'"
            $commandCompletion.CompletionMatches[63].ListItemText | Should -BeExactly "Free Fall Sensor"
            $commandCompletion.CompletionMatches[63].ToolTip | Should -BeExactly "254: Free Fall Sensor"
        }

        It "Suggests proper values" {
            $command = "Get-DiskSmartInfo -AttributeName T"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 7

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'Throughput Performance'"
            $commandCompletion.CompletionMatches[0].ListItemText | Should -BeExactly "Throughput Performance"
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly "2: Throughput Performance"

            $commandCompletion.CompletionMatches[6].CompletionText | Should -BeExactly "'Total LBAs Read'"
            $commandCompletion.CompletionMatches[6].ListItemText | Should -BeExactly "Total LBAs Read"
            $commandCompletion.CompletionMatches[6].ToolTip | Should -BeExactly "242: Total LBAs Read"
        }

        It "Omits already specified values" {
            $command = "get-disksmartInfo -AttributeName 'Thermal Asperity Rate', 'Torque Amplification Count', T"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 5

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'Throughput Performance'"
            $commandCompletion.CompletionMatches[0].ListItemText | Should -BeExactly "Throughput Performance"
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly "2: Throughput Performance"

            $commandCompletion.CompletionMatches[4].CompletionText | Should -BeExactly "'Total LBAs Read'"
            $commandCompletion.CompletionMatches[4].ListItemText | Should -BeExactly "Total LBAs Read"
            $commandCompletion.CompletionMatches[4].ToolTip | Should -BeExactly "242: Total LBAs Read"
        }
    }

    Context "DiskNumber" {
        BeforeAll {
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
        }

        It "Suggests all values" {
            $command = "Get-DiskSmartInfo -DiskNumber "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 3

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly '0'
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1'
            $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly '1'
            $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '1: HDD2'
            $commandCompletion.CompletionMatches[2].CompletionText | Should -BeExactly '2'
            $commandCompletion.CompletionMatches[2].ToolTip | Should -BeExactly '2: SSD1'
        }

        It "Suggests proper values" {
            $command = "Get-DiskSmartInfo -DiskNumber 1"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 1

            # $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly '0'
            # $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1'
            $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly '1'
            $commandCompletion.CompletionMatches.ToolTip | Should -BeExactly '1: HDD2'
            # $commandCompletion.CompletionMatches[2].CompletionText | Should -BeExactly '2'
            # $commandCompletion.CompletionMatches[2].ToolTip | Should -BeExactly '2: SSD1'
        }

        It "Omits already specified values" {
            $command = "Get-DiskSmartInfo -DiskNumber 1,"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 2

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly '0'
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1'
            # $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly '1'
            # $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '1: HDD2'
            $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly '2'
            $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '2: SSD1'
        }

        It "Do not return values for multiple hosts" {
            $command = "Get-DiskSmartInfo -ComputerName 'host1', 'host2' -DiskNumber "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -BeNullOrEmpty

            $command = "Get-DiskSmartInfo -CimSession 'host1', 'host2' -DiskNumber "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -BeNullOrEmpty

            $command = "Get-DiskSmartInfo -ComputerName 'host1' -CimSession 'host2' -DiskNumber "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -BeNullOrEmpty

            # $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly '0'
            # $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1'
            # $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly '1'
            # $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '1: HDD2'
            # $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly '2'
            # $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '2: SSD1'
        }
    }

    Context "DiskModel" {
        BeforeAll {
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
        }

        It "Suggests all values" {
            $command = "Get-DiskSmartInfo -DiskModel "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 3

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly 'HDD1'
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1'
            $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly 'HDD2'
            $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '1: HDD2'
            $commandCompletion.CompletionMatches[2].CompletionText | Should -BeExactly 'SSD1'
            $commandCompletion.CompletionMatches[2].ToolTip | Should -BeExactly '2: SSD1'
        }

        It "Suggests proper values" {
            $command = "Get-DiskSmartInfo -DiskModel HDD2"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 1

            # $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly '0'
            # $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1'
            $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly 'HDD2'
            $commandCompletion.CompletionMatches.ToolTip | Should -BeExactly '1: HDD2'
            # $commandCompletion.CompletionMatches[2].CompletionText | Should -BeExactly '2'
            # $commandCompletion.CompletionMatches[2].ToolTip | Should -BeExactly '2: SSD1'
        }

        It "Omits already specified values" {
            $command = "Get-DiskSmartInfo -DiskModel HDD2,"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 2

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly 'HDD1'
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1'
            # $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly '1'
            # $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '1: HDD2'
            $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly 'SSD1'
            $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '2: SSD1'
        }

        It "Do not return values for multiple hosts" {
            $command = "Get-DiskSmartInfo -ComputerName 'host1', 'host2' -DiskModel "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -BeNullOrEmpty

            $command = "Get-DiskSmartInfo -CimSession 'host1', 'host2' -DiskModel "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -BeNullOrEmpty

            $command = "Get-DiskSmartInfo -ComputerName 'host1' -CimSession 'host2' -DiskModel "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -BeNullOrEmpty

            # $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly '0'
            # $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1'
            # $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly '1'
            # $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '1: HDD2'
            # $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly '2'
            # $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '2: SSD1'
        }
    }
}
