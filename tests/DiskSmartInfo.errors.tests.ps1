BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
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

        It "Should return error if non-existent or untrusted host is specified" {
            $e = { Get-DiskSmartInfo $nonExistentHost -ErrorAction Stop } | Should -Throw "ComputerName: `"$nonExistentHost`"*" -PassThru
            $e.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo'
            # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
            # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
        }

        It "Should return error if cim session to non-existent or untrusted host is specified" {
            $cimSession = New-CimSession -ComputerName $nonExistentHost -SkipTestConnection
            $e = { Get-DiskSmartInfo -CimSession $cimSession -ErrorAction Stop } | Should -Throw "ComputerName: `"$nonExistentHost`"*" -PassThru
            $e.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo'
            # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
            # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
        }
    }
}
