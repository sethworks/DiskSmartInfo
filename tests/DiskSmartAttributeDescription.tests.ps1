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

            It "Has 82 attributes" {
                $diskSmartAttributeDescription | Should -HaveCount 82
            }

            It "Has correct attributes" {
                $diskSmartAttributeDescription[0].AttributeID | Should -Be 1
                $diskSmartAttributeDescription[38].AttributeIDHex | Should -BeExactly 'C2'
                $diskSmartAttributeDescription[2].AttributeName | Should -BeExactly 'Spin-Up Time'
                $diskSmartAttributeDescription[28].BetterValue | Should -BeExactly 'Low'
                $diskSmartAttributeDescription[45].IsCritical | Should -BeExactly $true
                $diskSmartAttributeDescription[48].IsCritical | Should -BeExactly $false
                $diskSmartAttributeDescription[81].Description | Should -BeExactly 'Count of "Free Fall Events" detected.'
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
