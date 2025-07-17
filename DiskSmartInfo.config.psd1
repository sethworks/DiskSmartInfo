# Module configuration parameters

@{
    # Suppress DiskSmartInfo objects with empty SmartData property.
    # The -Quiet parameter always suppresses such objects irrespective of this parameter.
    SuppressResultsWithEmptySmartData = $true

    # Trim Win32_DiskDrive Model property 'ATA Device' and 'SCSI Disk Device' trailing suffix,
    # so that it corresponds to MSFT_Disk and MSFT_PhysicalDisk Model property.
    TrimDiskDriveModelSuffix = $true

    # Path to save attributes' historical data. If not absolute, it is relative to module folder.
    DataHistoryPath = 'history'

    # Show historical data for all attributes. If false, show only historical data, that differ from actual.
    ShowUnchangedDataHistory = $true

    # Path to archive. If not absolute, it is relative to module folder.
    ArchivePath = 'archive'
}

# Module configuration parameters are applied during the import of the module.
# To update module configuration parameters, reimport the module with the -Force parameter.
