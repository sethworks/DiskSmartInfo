BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "DiskSmartAttributeDescription" {

    Context "Get-DiskSmartAttributeDescription" {

        Context "Without parameters" {

            BeforeAll {
                $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription
            }

            It "Has 81 attributes" {
                $diskSmartAttributeDescription | Should -HaveCount 81
            }

            It "Has correct attributes" {
                $diskSmartAttributeDescription[0].AttributeID | Should -Be 1
                $diskSmartAttributeDescription[35].AttributeIDHex | Should -BeExactly 'C0'
                $diskSmartAttributeDescription[2].AttributeName | Should -BeExactly 'Spin-Up Time'
                $diskSmartAttributeDescription[42].BetterValue | Should -BeExactly 'Low'
                $diskSmartAttributeDescription[44].IsCritical | Should -BeExactly $true
                $diskSmartAttributeDescription[45].IsCritical | Should -BeNullOrEmpty
                $diskSmartAttributeDescription[63].Description | Should -BeExactly 'Count of attempts to compensate for platter speed variations.'
            }
        }

        Context "-AttributeID" {
            BeforeAll {
                $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription -AttributeID 190
            }

            It "Has correct attribute" {
                $diskSmartAttributeDescription.AttributeName | Should -BeExactly 'Temperature Difference'
            }
        }

        Context "-AttributeID without parameter name" {
            BeforeAll {
                $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription 190
            }

            It "Has correct attribute" {
                $diskSmartAttributeDescription.AttributeName | Should -BeExactly 'Temperature Difference'
            }
        }

        Context "-AttributeIDHex" {
            BeforeAll {
                $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription -AttributeIDHex C1
            }

            It "Has correct attribute" {
                $diskSmartAttributeDescription.AttributeName | Should -BeExactly 'Load Cycle Count'
            }
        }

        Context "-CriticalOnly" {
            BeforeAll {
                $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription -CriticalOnly
            }

            It "Has 9 attributes" {
                $diskSmartAttributeDescription | Should -HaveCount 9
            }

            It "Has critical attributes only" {
                $diskSmartAttributeDescription.IsCritical | Get-Unique | Should -BeExactly $true
            }
        }
    }
}
