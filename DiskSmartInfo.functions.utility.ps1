function inTrimDiskDriveModel
{
    Param (
        $Model
    )

    $trimStrings = @(' ATA Device', ' SCSI Disk Device')

    if ($Script:Config.TrimDiskDriveModel)
    {
        foreach ($ts in $trimStrings)
        {
            if ($Model.EndsWith($ts))
            {
                return $Model.Remove($Model.LastIndexOf($ts))
            }
        }
    }

    return $Model
}
