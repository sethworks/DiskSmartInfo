function TrimDiskDriveModel
{
    Param (
        $Model
    )

    return $Model.TrimEnd('ATA Device').TrimEnd('SCSI Disk Device')
}
