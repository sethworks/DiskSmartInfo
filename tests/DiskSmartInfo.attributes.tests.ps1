BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Context "Actual attributes list" {

    Context "Attribute names for overwritten attributes" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1, $diskSmartDataSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1, $diskThresholdsSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusSSD1, $diskFailurePredictStatusHFSSSD1, $diskFailurePredictStatusSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1, $diskDriveSSD2 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo
        }

        It "Has 3 DiskSmartInfo objects" {
            $diskSmartInfo | Should -HaveCount 3
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'

            $diskSmartInfo[0].DiskNumber | Should -Be $testData.Index_SSD1
            $diskSmartInfo[1].DiskNumber | Should -Be $testDataProprietary.Index_HFSSSD1
            $diskSmartInfo[2].DiskNumber | Should -Be $testData.Index_SSD2
        }

        It "Has default attribute definitions" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 15
            $diskSmartInfo[0].SmartData[13].ID | Should -Be 241
            $diskSmartInfo[0].SmartData[13].Name | Should -BeExactly "Total LBAs Written"
            $diskSmartInfo[0].SmartData[14].ID | Should -Be 242
            $diskSmartInfo[0].SmartData[14].Name | Should -BeExactly "Total LBAs Read"
        }

        It "Has overwritten attrubute definitions" {
            $diskSmartInfo[1].SmartData | Should -HaveCount 30
            $diskSmartInfo[1].SmartData[27].ID | Should -Be 241
            $diskSmartInfo[1].SmartData[27].Name | Should -BeExactly "Total Writes GB"
            $diskSmartInfo[1].SmartData[28].ID | Should -Be 242
            $diskSmartInfo[1].SmartData[28].Name | Should -BeExactly "Total Reads GB"
            $diskSmartInfo[1].SmartData[29].ID | Should -Be 249
            $diskSmartInfo[1].SmartData[29].Name | Should -BeExactly "NAND Writes GiB"
        }

        It "Has default attribute definitions" {
            $diskSmartInfo[2].SmartData | Should -HaveCount 16
            $diskSmartInfo[2].SmartData[13].ID | Should -Be 241
            $diskSmartInfo[2].SmartData[13].Name | Should -BeExactly "Total LBAs Written"
            $diskSmartInfo[2].SmartData[14].ID | Should -Be 242
            $diskSmartInfo[2].SmartData[14].Name | Should -BeExactly "Total LBAs Read"
        }
    }

    Context "Converted data for overwritten attributes" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1, $diskSmartDataSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1, $diskThresholdsSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusSSD1, $diskFailurePredictStatusHFSSSD1, $diskFailurePredictStatusSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1, $diskDriveSSD2 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
            $diskSmartInfo = Get-DiskSmartInfo -Convert
        }

        It "Has 3 DiskSmartInfo objects" {
            $diskSmartInfo | Should -HaveCount 3
            $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'

            $diskSmartInfo[0].DiskNumber | Should -Be $testData.Index_SSD1
            $diskSmartInfo[1].DiskNumber | Should -Be $testDataProprietary.Index_HFSSSD1
            $diskSmartInfo[2].DiskNumber | Should -Be $testData.Index_SSD2
        }

        It "Has default attribute definitions" {
            $diskSmartInfo[0].SmartData | Should -HaveCount 15
            $diskSmartInfo[0].SmartData[13].ID | Should -Be 241
            $diskSmartInfo[0].SmartData[13].Name | Should -BeExactly "Total LBAs Written"
            $diskSmartInfo[0].SmartData[13].Data | Should -Be 12740846422
            $diskSmartInfo[0].SmartData[13].DataConverted | Should -BeExactly "5.933 TB"
            $diskSmartInfo[0].SmartData[14].ID | Should -Be 242
            $diskSmartInfo[0].SmartData[14].Name | Should -BeExactly "Total LBAs Read"
            $diskSmartInfo[0].SmartData[14].Data | Should -Be 9556432520
            $diskSmartInfo[0].SmartData[14].DataConverted | Should -BeExactly "4.450 TB"
        }

        It "Has overwritten attrubute definitions" {
            $diskSmartInfo[1].SmartData | Should -HaveCount 30
            $diskSmartInfo[1].SmartData[27].ID | Should -Be 241
            $diskSmartInfo[1].SmartData[27].Name | Should -BeExactly "Total Writes GB"
            $diskSmartInfo[1].SmartData[27].Data | Should -Be 2034
            $diskSmartInfo[1].SmartData[27].DataConverted | Should -BeExactly "1.986 TB"
            $diskSmartInfo[1].SmartData[28].ID | Should -Be 242
            $diskSmartInfo[1].SmartData[28].Name | Should -BeExactly "Total Reads GB"
            $diskSmartInfo[1].SmartData[28].Data | Should -Be 2596
            $diskSmartInfo[1].SmartData[28].DataConverted | Should -BeExactly "2.535 TB"
            $diskSmartInfo[1].SmartData[29].Name | Should -BeExactly "NAND Writes GiB"
            $diskSmartInfo[1].SmartData[29].Data | Should -Be 1745
            $diskSmartInfo[1].SmartData[29].DataConverted | Should -BeExactly "1.704 TB"
        }

        It "Has default attribute definitions" {
            $diskSmartInfo[2].SmartData | Should -HaveCount 16
            $diskSmartInfo[2].SmartData[13].ID | Should -Be 241
            $diskSmartInfo[2].SmartData[13].Name | Should -BeExactly "Total LBAs Written"
            $diskSmartInfo[2].SmartData[13].Data | Should -Be 12757689431
            $diskSmartInfo[2].SmartData[13].DataConverted | Should -BeExactly "5.941 TB"
            $diskSmartInfo[2].SmartData[14].ID | Should -Be 242
            $diskSmartInfo[2].SmartData[14].Name | Should -BeExactly "Total LBAs Read"
            $diskSmartInfo[2].SmartData[14].Data | Should -Be 9573275529
            $diskSmartInfo[2].SmartData[14].DataConverted | Should -BeExactly "4.458 TB"
        }
    }

    Context "IsCritical property for overwritten attributes" {

        Context "Default attributes" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusSSD1, $diskFailurePredictStatusHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
                $diskSmartInfo = Get-DiskSmartInfo -CriticalAttributesOnly
            }

            It "Retains IsCritical property value during attribute overwriting" {
                $diskSmartInfo[1].SmartData | Should -HaveCount 6
                $diskSmartInfo[1].SmartData[0].ID | Should -Be 5
                $diskSmartInfo[1].SmartData[0].Name | Should -BeExactly "Retired Block Count"
            }
        }

        Context "Overwrite attributes IsCritical = `$false" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusSSD1, $diskFailurePredictStatusHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $proprietaryAttributes.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Add("IsCritical", $false)
                }

                $diskSmartInfo = Get-DiskSmartInfo -CriticalAttributesOnly
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $proprietaryAttributes.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Remove("IsCritical")
                }
            }

            It "Update IsCritical property value during attribute overwriting" {
                $diskSmartInfo[1].SmartData | Should -HaveCount 5
                $diskSmartInfo[1].SmartData[0].ID | Should -Be 184
                $diskSmartInfo[1].SmartData[0].Name | Should -BeExactly "End-to-End Error"

                $diskSmartInfo[1].SmartData.Name | Should -Not -Contain 'Retired Block Count'
            }
        }

        Context "Overwrite attributes IsCritical = `$true" {

            BeforeAll {
                mock Get-CimInstance -MockWith { $diskSmartDataSSD1, $diskSmartDataHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskThresholdsSSD1, $diskThresholdsHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskFailurePredictStatusSSD1, $diskFailurePredictStatusHFSSSD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
                mock Get-CimInstance -MockWith { $diskDriveSSD1, $diskDriveHFSSSD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

                InModuleScope DiskSmartInfo {
                    $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeID -eq 5}).IsCritical = $false
                    $proprietaryAttributes.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Add("IsCritical", $true)
                }

                $diskSmartInfo = Get-DiskSmartInfo -CriticalAttributesOnly
            }

            AfterAll {
                InModuleScope DiskSmartInfo {
                    $defaultAttributes.Find([Predicate[PSCustomObject]]{$args[0].AttributeID -eq 5}).IsCritical = $true
                    $proprietaryAttributes.Where{$_.Family -eq "SK hynix SATA SSDs"}.Attributes.Where{$_.AttributeID -eq 5}[0].Remove("IsCritical")
                }
            }

            It "Update IsCritical property value during attribute overwriting" {
                $diskSmartInfo[1].SmartData | Should -HaveCount 6
                $diskSmartInfo[1].SmartData[0].ID | Should -Be 5
                $diskSmartInfo[1].SmartData[0].Name | Should -BeExactly "Retired Block Count"
            }
        }
    }
}

Context "Unknown attributes" {

    BeforeAll {
        mock Get-CimInstance -MockWith { $diskSmartDataSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
        mock Get-CimInstance -MockWith { $diskThresholdsSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
        mock Get-CimInstance -MockWith { $diskFailurePredictStatusSSD2 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
        mock Get-CimInstance -MockWith { $diskDriveSSD2 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo
        $diskSmartInfo = Get-DiskSmartInfo
    }

    It "Has unknown attribute processed" {
        $diskSmartInfo[0].SmartData | Should -HaveCount 16
        $diskSmartInfo[0].SmartData[15].ID | Should -Be 255
        $diskSmartInfo[0].SmartData[15].IDHex | Should -BeExactly 'FF'
        $diskSmartInfo[0].SmartData[15].Name | Should -BeNullOrEmpty
        $diskSmartInfo[0].SmartData[15].Threshold | Should -Be 1
        $diskSmartInfo[0].SmartData[15].Value | Should -Be 100
        $diskSmartInfo[0].SmartData[15].Worst | Should -Be 100
        $diskSmartInfo[0].SmartData[15].Data | Should -Be 6618611909121
    }
}
