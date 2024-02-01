@{
    # Suppress DiskSmartInfo objects with empty SmartData property. The -Quiet parameter always suppresses irrespective of this parameter.
    SuppressEmptySmartData = $true

    # Trim Win32_DiskDrive Model property 'ATA Device' and 'SCSI Disk Device' trailing strings, so that it corresponds to MSFT_Disk and MSFT_PhysicalDisk Model property.
    TrimDiskDriveModel = $true

    # Path to save attributes' historical data. If not absolute, it is relative to module folder.
    HistoricalDataPath = 'history'

    # Show historical data for all attributes. If false, show only historical data, that differ from actual.
    ShowUnchangedHistoricalData = $true
}