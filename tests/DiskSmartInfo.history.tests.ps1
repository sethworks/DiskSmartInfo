BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "DiskSmartInfo" {

    Context "History" {

        Context "-UpdateHistory" {

            Context "localhost" {
                BeforeAll {
                    mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                    mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
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
                    if ($IsCoreCLR)
                    {
                        'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD1_________________________12345678\\1&12345000&0&1.0.0"'))
                        'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\HDD2_________________________12345678\\1&12345000&0&1.0.0"'))
                        'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId": "IDE\\SSD1_________________________12345678\\1&12345000&0&1.0.0"'))
                    }
                    else
                    {
                        'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\HDD1_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                        'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\HDD2_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                        'TestDrive:\localhost.txt' | Should -FileContentMatch ([regex]::Escape('"PNPDeviceId":  "IDE\\SSD1_________________________12345678\\1\u002612345000\u00260\u00261.0.0"'))
                    }
                }
            }
        }
    }

    Context "-ShowHistory" {

        Context "ShowUnchangedHistoricalData = `$true" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedHistoricalData = $true
                    $Config.HistoricalDataPath = $TestDrive
                }

                Get-DiskSmartInfo -UpdateHistory | Out-Null

                if ($IsCoreCLR)
                {
                    (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data": 358.0', '"Data": 357.0' | Set-Content -Path 'TestDrive:/localhost.txt'
                }
                else
                {
                    (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data":  358', '"Data":  357' | Set-Content -Path 'TestDrive:/localhost.txt'
                }

                $diskSmartInfo = Get-DiskSmartInfo -ShowHistory
            }

            It "Object is of proper type" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#DataHistory'
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoryDate | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].HistoryDate | Should -BeOfType 'System.DateTime'
            }

            It "Attribute object is of proper type" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute#DataHistory'
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[10].DataHistory | Should -Be 357
                $diskSmartInfo[0].SmartData[10].Data | Should -Be 358
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[21].DataHistory | Should -Be 26047
                $diskSmartInfo[0].SmartData[21].Data | Should -Be 26047
            }
        }

        Context "ShowUnchangedHistoricalData = `$false" {
            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataHDD1, $diskSmartDataHDD2, $diskSmartDataSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsHDD1, $diskThresholdsHDD2, $diskThresholdsSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1, $diskFailurePredictStatusHDD2, $diskFailurePredictStatusSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveHDD1, $diskDriveHDD2, $diskDriveSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedHistoricalData = $false
                    $Config.HistoricalDataPath = $TestDrive
                }

                Get-DiskSmartInfo -UpdateHistory | Out-Null

                if ($IsCoreCLR)
                {
                    (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data": 358.0', '"Data": 357.0' | Set-Content -Path 'TestDrive:/localhost.txt'
                }
                else
                {
                    (Get-Content -Path 'TestDrive:/localhost.txt') -replace '"Data":  358', '"Data":  357' | Set-Content -Path 'TestDrive:/localhost.txt'
                }

                $diskSmartInfo = Get-DiskSmartInfo -ShowHistory
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $Config.ShowUnchangedHistoricalData = $true
                }
            }

            It "Object is of proper type" {
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo#DataHistory'
            }

            It "HistoricalDate property exists" {
                $diskSmartInfo[0].HistoryDate | Should -Not -BeNullOrEmpty
                $diskSmartInfo[0].HistoryDate | Should -BeOfType 'System.DateTime'
            }

            It "Attribute object is of proper type" {
                $diskSmartInfo[0].SmartData[0].pstypenames[0] | Should -BeExactly 'DiskSmartAttribute#DataHistory'
            }

            It "Changed attribute data" {
                $diskSmartInfo[0].SmartData[10].DataHistory | Should -Be 357
                $diskSmartInfo[0].SmartData[10].Data | Should -Be 358
            }

            It "Unchanged attribute data" {
                $diskSmartInfo[0].SmartData[21].DataHistory | Should -BeNullOrEmpty
                $diskSmartInfo[0].SmartData[21].Data | Should -Be 26047
            }
        }
    }
}
