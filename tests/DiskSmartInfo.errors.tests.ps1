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

        Context "SmartCtl with CIMSession on Windows" -Skip:$IsLinux {

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

        Context "SmartCtl with ComputerName on Windows" -Skip:$IsLinux {

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

        Context "SSHClient with CIM and ComputerName on Windows" -Skip:$IsLinux {

            Context "-Transport SSHClient -Source CIM -ComputerName" {

                It "Should throw an error" {
                    { Get-DiskSmartInfo -Transport SSHClient -Source CIM -ComputerName $computerNames[0]} | Should -Throw 'SSHClient transport does not support CIM source.' -ErrorId 'SSHClient transport does not support CIM source.,Get-DiskSmartInfo'
                }
            }

            Context "Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | -Transport SSHClient -Source CIM -ComputerName" {

                It "Should throw an error" {
                    { $diskDriveHDD1, $diskHDD2, $physicalDiskSSD1 | Get-DiskSmartInfo -Transport SSHClient -Source CIM -ComputerName $computerNames[0] } | Should -Throw 'SSHClient transport does not support CIM source.' -ErrorId 'SSHClient transport does not support CIM source.,Get-DiskSmartInfo'
                }
            }
        }

        Context "SSHClient with ComputerName" -Skip:$IsLinux{

            Context "-Transport SSHClient -ComputerName" {

                It "Should throw an error" {
                    { Get-DiskSmartInfo -Transport SSHClient -ComputerName $computerNames } | Should -Throw 'Source parameter is not specified and its default value is "CIM". SSHClient transport does not support CIM source.' -ErrorId 'Source parameter is not specified and its default value is "CIM". SSHClient transport does not support CIM source.,Get-DiskSmartInfo'
                }
            }

            Context "Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | -Transport SSHClient -ComputerName" {

                It "Should throw an error" {
                    { $diskDriveHDD1, $diskHDD2, $physicalDiskSSD1 | Get-DiskSmartInfo -Transport SSHClient -ComputerName $computerNames } | Should -Throw 'Source parameter is not specified and its default value is "CIM". SSHClient transport does not support CIM source.' -ErrorId 'Source parameter is not specified and its default value is "CIM". SSHClient transport does not support CIM source.,Get-DiskSmartInfo'
                }
            }
        }

        Context "CIMSession on Linux" -Skip:(-not $IsLinux) {

            Context "-Transport CIMSession" {

                It "Should throw an error" {
                    { Get-DiskSmartInfo -Transport CimSession } | Should -Throw 'CIMSession transport is not supported on this platform.' -ErrorId 'CIMSession transport is not supported on this platform.,Get-DiskSmartInfo'
                }
            }

            Context "-Source SmartCtl -Transport CIMSession" {

                It "Should throw an error" {
                    { Get-DiskSmartInfo -Source SmartCtl -Transport CimSession } | Should -Throw 'CIMSession transport is not supported on this platform.' -ErrorId 'CIMSession transport is not supported on this platform.,Get-DiskSmartInfo'
                }
            }

            Context "ComputerName | -Transport CIMSession" {

                It "Should throw an error" {
                    { $computerNames | Get-DiskSmartInfo -Transport CimSession } | Should -Throw 'CIMSession transport is not supported on this platform.' -ErrorId 'CIMSession transport is not supported on this platform.,Get-DiskSmartInfo'
                }
            }

            Context "ComputerName | -Source SmartCtl -Transport CIMSession" {

                It "Should throw an error" {
                    { $computerNames | Get-DiskSmartInfo -Source SmartCtl -Transport CimSession } | Should -Throw 'CIMSession transport is not supported on this platform.' -ErrorId 'CIMSession transport is not supported on this platform.,Get-DiskSmartInfo'
                }
            }
        }

        Context "PSSession on Linux" -Skip:(-not $IsLinux) {

            Context "-Transport PSSession" {

                It "Should throw an error" {
                    { Get-DiskSmartInfo -Transport PSSession} | Should -Throw "PSSession transport is not supported on this platform." -ErrorId 'PSSession transport is not supported on this platform.,Get-DiskSmartInfo'
                }
            }

            Context "-Source SmartCtl -Transport PSSession" {

                It "Should throw an error" {
                    { Get-DiskSmartInfo -Source SmartCtl -Transport PSSession } | Should -Throw 'PSSession transport is not supported on this platform.' -ErrorId 'PSSession transport is not supported on this platform.,Get-DiskSmartInfo'
                }
            }

            Context "ComputerName | -Transport PSSession" {

                It "Should throw an error" {
                    { $computerNames | Get-DiskSmartInfo -Transport PSSession } | Should -Throw 'PSSession transport is not supported on this platform.' -ErrorId 'PSSession transport is not supported on this platform.,Get-DiskSmartInfo'
                }
            }

            Context "ComputerName | -Source SmartCtl -Transport PSSession" {

                It "Should throw an error" {
                    { $computerNames | Get-DiskSmartInfo -Source SmartCtl -Transport PSSession } | Should -Throw 'PSSession transport is not supported on this platform.' -ErrorId 'PSSession transport is not supported on this platform.,Get-DiskSmartInfo'
                }
            }
        }
    }

    Context "Process block restrictions" {

        Context "CIMSession, PSSession, SSHSession | -Source SmartCtl" -Skip:$IsLinux {

            BeforeAll {
                $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]} -Methods @{TestConnection = {$true}}
                $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
                $pssshSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]; Transport = 'SSH'}

                mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

                mock Invoke-Command -MockWith { $true } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue "} -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $false } -ParameterFilter { $ScriptBlock.ToString() -eq ' $IsLinux ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $diskSmartInfo = $cimSessionHost1, $psSessionHost1, $pssshSessionHost1 | Get-DiskSmartInfo -Source SmartCtl -ErrorVariable ev -ErrorAction SilentlyContinue
            }

            It "Should return an error on CIMSession use" {
                $diskSmartInfo | Should -HaveCount 2
                $diskSmartInfo[0].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
                $diskSmartInfo[1].pstypenames[0] | Should -BeExactly 'DiskSmartInfo'

                $ev | Should -HaveCount 1
                $ev.Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": CIMSession only supports CIM source."
                $ev.FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": CIMSession only supports CIM source.,Get-DiskSmartInfo"
            }
        }

        Context "ComputerName, Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | -Source SmartCtl" -Skip:$IsLinux {

            BeforeAll {
                $diskSmartInfo = $computerNames, $diskDriveHost1, $diskHost1, $physicalDiskHost1 | Get-DiskSmartInfo -Source SmartCtl -ErrorVariable ev -ErrorAction SilentlyContinue
            }

            It "Should return an error on ComputerName use" {
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

        Context "ComputerName, Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk, CIMSession, PSSession, SSHSession | -Source SmartCtl" -Skip:$IsLinux {

            BeforeAll {
                $cimSessionHost1 = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' -Properties @{ComputerName = $computerNames[0]} -Methods @{TestConnection = {$true}}
                $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
                $pssshSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]; Transport = 'SSH'}

                mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

                mock Invoke-Command -MockWith { $true } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue "} -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $false } -ParameterFilter { $ScriptBlock.ToString() -eq ' $IsLinux ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $diskSmartInfo = $computerNames, $diskDriveHost1, $diskHost1, $physicalDiskHost1, $cimSessionHost1, $psSessionHost1, $pssshSessionHost1 | Get-DiskSmartInfo -Source SmartCtl -ErrorVariable ev -ErrorAction SilentlyContinue
            }

            It "Should return an error on ComputerName use" {
                $diskSmartInfo | Should -HaveCount 2
                $ev | Should -HaveCount 6

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

                $ev[5].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": CIMSession only supports CIM source."
                $ev[5].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": CIMSession only supports CIM source.,Get-DiskSmartInfo"
            }
        }

        Context "ComputerName, Win32_DiskDrive, MSFT_Disk, MSFT_PhysicalDisk | -Transport SSHClient" -Skip:$IsLinux {

            BeforeAll {
                $diskSmartInfo = $computerNames, $diskDriveHost1, $diskHost1, $physicalDiskHost1 | Get-DiskSmartInfo -Transport SSHClient -ErrorVariable ev -ErrorAction SilentlyContinue
            }

            It "Should return an error on ComputerName use" {
                $diskSmartInfo | Should -BeNullOrEmpty
                $ev | Should -HaveCount 5

                $ev[0].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": SSHClient transport does not support CIM source."
                $ev[0].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": SSHClient transport does not support CIM source.,Get-DiskSmartInfo"

                $ev[1].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[1])"": SSHClient transport does not support CIM source."
                $ev[1].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[1])"": SSHClient transport does not support CIM source.,Get-DiskSmartInfo"

                $ev[2].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": SSHClient transport does not support CIM source."
                $ev[2].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": SSHClient transport does not support CIM source.,Get-DiskSmartInfo"

                $ev[3].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": SSHClient transport does not support CIM source."
                $ev[3].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": SSHClient transport does not support CIM source.,Get-DiskSmartInfo"

                $ev[4].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": SSHClient transport does not support CIM source."
                $ev[4].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": SSHClient transport does not support CIM source.,Get-DiskSmartInfo"
            }
        }

        Context "SSHClient with CIM on Linux" -Skip:(-not $IsLinux) {

            Context "-Transport SSHClient -Source CIM" {

                It "Should return an error" {
                    $diskSmartInfo = Get-DiskSmartInfo -Transport SSHClient -Source CIM -ErrorVariable ev -ErrorAction SilentlyContinue

                    $ev[0].Exception.Message | Should -BeExactly "CIM source is not supported on this platform."
                    $ev[0].FullyQualifiedErrorId | Should -BeExactly "CIM source is not supported on this platform.,Get-DiskSmartInfo"
                }
            }

            Context "ComputerName | -Transport SSHClient -Source CIM" {

                It "Should return an error" {
                    $diskSmartInfo = $computerNames | Get-DiskSmartInfo -Transport SSHClient -Source CIM -ErrorVariable ev -ErrorAction SilentlyContinue

                    $ev[0].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[0])"": SSHClient transport does not support CIM source."
                    $ev[0].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[0])"": SSHClient transport does not support CIM source.,Get-DiskSmartInfo"

                    $ev[1].Exception.Message | Should -BeExactly "ComputerName: ""$($computerNames[1])"": SSHClient transport does not support CIM source."
                    $ev[1].FullyQualifiedErrorId | Should -BeExactly "ComputerName: ""$($computerNames[1])"": SSHClient transport does not support CIM source.,Get-DiskSmartInfo"
                }
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

        Context "Remote queries" {

            Context "PSSession" -Skip:$IsLinux {

                BeforeAll {
                    $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
                    $psSessionHost2 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[1]}
                    mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
                    mock New-PSSession -MockWith { $psSessionHost2 } -ParameterFilter {$ComputerName -eq $computerNames[1]} -ModuleName DiskSmartInfo
                    mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

                    mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue " -and $Session.ComputerName -eq $computerNames[0] } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $true } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue " -and $Session.ComputerName -eq $computerNames[1] } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $false } -ParameterFilter { $ScriptBlock.ToString() -eq ' $IsLinux ' } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                    $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames -Source SmartCtl -Transport PSSession -ErrorVariable ev -ErrorAction SilentlyContinue
                }

                It "Should return an error" {
                    $diskSmartInfo | Should -HaveCount 1
                    $ev | Should -HaveCount 1
                }
            }

            Context "SSHSession" -Skip:(-not $IsCoreCLR) {

                BeforeAll {

                    $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]; Transport = 'SSH'}
                    $psSessionHost2 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[1]; Transport = 'SSH'}
                    mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$HostName -eq $computerNames[0]} -ModuleName DiskSmartInfo
                    mock New-PSSession -MockWith { $psSessionHost2 } -ParameterFilter {$HostName -eq $computerNames[1]} -ModuleName DiskSmartInfo
                    mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

                    mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue " -and $Session.ComputerName -eq $computerNames[0] } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $true } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue " -and $Session.ComputerName -eq $computerNames[1] } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $true } -ParameterFilter { $ScriptBlock.ToString() -eq ' $IsLinux ' } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                    mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "sudo smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                    $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames -Source SmartCtl -Transport SSHSession -ErrorVariable ev -ErrorAction SilentlyContinue
                }

                It "Should return an error" {
                    $diskSmartInfo | Should -HaveCount 1
                    $ev | Should -HaveCount 1
                }
            }
        }
    }

    Context "Notifications" -Skip:$IsLinux {

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

        Context "Credential with SSHClient transport" {

            BeforeAll {
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "ssh $($computerNames[0]) smartctl --scan" } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "ssh $($computerNames[0]) smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $Credential = [PSCredential]::new('UserName', (ConvertTo-SecureString -String 'Password' -AsPlainText -Force))
                $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames[0] -Transport SSHClient -Source SmartCtl -Credential $Credential -WarningVariable w -WarningAction SilentlyContinue
            }

            It "Should issue a warning" {
                $diskSmartInfo | Should -HaveCount 1
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
                $w | Should -BeExactly 'The -Credential parameter is not used with SSHClient transport.'
            }
        }

        Context "SSHClientSudo with any other but SSHClient transport" {

            BeforeAll {
                $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
                mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
                mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

                mock Invoke-Command -MockWith { $true } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue "} -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $false } -ParameterFilter { $ScriptBlock.ToString() -eq ' $IsLinux ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames[0] -Transport PSSession -Source SmartCtl -SSHClientSudo -WarningVariable w -WarningAction SilentlyContinue
            }

            It "Should issue a warning" {
                $diskSmartInfo | Should -HaveCount 1
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
                $w | Should -BeExactly 'The -SSHClientSudo parameter is only used with SSHClient transport.'
            }
        }

        Context "SSHClientOption with any other but SSHClient transport" {

            BeforeAll {
                $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
                mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
                mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

                mock Invoke-Command -MockWith { $true } -ParameterFilter { $ScriptBlock.ToString() -eq " Get-Command -Name 'smartctl' -ErrorAction SilentlyContinue "} -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $false } -ParameterFilter { $ScriptBlock.ToString() -eq ' $IsLinux ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $testDataCtl.CtlScan_HDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq " smartctl --scan " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $ctlDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq "smartctl --info --health --attributes /dev/sda" } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames[0] -Transport PSSession -Source SmartCtl -SSHClientOption '-o AddressFamily=inet' -WarningVariable w -WarningAction SilentlyContinue
            }

            It "Should issue a warning" {
                $diskSmartInfo | Should -HaveCount 1
                $diskSmartInfo.pstypenames[0] | Should -BeExactly 'DiskSmartInfo'
                $w | Should -BeExactly 'The -SSHClientOption parameter is only used with SSHClient transport.'
            }
        }

        Context "SmartCtlOption with any other but SmartCtl source" {

            BeforeAll {
                $psSessionHost1 = New-MockObject -Type 'System.Management.Automation.Runspaces.PSSession' -Properties @{ComputerName = $computerNames[0]}
                mock New-PSSession -MockWith { $psSessionHost1 } -ParameterFilter {$ComputerName -eq $computerNames[0]} -ModuleName DiskSmartInfo
                mock Remove-PSSession -MockWith { } -ModuleName DiskSmartInfo

                mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq " `$errorParameters = @{ ErrorVariable = 'instanceErrors'; ErrorAction = 'SilentlyContinue' } " } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $diskSmartDataHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classSmartData @errorParameters ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $diskThresholdsHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classThresholds @errorParameters ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $diskFailurePredictStatusHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -Namespace $Using:namespaceWMI -ClassName $Using:classFailurePredictStatus @errorParameters ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $diskDriveHDD1 } -ParameterFilter { $ScriptBlock.ToString() -eq ' Get-CimInstance -ClassName $Using:classDiskDrive @errorParameters ' } -ModuleName DiskSmartInfo
                mock Invoke-Command -MockWith { $null } -ParameterFilter { $ScriptBlock.ToString() -eq ' $instanceErrors ' } -ModuleName DiskSmartInfo

                $diskSmartInfo = Get-DiskSmartInfo -ComputerName $computerNames[0] -Transport PSSession -Source CIM -SmartCtlOption '-d ata' -WarningVariable w -WarningAction SilentlyContinue
            }

            It "Should issue a warning" {
                $w | Should -BeExactly 'The -SmartCtlOption parameter is only used with SmartCtl source.'
            }
        }
    }

    Context "Nonexistent host" -Skip:$IsLinux {

        Context "CIM" {

            BeforeAll {
                $nonexistentHost = 'nonexistent_host'
            }

            It "Should return an error if nonexistent or untrusted host is specified" {
                $e = { Get-DiskSmartInfo -ComputerName $nonexistentHost -ErrorAction Stop } | Should -Throw "ComputerName: `"$nonexistentHost`"*" -PassThru
                $e.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo'
                # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
                # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
            }

            It "Should return an error if cim session to nonexistent or untrusted host is specified" {
                $cimSession = New-CimSession -ComputerName $nonexistentHost -SkipTestConnection
                $e = { Get-DiskSmartInfo -CimSession $cimSession -ErrorAction Stop } | Should -Throw "ComputerName: `"$nonexistentHost`"*" -PassThru
                $e.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo'
                # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
                # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
            }
        }

        Context "PSSession" {

            BeforeAll {
                $nonexistentHost = 'nonexistent_host'
                $wrongHost = 'wrong@host'
            }

            It "Should return an error if nonexistent or untrusted host is specified" {
                $e = { Get-DiskSmartInfo -ComputerName $nonexistentHost -Transport PSSession -ErrorAction Stop } | Should -Throw "ComputerName: `"$nonexistentHost`"*" -PassThru
                $e.FullyQualifiedErrorId | Should -BeIn 'ComputerNotFound,PSSessionOpenFailed,Get-DiskSmartInfo', 'ServerNotTrusted,PSSessionOpenFailed,Get-DiskSmartInfo'
            }

            It "Should return an error if wrong hostname is specified" {
                $e = { Get-DiskSmartInfo -ComputerName $wrongHost -Transport PSSession -ErrorAction Stop } | Should -Throw "ComputerName: `"$wrongHost`"*" -PassThru
                $e.FullyQualifiedErrorId | Should -Be 'PSSessionInvalidComputerName,Microsoft.PowerShell.Commands.NewPSSessionCommand,Get-DiskSmartInfo'
            }
        }
    }

    Context "Error variable" -Skip:$IsLinux {

        Context "CIM" {

            BeforeAll {
                $nonexistentHost = 'nonexistent_host'
            }

            It "Should contain an error if nonexistent or untrusted host is specified" {
                Get-DiskSmartInfo -ComputerName $nonexistentHost -ErrorVariable ev -ErrorAction SilentlyContinue | Out-Null
                $ev | Should -HaveCount 1
                $ev.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.NewCimSessionCommand,Get-DiskSmartInfo'
                # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
                # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
            }

            It "Should contain an error if cim session to nonexistent or untrusted host is specified" {
                $cimSession = New-CimSession -ComputerName $nonexistentHost -SkipTestConnection
                Get-DiskSmartInfo -CimSession $cimSession -ErrorVariable ev -ErrorAction SilentlyContinue | Out-Null
                $ev | Should -HaveCount 1
                $ev.FullyQualifiedErrorId | Should -BeIn 'HRESULT 0x803380e4,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo', 'HRESULT 0x803381b9,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand,Get-DiskSmartInfo'
                # HRESULT 0x803380e4: ERROR_WSMAN_SERVER_NOT_TRUSTED
                # HRESULT 0x803381b9: ERROR_WSMAN_NAME_NOT_RESOLVED
            }
        }

        Context "PSSession" {

            BeforeAll {
                $nonexistentHost = 'nonexistent_host'
                $wrongHost = 'wrong@host'
            }

            It "Should contain an error if nonexistent or untrusted host is specified" {
                Get-DiskSmartInfo -ComputerName $nonexistentHost -Transport PSSession -ErrorVariable ev -ErrorAction SilentlyContinue | Out-Null
                $ev | Should -HaveCount 1
                $ev.FullyQualifiedErrorId | Should -BeIn 'ComputerNotFound,PSSessionOpenFailed,Get-DiskSmartInfo', 'ServerNotTrusted,PSSessionOpenFailed,Get-DiskSmartInfo'
            }

            It "Should contain an error if wrong hostname is specified" {
                Get-DiskSmartInfo -ComputerName $wrongHost -Transport PSSession -ErrorVariable ev -ErrorAction SilentlyContinue | Out-Null
                $ev | Should -HaveCount 1
                $ev.FullyQualifiedErrorId | Should -Be 'PSSessionInvalidComputerName,Microsoft.PowerShell.Commands.NewPSSessionCommand,Get-DiskSmartInfo'
            }
        }
    }
}
