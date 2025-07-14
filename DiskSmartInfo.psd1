@{

# Script module or binary module file associated with this manifest.
RootModule = 'DiskSmartInfo.psm1'

# Version number of this module.
ModuleVersion = '2.3'

# Supported PSEditions
CompatiblePSEditions = @('Core', 'Desktop')

# ID used to uniquely identify this module
GUID = '7da6c80e-01da-4c70-98c1-3dc2f877a8ba'

# Author of this module
Author = 'Sergey Vasin'

# Company or vendor of this module
# CompanyName = ''

# Copyright statement for this module
Copyright = '(c) Sergey Vasin. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Get HDD and SSD SMART (Self-Monitoring, Analysis and Reporting Technology) information'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @('formats/DiskSmartInfo.format.ps1xml',
                     'formats/DiskSmartAttribute.format.ps1xml',
                     'formats/DiskSmartAttributeDescription.format.ps1xml')

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @('types/DiskSmartInfo.types.ps1',
                  'functions/DiskSmartInfo.completers.ps1',
                  'functions/DiskSmartInfo.functions.ps1',
                  'functions/DiskSmartAttributeDescription.functions.ps1',
                  'functions/DiskSmartInfo.functions.internal.ps1',
                  'functions/DiskSmartInfo.functions.utility.ps1',
                  'functions/DiskSmartInfo.functions.history.ps1',
                  'functions/DiskSmartInfo.functions.predicates.ps1',
                  'formats/DiskSmartAttributeCustomFormat.data.ps1',
                  'attributes/default.ps1',
                  'attributes/proprietary.ps1',
                  'attributes/descriptions.ps1')

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('Get-DiskSmartInfo', 'Get-DiskSmartAttributeDescription')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = 'DiskSmartInfo.psd1',
           'DiskSmartInfo.psm1',
           'DiskSmartInfo.config.psd1',
           'types/DiskSmartInfo.types.ps1',
           'functions/DiskSmartInfo.completers.ps1',
           'functions/DiskSmartInfo.functions.ps1',
           'functions/DiskSmartAttributeDescription.functions.ps1',
           'functions/DiskSmartInfo.functions.internal.ps1',
           'functions/DiskSmartInfo.functions.utility.ps1',
           'functions/DiskSmartInfo.functions.history.ps1',
           'functions/DiskSmartInfo.functions.predicates.ps1',
           'formats/DiskSmartInfo.format.ps1xml',
           'formats/DiskSmartAttribute.format.ps1xml',
           'formats/DiskSmartAttributeDescription.format.ps1xml',
           'formats/DiskSmartAttributeCustomFormat.data.ps1',
           'attributes/default.ps1',
           'attributes/proprietary.ps1',
           'attributes/descriptions.ps1'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'PSModule'

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/sethworks/DiskSmartInfo'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

