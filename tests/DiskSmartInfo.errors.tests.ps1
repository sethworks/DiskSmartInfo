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

    Context "Restrictions" {

        Context "SSHSession in Windows PowerShell 5.1" -Skip:($IsCoreCLR) {

            BeforeAll {
                $ComputerName = 'Host1'
            }

            It "Should throw an error" {
                { Get-DiskSmartInfo -ComputerName $ComputerName -Transport SSHSession } | Should -Throw "PSSession with SSH transport is not supported in Windows PowerShell 5.1 and earlier." -ErrorId 'PSSession with SSH transport is not supported in Windows PowerShell 5.1 and earlier.,Get-DiskSmartInfo'
            }
        }
    }

    Context "Notifications" {

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

        Context "Credential with SSHSession transport" -Skip:(-not ($IsCoreCLR -and $IsWindows)) {

            BeforeAll {
                $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]; Transport = 'SSH'}
                mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$HostName -eq $computerNames[0]} -ModuleName DiskSmartInfo
                mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

                mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq " `$errorParameters = @{ ErrorVariable = 'instanceErrors'; ErrorAction = 'SilentlyContinue' } " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classSmartData @errorParameters ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classThresholds @errorParameters ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classFailurePredictStatus @errorParameters ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $diskDriveHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -ClassName $Using:classDiskDrive @errorParameters ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq ' $instanceErrors ' } -ModuleName DiskSmartInfo

                $Credential = [PSCredential]::new('UserName', (ConvertTo-SecureString -String 'Password' -AsPlainText -Force))
                $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames[0] -Transport SSHSession -Credential $Credential -WarningVariable w -WarningAction SilentlyContinue
            }

            It "Should issue a warning" {
                $diskSmartInfo | Should -HaveCount 1
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
                $w | Should -BeExactly 'The -Credential parameter is not used with SSHSession transport.'
            }
        }
    }

    Context "Nonexistent host" {

        BeforeAll {
            $nonexistentHost = 'nonexistent_host'
        }

        It "Should return error if nonexistent or untrusted host is specified" {
            $e = { Get-DiskSmartInfo $nonexistentHost -ErrorAction Stop } | Should -Throw "ComputerName: `"$nonexistentHost`"*" -PassThru
            $e.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo'
            # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
            # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
        }

        It "Should return error if cim session to nonexistent or untrusted host is specified" {
            $cimSession = New-CimSession -ComputerName $nonexistentHost -SkipTestConnection
            $e = { Get-DiskSmartInfo -CimSession $cimSession -ErrorAction Stop } | Should -Throw "ComputerName: `"$nonexistentHost`"*" -PassThru
            $e.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo'
            # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
            # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
        }
    }

    Context "Error variable" {

        BeforeAll {
            $nonexistentHost = 'nonexistent_host'
        }

        It "Should contain error if nonexistent or untrusted host is specified" {
            Get-DiskSmartInfo $nonexistentHost -ErrorVariable ev -ErrorAction SilentlyContinue | Out-Null
            $ev | Should -HaveCount 1
            $ev.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo'
            # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
            # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
        }

        It "Should contain error if cim session to nonexistent or untrusted host is specified" {
            $cimSession = New-CimSession -ComputerName $nonexistentHost -SkipTestConnection
            Get-DiskSmartInfo -CimSession $cimSession -ErrorVariable ev -ErrorAction SilentlyContinue | Out-Null
            $ev | Should -HaveCount 1
            $ev.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo'
            # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
            # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
        }
    }
}
