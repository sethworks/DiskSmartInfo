BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"

    . $PSScriptRoot\testEnvironment.ps1
}

Describe "Errors" {

    Context "Positional parameters" {

        BeforeAll {
            $ComputerName = 'Host1'
            $Credential = [PSCredential]::new('UserName', (ConvertTo-SecureString -String 'Password' -AsPlainText -Force))
        }

        It "Should throw on three positional parameters" {
            { Get-DiskSmartInfo $ComputerName $Credential 'value3' } | Should -Throw "A positional parameter cannot be found that accepts argument 'value3'." -ErrorId 'PositionalParameterNotFound,Get-DiskSmartInfo'
        }
    }

    Context "Credential without ComputerName" {

        BeforeAll {
            mock Get-CimInstance -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classSmartData } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classThresholds } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $Namespace -eq $namespaceWMI -and $ClassName -eq $classFailurePredictStatus } -ModuleName DiskSmartInfo
            mock Get-CimInstance -MockWith { $diskDriveHDD1 } -ParameterFilter { $ClassName -eq $classDiskDrive } -ModuleName DiskSmartInfo

            $Credential = [PSCredential]::new('UserName', (ConvertTo-SecureString -String 'Password' -AsPlainText -Force))
            $diskSmartInfo = Get-DiskSmartInfo -Credential $Credential -WarningVariable w -WarningAction SilentlyContinue
        }

        It "Should issue a warning" {
            $w | Should -BeExactly 'The -Credential parameter is used only for connecting to computers, listed or bound to the -ComputerName parameter.'
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

    Context "Error variable" {

        BeforeAll {
            $nonExistentHost = 'non_existent_host'
        }

        It "Should contain error if non-existent or untrusted host is specified" {
            Get-DiskSmartInfo $nonExistentHost -ErrorVariable ev -ErrorAction SilentlyContinue | Out-Null
            $ev | Should -HaveCount 1
            $ev.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo'
            # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
            # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
        }

        It "Should contain error if cim session to non-existent or untrusted host is specified" {
            $cimSession = New-CimSession -ComputerName $nonExistentHost -SkipTestConnection
            Get-DiskSmartInfo -CimSession $cimSession -ErrorVariable ev -ErrorAction SilentlyContinue | Out-Null
            $ev | Should -HaveCount 1
            $ev.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo'
            # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
            # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
        }
    }
}
