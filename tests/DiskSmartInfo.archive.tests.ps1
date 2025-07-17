BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "Archive" {

    Context "Localhost" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $dt = New-MockObject -Type 'System.DateTime' -Properties @{Year=2025;Month=7;Day=17;Hour=12;Minute=34;Second=56} -Methods @{ToString={'_2025-07-17_12-34-56'}}
            mock Get-Date -MockWith { $dt } -ModuleName DiskSmartInfo

            InModuleScope DiskSmartInfo {
                $Config.ArchivePath = $TestDrive
            }
            Get-DiskSmartInfo -Archive | Out-Null
        }

        It "Archive file exists" {
            'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -Exist
        }

        It "Archive file contains proper devices" {
            if ($IsCoreCLR)
            {
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD1_________________________12345678\\1&12345000&0&1.0.0"'))
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD2_________________________12345678\\1&12345000&0&1.0.0"'))
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\SSD1_________________________12345678\\1&12345000&0&1.0.0"'))
            }
            else
            {
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\HDD1_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\HDD2_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                'TestDrive:/localhost/localhost_2025-07-17_12-34-56.json' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\SSD1_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
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

    Context "ComputerName" {

        BeforeAll {
            $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]}
            $cimSessionHost2 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[1]}
            mock New-CimSession -MockWith { $cimSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
            mock New-CimSession -MockWith { $cimSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
            mock Remove-CimSession -MockWith { } -ModuleName DiskSmartInfo

            mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $dt = New-MockObject -Type 'System.DateTime' -Properties @{Year=2025;Month=7;Day=17;Hour=12;Minute=34;Second=56} -Methods @{ToString={'_2025-07-17_12-34-56'}}
            mock Get-Date -MockWith { $dt } -ModuleName DiskSmartInfo

            InModuleScope DiskSmartInfo {
                $Config.ArchivePath = $TestDrive
            }
            Get-DiskSmartInfo -ComputerName $computerNames -Archive | Out-Null
        }

        It "Archive file exists" {
            "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -Exist
            "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -Exist
        }

        It "Archive files contains proper devices" {
            if ($IsCoreCLR)
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD1_________________________12345678\\1&12345000&0&1.0.0"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD2_________________________12345678\\1&12345000&0&1.0.0"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\SSD1_________________________12345678\\1&12345000&0&1.0.0"'))

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD1_________________________12345678\\1&12345000&0&1.0.0"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD2_________________________12345678\\1&12345000&0&1.0.0"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\SSD1_________________________12345678\\1&12345000&0&1.0.0"'))
            }
            else
            {
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\HDD1_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\HDD2_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                "TestDrive:/$($computerNames[0])/$($computerNames[0])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\SSD1_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))

                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\HDD1_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\HDD2_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                "TestDrive:/$($computerNames[1])/$($computerNames[1])_2025-07-17_12-34-56.json" | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\SSD1_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
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
