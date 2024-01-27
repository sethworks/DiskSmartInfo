function TrimDiskDriveModel
{
    Param (
        $Model
    )

    # return $Model.TrimEnd('ATA Device').TrimEnd('SCSI Disk Device')
    $trimStrings = @(' ATA Device', ' SCSI Disk Device')

    foreach ($ts in $trimStrings)
    {
        if ($Model.EndsWith($ts))
        {
            return $Model.Remove($Model.LastIndexOf($ts))
            # if (($index = $Model.LastIndexOf($ts)) -ge 0)
            # {
            #     $Model = $Model.Remove($index)
            # }
        }
    }

    return $Model
}
