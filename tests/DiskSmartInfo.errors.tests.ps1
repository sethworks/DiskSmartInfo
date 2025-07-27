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

        Context "SmartCtl with CIMSession" {

            Context "-Source SmartCtl -CIMSession" {

                BeforeAll {
                    $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]} -Methods @{TestConnection = {$true}}
                }

                It "Should throw an error" {
                    { Get-DiskSmartInfo -Source SmartCtl -CimSession $cimSessionHost1 } | Should -Throw 'CIMSession transport only supports CIM source.' -ErrorId 'CIMSession transport only supports CIM source.,Get-DiskSmartInfo'
                }
            }

            Context "Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | -Source SmartCtl -CIMSession" {

                BeforeAll {
                    $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]} -Methods @{TestConnection = {$true}}
                }

                It "Should throw an error" {
                    { $diskDriveHDD1, $diskHDD2, $physicalDiskSSD1 | Get-DiskSmartInfo -Source SmartCtl -CimSession $cimSessionHost1 } | Should -Throw 'CIMSession transport only supports CIM source.' -ErrorId 'CIMSession transport only supports CIM source.,Get-DiskSmartInfo'
                }
            }

            Context "-Source SmartCtl -Transport CIMSession" {

                It "Should throw an error" {
                    { Get-DiskSmartInfo -Source SmartCtl -Transport CimSession } | Should -Throw 'CIMSession transport only supports CIM source.' -ErrorId 'CIMSession transport only supports CIM source.,Get-DiskSmartInfo'
                }
            }

            Context "ComputerName, Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | -Source SmartCtl -Transport CIMSession" {

                It "Should throw an error" {
                    { $computerNames[0], $diskDriveHDD1, $diskHDD2, $physicalDiskSSD1 | Get-DiskSmartInfo -Source SmartCtl -Transport CimSession } | Should -Throw 'CIMSession transport only supports CIM source.' -ErrorId 'CIMSession transport only supports CIM source.,Get-DiskSmartInfo'
                }
            }
        }

        Context "SmartCtl with ComputerName" {

            Context "-Source SmartCtl -ComputerName" {

                It "Should throw an error" {
                    { Get-DiskSmartInfo -Source SmartCtl -ComputerName $computerNames } | Should -Throw 'Transport parameter is not specified and its default value is "CIMSession". CIMSession transport only supports CIM source.' -ErrorId 'Transport parameter is not specified and its default value is "CIMSession". CIMSession transport only supports CIM source.,Get-DiskSmartInfo'
                }
            }

            Context "Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | -Source SmartCtl -ComputerName" {

                It "Should throw an error" {
                    { $diskDriveHDD1, $diskHDD2, $physicalDiskSSD1 | Get-DiskSmartInfo -Source SmartCtl -ComputerName $computerNames } | Should -Throw 'Transport parameter is not specified and its default value is "CIMSession". CIMSession transport only supports CIM source.' -ErrorId 'Transport parameter is not specified and its default value is "CIMSession". CIMSession transport only supports CIM source.,Get-DiskSmartInfo'
                }
            }
        }
    }

    Context "Process restrictions" {

        Context "CIMSession, PSSession, SSHSession | -Source SmartCtl" -Skip {

            BeforeAll {
                $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]} -Methods @{TestConnection = {$true}}
                $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
                $pssshSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]; Transport = 'SSH'}

                $diskSmartInfo = $cimSessionHost1, $psSessionHost1, $pssshSessionHost1 | Get-DiskSmartInfo -Source SmartCtl -ErrorVariable ev -ErrorAction SilentlyContinue
            }

            It "Should return error on CIMSession use" {
                $diskSmartInfo | Should -HaveCount 2
                $ev | Should -HaveCount 1
            }
        }

        Context "ComputerName, Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | -Source SmartCtl" {

            BeforeAll {
                $diskSmartInfo = $computerNames, $diskDriveHost1, $diskHost1, $physicalDiskHost1 | Get-DiskSmartInfo -Source SmartCtl -ErrorVariable ev -ErrorAction SilentlyContinue
            }

            It "Should return error on ComputerName use" {
                $diskSmartInfo | Should -BeNullOrEmpty
                $ev | Should -HaveCount 5

                $ev[0].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source."
                $ev[0].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source.,Get-DiskSmartInfo"

                $ev[1].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[1])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source."
                $ev[1].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[1])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source.,Get-DiskSmartInfo"

                $ev[2].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source."
                $ev[2].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source.,Get-DiskSmartInfo"

                $ev[3].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source."
                $ev[3].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source.,Get-DiskSmartInfo"

                $ev[4].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source."
                $ev[4].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source.,Get-DiskSmartInfo"
            }
        }

        Context "ComputerName, Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk, CIMSession, PSSession, SSHSession | -Source SmartCtl" -Skip {

            BeforeAll {
                $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]} -Methods @{TestConnection = {$true}}
                $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
                $pssshSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]; Transport = 'SSH'}

                $diskSmartInfo = $computerNames, $diskDriveHost1, $diskHost1, $physicalDiskHost1, $cimSessionHost1, $psSessionHost1, $pssshSessionHost1 | Get-DiskSmartInfo -Source SmartCtl -ErrorVariable ev -ErrorAction SilentlyContinue
            }

            It "Should return error on ComputerName use" {
                $diskSmartInfo | Should -HaveCount 2
                $ev | Should -HaveCount 5

                $ev[0].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source."
                $ev[0].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source.,Get-DiskSmartInfo"

                $ev[1].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[1])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source."
                $ev[1].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[1])"": Transport parameter is not specified and its default value is ""CIMSession"". CIMSession transport only supports CIM source.,Get-DiskSmartInfo"
            }
        }
    }

    Context "SmartCtl utility existence" {

        Context "Local query" {

            BeforeAll {
                mock Get-Command -MockWith { $null } -ParameterFilter {$Name -eq 'smartctl'} -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -Source SmartCtl -ErrorVariable ev -ErrorAction SilentlyContinue
            }

            It "Should return an error" {
                $diskSmartInfo | Should -BeNullOrEmpty
                $ev | Should -HaveCount 1

                $ev.Exception.Message | Should -BeExactly 'SmartCtl utility is not found.'
                $ev.FullyQualifiedErrorId | Should -BeExactly 'SmartCtl utility is not found.,Get-DiskSmartInfo'
            }
        }

        Context "Remote queries" -Skip {

            BeforeAll {
                $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
                $psSessionHost2 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[1]}
                mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
                mock New-PSSession -MockWith { $psSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
                mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

                mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue " -and $Session.ComputerName -eq $computerNames[0] } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames -Source SmartCtl -Transport PSSession -ErrorVariable ev -ErrorAction SilentlyContinue
            }

            It "Should return an error" {
                $diskSmartInfo | Should -HaveCount 1
                $ev | Should -HaveCount 1
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
