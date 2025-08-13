function Deploy-sthModule
{
    Param(
        [string]$ModuleName,
        [string]$ModulePath
    )

    $Path = Join-Path -Path $ModulePath -ChildPath $ModuleName

    Remove-Item -Path $Path -Recurse -ErrorAction SilentlyContinue -Force
    New-Item -ItemType Directory -Path $Path

    # Files starting with __ (two underlines) are temporary and should not be included in the module
    Copy-Item -Path .\* -Include *.psd1, *.psm1, *.ps1, *.ps1xml -Exclude __* -Destination $Path
    # Copy-Item -Path .\Templates -Exclude __* -Destination $Path -Recurse
    Copy-Item -Path .\attributes -Destination $Path -Exclude __* -Recurse
    Copy-Item -Path .\functions -Destination $Path -Exclude __* -Recurse
    Copy-Item -Path .\formats -Destination $Path -Exclude __* -Recurse
    Copy-Item -Path .\types -Destination $Path -Exclude __* -Recurse
    Copy-Item -Path .\tests -Destination $Path -Exclude __* -Recurse
    Copy-Item -Path .\en-US -Destination $Path -Exclude __* -Recurse
    Copy-Item -Path .\ru-RU -Destination $Path -Exclude __* -Recurse
}

$ModuleName = Split-Path -Path $PSScriptRoot\.. -Leaf

if ($IsWindows)
{
    $ModulePath = 'C:\Program Files\WindowsPowerShell\Modules'
    Deploy-sthModule -ModuleName $ModuleName -ModulePath $ModulePath

    $ModulePath = 'C:\Program Files\PowerShell\Modules'
    Deploy-sthModule -ModuleName $ModuleName -ModulePath $ModulePath
}

elseif ($IsLinux)
{
    $ModulePath = '~/.local/share/powershell/Modules'
    Deploy-sthModule -ModuleName $ModuleName -ModulePath $ModulePath
}
