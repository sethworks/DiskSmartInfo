BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "Get-DiskSmartInfo" {
    It "Should return something" {
        $result = Get-DiskSmartInfo
        $result | Should -BeTrue
    }
}
