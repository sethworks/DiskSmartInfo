BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "Archive" {

    Context "Localhost" {

        BeforeAll {

            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo

            # mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

            # mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $dt = New-MockObject -Type 'System.DateTime' -Properties @{Year=2025;Month=7;Day=17;Hour=12;Minute=34;Second=56} -Methods @{ToString={'_2025-07-17_12-34-56'}}
            mock Get-Date -MockWith { $dt } -ModuleName DiskSmartInfo

            InModuleScope DiskSmartInfo {
                $Config.ArchivePath = $TestDrive
            }
            Get-DiskSmartInfo -Source SmartCtl -Archive | Out-Null
        }

        It "Archive file exists" {
            'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -Exist
        }

        It "Archive file contains proper devices" {
            if ($IsCoreCLR)
            {
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme0"'))
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme1"'))
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdc"'))
            }
            else
            {
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme0"'))
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme1"'))
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdc"'))
            }
        }

        It "Archive file contains proper data" {
            if ($IsCoreCLR)
            {
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"ID": 1,')
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"IDHex": "2",')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Name": "Controller Busy Time",')
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Threshold": 10,')
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Value": 252,')
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Worst": 252,')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Data": "45"')
            }
            else
            {
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"ID":  1,')
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"IDHex":  "2",')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Name":  "Controller Busy Time",')
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Threshold":  10,')
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Value":  252,')
                # 'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Worst":  252,')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Data":  "45"')
            }
        }
    }

    Context "PSSession" {

        BeforeAll {

            $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
            $psSessionHost2 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            mock New-PSSession -MockWith { $psSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

            mock Invoke-Command -MockWith { $true } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue "} -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $false } -ParameterFilter { $ScriptBlock.ToString() -eq ' $IsLinux ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo

            # mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

            # $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            # $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            # mock New-CimSession -MockWith { $cimSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            # mock New-CimSession -MockWith { $cimSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            # mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            # mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $dt = New-MockObject -Type 'System.DateTime' -Properties @{Year=2025;Month=7;Day=17;Hour=12;Minute=34;Second=56} -Methods @{ToString={'_2025-07-17_12-34-56'}}
            mock Get-Date -MockWith { $dt } -ModuleName DiskSmartInfo

            InModuleScope DiskSmartInfo {
                $Config.ArchivePath = $TestDrive
            }
            Get-DiskSmartInfo -Transport PSSession -Source SmartCtl -ComputerName $computerNames -Archive | Out-Null
        }

        It "Archive file exists" {
            "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -Exist
            "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -Exist
        }

        It "Archive files contains proper devices" {
            if ($IsCoreCLR)
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme0"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme1"'))
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdc"'))

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme0"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme1"'))
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdc"'))
            }
            else
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme0"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme1"'))
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdc"'))

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme0"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme1"'))
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdc"'))
            }
        }

        It "Archive files contains proper data" {
            if ($IsCoreCLR)
            {
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID": 3,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex": "4",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name": "Controller Busy Time",')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold": 140,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value": 39,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst": 200,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data": "715"')

                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID": 5,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex": "9",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name": "Power On Hours",')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold": 10,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value": 60,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst": 99,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data": "45"')
            }
            else
            {
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID":  3,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex":  "4",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name":  "Controller Busy Time",')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold":  140,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value":  39,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst":  200,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data":  "715"')

                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID":  5,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex":  "9",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name":  "Power On Hours",')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold":  10,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value":  60,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst":  99,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data":  "45"')
            }
        }
    }

    Context "SSHSession" -Skip:(-not ($IsCoreCLR -and $IsWindows)) {

        BeforeAll {

            $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]; Transport = 'SSH'}
            $psSessionHost2 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[1]; Transport = 'SSH'}
            mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$HostName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            mock New-PSSession -MockWith { $psSessionHost2 } -ParameterFilter {$HostName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

            mock Invoke-Command -MockWith { $true } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue "} -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $false } -ParameterFilter { $ScriptBlock.ToString() -eq ' $IsLinux ' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_NVMe1, $testDataCtl.CtlScan_NVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataNVMe1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme0" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataNVMe2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/nvme1" } -ModuleName DiskSmartInfo

            # mock Invoke-Command -MockWith { $true } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue "} -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $false } -ParameterFilter { $ScriptBlock.ToString() -eq ' $IsLinux ' } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

            # $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
            # $psSessionHost2 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[1]}
            # mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            # mock New-PSSession -MockWith { $psSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            # mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

            # mock Invoke-Command -MockWith { $true } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue "} -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $false } -ParameterFilter { $ScriptBlock.ToString() -eq ' $IsLinux ' } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
            # mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

            # $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            # $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            # mock New-CimSession -MockWith { $cimSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            # mock New-CimSession -MockWith { $cimSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            # mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            # mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            # mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $dt = New-MockObject -Type 'System.DateTime' -Properties @{Year=2025;Month=7;Day=17;Hour=12;Minute=34;Second=56} -Methods @{ToString={'_2025-07-17_12-34-56'}}
            mock Get-Date -MockWith { $dt } -ModuleName DiskSmartInfo

            InModuleScope DiskSmartInfo {
                $Config.ArchivePath = $TestDrive
            }
            Get-DiskSmartInfo -Transport SSHSession -Source SmartCtl -ComputerName $computerNames -Archive | Out-Null
        }

        It "Archive file exists" {
            "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -Exist
            "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -Exist
        }

        It "Archive files contains proper devices" {
            if ($IsCoreCLR)
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme0"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme1"'))
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdc"'))

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme0"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/nvme1"'))
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdc"'))
            }
            else
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme0"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme1"'))
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdc"'))

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme0"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/nvme1"'))
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdc"'))
            }
        }

        It "Archive files contains proper data" {
            if ($IsCoreCLR)
            {
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID": 3,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex": "4",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name": "Controller Busy Time",')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold": 140,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value": 39,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst": 200,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data": "715"')

                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID": 5,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex": "9",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name": "Power On Hours",')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold": 10,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value": 60,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst": 99,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data": "45"')
            }
            else
            {
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID":  3,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex":  "4",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name":  "Controller Busy Time",')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold":  140,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value":  39,')
                # "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst":  200,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data":  "715"')

                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID":  5,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex":  "9",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name":  "Power On Hours",')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold":  10,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value":  60,')
                # "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst":  99,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data":  "45"')
            }
        }
    }
}
