@{
    # Suppress DiskSmartInfo objects with empty SmartData property. The -QuietIfOK parameter always suppresses irrespective of this parameter.
    SuppressEmptySmartData = $true

    # Trim Win32_DiskDrive Model property 'ATA Device' and 'SCSI Disk Device' trailing strings, so that it corresponds to MSFT_Disk and MSFT_PhysicalDisk Model property.
    TrimDiskDriveModel = $true
}