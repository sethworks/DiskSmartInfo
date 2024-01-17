BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "Attributes" {

    Context "Default attributes" {

        It "ID values is equal to IDHex values" {
            InModuleScope DiskSmartInfo {
                foreach ($attribute in $defaultAttributes)
                {
                    $attribute.AttributeIDHex | Should -BeExactly $attribute.AttributeID.ToString("X")
                }
            }
        }
    }

    Context "Overwrite attributes" {

        It "ID values is equal to IDHex values" {
            InModuleScope DiskSmartInfo {
                foreach ($set in $overwrites)
                {
                    foreach ($attribute in $set.Attributes)
                    {
                        $attribute.AttributeIDHex | Should -BeExactly $attribute.AttributeID.ToString("X")
                    }
                }
            }
        }
    }
}

