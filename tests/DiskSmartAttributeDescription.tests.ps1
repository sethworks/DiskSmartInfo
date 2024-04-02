BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "Get-DiskSmartAttributeDescription" {

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
            $diskSmartAttributeDescription[81].Description | Should -BeExactly 'Count of "Free Fall Events" detected.'
        }
    }

    Context "-AttributeID" {

        BeforeAll {
            $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription -AttributeID 190
        }

        It "Has correct attribute" {
            $diskSmartAttributeDescription.AttributeName | Should -BeExactly 'Airflow Temperature Celsius'
        }
    }

    Context "-AttributeID without parameter name" {

        BeforeAll {
            $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription 190
        }

        It "Has correct attribute" {
            $diskSmartAttributeDescription.AttributeName | Should -BeExactly 'Airflow Temperature Celsius'
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

    Context "-AttributeName" {

        BeforeAll {
            $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription -AttributeName 'Power-On Hours'
        }

        It "Has correct attribute" {
            $diskSmartAttributeDescription.AttributeName | Should -BeExactly 'Power-On Hours'
        }
    }

    Context "AttributeName wildcards" {

        It "Has correct attribute" {
            $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription -AttributeName '*put*'

            $diskSmartAttributeDescription | Should -HaveCount 1
            $diskSmartAttributeDescription.AttributeName | Should -BeExactly 'Throughput Performance'
        }

        It "Has correct attributes" {
            $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription -AttributeName 'r*'

            $diskSmartAttributeDescription | Should -HaveCount 9
            $diskSmartAttributeDescription[0].AttributeName | Should -BeExactly 'Raw Read Error Rate'
            $diskSmartAttributeDescription[8].AttributeName | Should -BeExactly 'Read Error Retry Rate'
        }
    }

    Context "Nonexistent attributes" {

        BeforeAll {
            $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription -AttributeName '*SomeNonexistentAttribute*'
        }

        It "Has empty result" {
            $diskSmartAttributeDescription | Should -BeNullOrEmpty
        }
    }

    Context "-AttributeID -AttributeIDHex -AttributeName" {

        BeforeAll {
            $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription -AttributeID 1, 2 -AttributeIDHex 'A', 'C8' -AttributeName 'Soft ECC correction', 'Offline Seek Performance'
        }

        It "Has correct results count" {
            $diskSmartAttributeDescription | Should -HaveCount 6
        }

        It "Has correct attributes" {
            $diskSmartAttributeDescription[0].AttributeName | Should -BeExactly 'Raw Read Error Rate'
            $diskSmartAttributeDescription[1].AttributeName | Should -BeExactly 'Throughput Performance'
            $diskSmartAttributeDescription[2].AttributeName | Should -BeExactly 'Spin Retry Count'
            $diskSmartAttributeDescription[3].AttributeName | Should -BeExactly 'Multi-Zone Error Rate'
            $diskSmartAttributeDescription[4].AttributeName | Should -BeExactly 'Soft ECC correction'
            $diskSmartAttributeDescription[5].AttributeName | Should -BeExactly 'Offline Seek Performance'
        }
    }

    Context "-AttributeID -AttributeIDHex -AttributeName without parameter names" {

        BeforeAll {
            $diskSmartAttributeDescription = Get-DiskSmartAttributeDescription 1, 2 'A', 'C8' 'Soft ECC correction', 'Offline Seek Performance'
        }

        It "Has correct results count" {
            $diskSmartAttributeDescription | Should -HaveCount 6
        }

        It "Has correct attributes" {
            $diskSmartAttributeDescription[0].AttributeName | Should -BeExactly 'Raw Read Error Rate'
            $diskSmartAttributeDescription[1].AttributeName | Should -BeExactly 'Throughput Performance'
            $diskSmartAttributeDescription[2].AttributeName | Should -BeExactly 'Spin Retry Count'
            $diskSmartAttributeDescription[3].AttributeName | Should -BeExactly 'Multi-Zone Error Rate'
            $diskSmartAttributeDescription[4].AttributeName | Should -BeExactly 'Soft ECC correction'
            $diskSmartAttributeDescription[5].AttributeName | Should -BeExactly 'Offline Seek Performance'
        }
    }
}
