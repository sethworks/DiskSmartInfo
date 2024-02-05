BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "Errors" {

    Context "Positional parameters" {

        It "Should throw on two positional parameters" {

            { Get-DiskSmartInfo 'value1' 'value2' } | Should -Throw "A positional parameter cannot be found that accepts argument 'value2'." -ErrorId 'PositionalParameterNotFound,Get-DiskSmartInfo'
        }
    }

    Context "Non-existent host" {

        BeforeAll {
            $nonExistentHost = 'non_existent_host'
        }

        It "Should return error if non-existent host is specified" {

            { Get-DiskSmartInfo $nonExistentHost -ErrorAction Stop } | Should -Throw "ComputerName: `"$nonExistentHost`"*" -ErrorId 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo'
        }

        It "Should return error if cim session to non-existent host is specified" {

            $cimSession = New-CimSession -ComputerName $nonExistentHost -SkipTestConnection
            { Get-DiskSmartInfo -CimSession $cimSession -ErrorAction Stop } | Should -Throw "ComputerName: `"$nonExistentHost`"*" -ErrorId 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo'
        }
    }
}
