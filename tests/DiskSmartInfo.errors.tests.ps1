BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "Errors" {

    Context "Positional parameters" {

        It "Should throw on two positional parameters" {

            { Get-DiskSmartInfo 'value1' 'value2' } | Should -Throw -ErrorId 'PositionalParameterNotFound,Get-DiskSmartInfo'
        }
    }

    Context "ComputerName" {

        It "Should return error if non-existent host is specified" {

            { Get-DiskSmartInfo 'non_existent_host' -ErrorAction Stop } | Should -Throw -ErrorId 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo'
        }
    }

    Context "CimSession" {

        It "Should return error if cim session to non-existent host is specified" {

            $cimSession = New-CimSession -ComputerName 'non_existent_host' -SkipTestConnection
            { Get-DiskSmartInfo -CimSession $cimSession -ErrorAction Stop } | Should -Throw -ErrorId 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo'
        }
    }
}
