BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "DiskSmartInfo completions tests" {

    Context "AttributeName Get-DiskSmartInfo" {

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

        It "Suggests proper values and omits already specified" {
            $command = "Get-DiskSmartInfo -AttributeName 'Thermal Asperity Rate', 'Torque Amplification Count', T"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 5

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'Throughput Performance'"
            $commandCompletion.CompletionMatches[0].ListItemText | Should -BeExactly "Throughput Performance"
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly "2: Throughput Performance"

            $commandCompletion.CompletionMatches[4].CompletionText | Should -BeExactly "'Total LBAs Read'"
            $commandCompletion.CompletionMatches[4].ListItemText | Should -BeExactly "Total LBAs Read"
            $commandCompletion.CompletionMatches[4].ToolTip | Should -BeExactly "242: Total LBAs Read"
        }

        It "Omits already specified values" {
            $command = "Get-DiskSmartInfo -AttributeName 'Thermal Asperity Rate', 'Torque Amplification Count', "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 62

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'Raw Read Error Rate'"
            $commandCompletion.CompletionMatches[0].ListItemText | Should -BeExactly "Raw Read Error Rate"
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly "1: Raw Read Error Rate"

            $commandCompletion.CompletionMatches[61].CompletionText | Should -BeExactly "'Free Fall Sensor'"
            $commandCompletion.CompletionMatches[61].ListItemText | Should -BeExactly "Free Fall Sensor"
            $commandCompletion.CompletionMatches[61].ToolTip | Should -BeExactly "254: Free Fall Sensor"
        }
    }

    Context "AttributeName Get-DiskSmartAttributeDescription" {

        It "Suggests all values" {
            $command = "Get-DiskSmartAttributeDescription -AttributeName "
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
            $command = "Get-DiskSmartAttributeDescription -AttributeName T"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 7

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'Throughput Performance'"
            $commandCompletion.CompletionMatches[0].ListItemText | Should -BeExactly "Throughput Performance"
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly "2: Throughput Performance"

            $commandCompletion.CompletionMatches[6].CompletionText | Should -BeExactly "'Total LBAs Read'"
            $commandCompletion.CompletionMatches[6].ListItemText | Should -BeExactly "Total LBAs Read"
            $commandCompletion.CompletionMatches[6].ToolTip | Should -BeExactly "242: Total LBAs Read"
        }

        It "Suggests proper values and omits already specified" {
            $command = "Get-DiskSmartAttributeDescription -AttributeName 'Thermal Asperity Rate', 'Torque Amplification Count', T"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 5

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'Throughput Performance'"
            $commandCompletion.CompletionMatches[0].ListItemText | Should -BeExactly "Throughput Performance"
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly "2: Throughput Performance"

            $commandCompletion.CompletionMatches[4].CompletionText | Should -BeExactly "'Total LBAs Read'"
            $commandCompletion.CompletionMatches[4].ListItemText | Should -BeExactly "Total LBAs Read"
            $commandCompletion.CompletionMatches[4].ToolTip | Should -BeExactly "242: Total LBAs Read"
        }

        It "Omits already specified values" {
            $command = "Get-DiskSmartAttributeDescription -AttributeName 'Thermal Asperity Rate', 'Torque Amplification Count', "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 62

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'Raw Read Error Rate'"
            $commandCompletion.CompletionMatches[0].ListItemText | Should -BeExactly "Raw Read Error Rate"
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly "1: Raw Read Error Rate"

            $commandCompletion.CompletionMatches[61].CompletionText | Should -BeExactly "'Free Fall Sensor'"
            $commandCompletion.CompletionMatches[61].ListItemText | Should -BeExactly "Free Fall Sensor"
            $commandCompletion.CompletionMatches[61].ToolTip | Should -BeExactly "254: Free Fall Sensor"
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

            $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly '1'
            $commandCompletion.CompletionMatches.ToolTip | Should -BeExactly '1: HDD2'
        }

        It "Omits already specified values" {
            $command = "Get-DiskSmartInfo -DiskNumber 1,"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 2

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly '0'
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1'
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
        }

        Context "TrimDiskDriveModel = `$true" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskDriveATAHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.TrimDiskDriveModel = $true
                }
            }

            It "Suggests proper values" {
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
        }

        Context "TrimDiskDriveModel = `$false" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskDriveATAHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.TrimDiskDriveModel = $false
                }
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $Config.TrimDiskDriveModel = $true
                }
            }

            It "Suggests proper values" {
                $command = "Get-DiskSmartInfo -DiskNumber "
                $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

                $commandCompletion.CompletionMatches | Should -HaveCount 3

                $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly '0'
                $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1 ATA Device'
                $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly '1'
                $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '1: HDD2'
                $commandCompletion.CompletionMatches[2].CompletionText | Should -BeExactly '2'
                $commandCompletion.CompletionMatches[2].ToolTip | Should -BeExactly '2: SSD1'
            }
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

            $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly 'HDD2'
            $commandCompletion.CompletionMatches.ToolTip | Should -BeExactly '1: HDD2'
        }

        It "Omits already specified values" {
            $command = "Get-DiskSmartInfo -DiskModel HDD2,"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 2

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly 'HDD1'
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1'
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
        }

        Context "TrimDiskDriveModel = `$true" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskDriveATAHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.TrimDiskDriveModel = $true
                }
            }

            It "Suggests proper values" {
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
        }

        Context "TrimDiskDriveModel = `$false" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskDriveATAHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.TrimDiskDriveModel = $false
                }
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $Config.TrimDiskDriveModel = $true
                }
            }

            It "Suggests proper values" {
                $command = "Get-DiskSmartInfo -DiskModel "
                $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

                $commandCompletion.CompletionMatches | Should -HaveCount 3

                $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'HDD1 ATA Device'"
                $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly '0: HDD1 ATA Device'
                $commandCompletion.CompletionMatches[1].CompletionText | Should -BeExactly 'HDD2'
                $commandCompletion.CompletionMatches[1].ToolTip | Should -BeExactly '1: HDD2'
                $commandCompletion.CompletionMatches[2].CompletionText | Should -BeExactly 'SSD1'
                $commandCompletion.CompletionMatches[2].ToolTip | Should -BeExactly '2: SSD1'
            }
        }
    }
}
