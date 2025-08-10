BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "Archive Ctl" {

    Context "Localhost" {

        BeforeAll {

            mock Get-Command -MockWith { $true } -ParameterFilter { $Name -eq 'smartctl' } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

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
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sda"'))
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdb"'))
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdc"'))
            }
            else
            {
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sda"'))
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdb"'))
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdc"'))
            }
        }

        It "Archive file contains proper data" {
            if ($IsCoreCLR)
            {
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"ID": 1,')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"IDHex": "2",')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Name": "Spin-Up Time",')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Threshold": 10,')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Value": 252,')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Worst": 252,')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Data": 25733')
            }
            else
            {
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"ID":  1,')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"IDHex":  "2",')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Name":  "Spin-Up Time",')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Threshold":  10,')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Value":  252,')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Worst":  252,')
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ('"Data":  25733')
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
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

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
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sda"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdb"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdc"'))

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sda"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdb"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdc"'))
            }
            else
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sda"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdb"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdc"'))

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sda"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdb"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdc"'))
            }
        }

        It "Archive files contains proper data" {
            if ($IsCoreCLR)
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID": 3,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex": "4",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name": "Seek Error Rate",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold": 140,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value": 39,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst": 200,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data": 73551')

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID": 5,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex": "9",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name": "Power Cycle Count",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold": 10,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value": 60,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst": 99,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data": 12740846422')
            }
            else
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID":  3,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex":  "4",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name":  "Seek Error Rate",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold":  140,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value":  39,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst":  200,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data":  73551')

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID":  5,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex":  "9",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name":  "Power Cycle Count",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold":  10,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value":  60,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst":  99,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data":  12740846422')
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
            mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1, $testDataCtl.CtlScan_HDD2, $testDataCtl.CtlScan_SSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataHDD2 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdb" } -ModuleName DiskSmartInfo
            mock Invoke-Command -MockWith { $ctlDataSSD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sdc" } -ModuleName DiskSmartInfo

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
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sda"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdb"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdc"'))

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sda"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdb"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device": "/dev/sdc"'))
            }
            else
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sda"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdb"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdc"'))

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sda"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdb"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"Device":  "/dev/sdc"'))
            }
        }

        It "Archive files contains proper data" {
            if ($IsCoreCLR)
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID": 3,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex": "4",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name": "Seek Error Rate",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold": 140,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value": 39,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst": 200,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data": 73551')

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID": 5,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex": "9",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name": "Power Cycle Count",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold": 10,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value": 60,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst": 99,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data": 12740846422')
            }
            else
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID":  3,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex":  "4",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name":  "Seek Error Rate",')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold":  140,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value":  39,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst":  200,')
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data":  73551')

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"ID":  5,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"IDHex":  "9",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Name":  "Power Cycle Count",')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Threshold":  10,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Value":  60,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Worst":  99,')
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ('"Data":  12740846422')
            }
        }
    }
}
