BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "Errors" {

    Context "More that one positional parameter" {

        It "Should throw" {
            { Get-DiskSmartInfo 'value1' 'value2' } | Should -Throw "A positional parameter cannot be found that accepts argument 'value2'."
        }

    }
}
