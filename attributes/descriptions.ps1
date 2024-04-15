$descriptionsHash = @(
    [ordered]@{
        AttributeID = 1
        AttributeName = 'Raw Read Error Rate'
        Description = 'Read Error Rate S.M.A.R.T. parameter indicates the rate of hardware read errors that occurred when reading data from a disk surface. Any value differing from zero means there is a problem with the disk surface, read/write heads (including crack on a head, broken head, head contamination, head resonance, bad connection to electronics module, handling damage). The higher parameter''s value is, the more the hard disk failure is possible.'
    },
    [ordered]@{
        AttributeID = 2
        AttributeName = 'Throughput Performance'
        Description = 'Throughput Performance S.M.A.R.T. parameter indicates the general throughput performance of the hard disk.'
    },
    [ordered]@{
        AttributeID = 3
        AttributeName = 'Spin-Up Time'
        Description = 'Spin-Up Time S.M.A.R.T. parameter indicates an average time (in milliseconds or seconds) of spindle spinup (from zero RPM (Revolutions Per Minute) to fully operational).'
    },
    [ordered]@{
        AttributeID = 4
        AttributeName = 'Start/Stop Count'
        Description = 'Start/Stop Count S.M.A.R.T. parameter indicates a count of hard disk spindle start/stop cycles.'
    },
    [ordered]@{
        AttributeID = 5
        AttributeName = 'Reallocated Sectors Count'
        Description = 'Reallocated Sectors Count S.M.A.R.T. parameter indicates the count of reallocated sectors (512 bytes). When the hard drive finds a read/write/verification error, it marks this sector as "reallocated" and transfers data to a special reserved area (spare area). This process is also known as remapping and "reallocated" sectors are called remaps. This is why, on a modern hard disks, you will not see "bad blocks" while testing the surface - all bad blocks are hidden in reallocated sectors.'
    },
    [ordered]@{
        AttributeID = 6
        AttributeName = 'Read Channel Margin'
        Description = 'Read Channel Margin S.M.A.R.T. parameter indicates a margin of a channel while reading data. Usually manufacturers do not use this parameter.'
    },
    [ordered]@{
        AttributeID = 7
        AttributeName = 'Seek Error Rate'
        Description = 'Seek Error Rate S.M.A.R.T. parameter indicates a rate of seek errors of the magnetic heads. In case of a failure in the mechanical positioning system, a servo damage or a thermal widening of the hard disk, seek errors arise.'
    },
    [ordered]@{
        AttributeID = 8
        AttributeName = 'Seek Time Performance'
        Description = 'Seek Time Performance S.M.A.R.T. parameter indicates the average performance of seek operations of the hard disk''s magnetic heads.'
    },
    [ordered]@{
        AttributeID = 9
        AttributeName = 'Power-On Hours'
        Description = 'Power-On Hours (POH) S.M.A.R.T. parameter indicates a count of hours in power-on state. The value of this attribute shows total count of hours (or minutes, or seconds, depending on manufacturer) in power-on state. A decrease of this attribute value to the critical level (threshold) indicates a decrease of the MTBF (Mean Time Between Failures).'
    },
    [ordered]@{
        AttributeID = 10
        AttributeName = 'Spin Retry Count'
        Description = 'Spin Retry Count S.M.A.R.T. parameter indicates the count of retry of spin start attempts. This attribute stores a total count of the spin start attempts to reach the fully operational speed (under the condition that the first attempt was unsuccessful). Spin attempts are counted for the entire hard drive''s lifetime so far.'
    },
    [ordered]@{
        AttributeID = 11
        AttributeName = 'Calibration Retry Count'
        Description = 'Recalibration Retries S.M.A.R.T. parameter indicates the number of attempts to calibrate the hard drive after the first unsuccessful try.'
    },
    [ordered]@{
        AttributeID = 12
        AttributeName = 'Power Cycle Count'
        Description = 'Power Cycle Count S.M.A.R.T. parameter is an informational parameter and indicates the count of full hard disk power on/off cycles.'
    },
    [ordered]@{
        AttributeID = 13
        AttributeName = 'Read Soft Error Rate'
        Description = 'Soft Read Error Count S.M.A.R.T. parameter indicates the number of uncorrected read errors reported to an operating system.'
    },
    [ordered]@{
        AttributeID = 22
        AttributeName = 'Current Helium Level'
        Description = 'Specific to He8 drives from HGST. This value measures the helium inside of the drive specific to this manufacturer. It is a pre-fail attribute that trips once the drive detects that the internal environment is out of specification.'
    },
    [ordered]@{
        AttributeID = 170
        AttributeName = 'Available Reserved Space'
        Description = 'Reserved Block Count S.M.A.R.T. parameter indicates a number of reserved bad block handling.'
    },
    [ordered]@{
        AttributeID = 171
        AttributeName = 'SSD Program Fail Count'
        Description = 'Program Fail Count S.M.A.R.T. parameter indicates a number of flash program failures.'
    },
    [ordered]@{
        AttributeID = 172
        AttributeName = 'SSD Erase Fail Count'
        Description = 'Erase Fail Count S.M.A.R.T. parameter indicates a number of flash erase command failures.'
    },
    [ordered]@{
        AttributeID = 173
        AttributeName = 'SSD Wear Leveling Count'
        Description = 'Wear Leveling Count S.M.A.R.T. parameter indicates the worst case erase count.'
    },
    [ordered]@{
        AttributeID = 174
        AttributeName = 'Unexpected power loss count'
        Description = 'Unexpected Power Loss S.M.A.R.T. parameter indicates a number of unexpected power loss events.'
    },
    [ordered]@{
        AttributeID = 175
        AttributeName = 'Program Fail Count Chip'
        Description = 'Program Fail Count (chip) S.M.A.R.T. parameter indicates a number of flash program failures.'
    },
    [ordered]@{
        AttributeID = 176
        AttributeName = 'Erase Fail Count Chip'
        Description = 'Erase Fail Count (chip) S.M.A.R.T. parameter indicates a number of flash erase command failures.'
    },
    [ordered]@{
        AttributeID = 177
        AttributeName = 'Wear Leveling Count'
        Description = 'Wear Leveling Count (chip) S.M.A.R.T. parameter indicates the worst case erase count.'
    },
    [ordered]@{
        AttributeID = 178
        AttributeName = 'Used Reserved Block Count Chip'
        Description = 'Used Reserved Block Count (Chip) S.M.A.R.T. parameter indicates the number of a chip''s used reserved blocks.'
    },
    [ordered]@{
        AttributeID = 179
        AttributeName = 'Used Reserved Block Count Total'
        Description = 'Used Reserved Block Count (Total) S.M.A.R.T. parameter indicates the number of used reserved blocks.'
    },
    [ordered]@{
        AttributeID = 180
        AttributeName = 'Unused Reserved Block Count Total'
        Description = '"Pre-Fail" attribute used at least in HP devices.'
    },
    [ordered]@{
        AttributeID = 181
        AttributeName = 'Program Fail Count Total'
        Description = 'Also known as "Non-4K Aligned Access Count". Total number of Flash program operation failures since the drive was deployed.
Number of user data accesses (both reads and writes) where LBAs are not 4 KiB aligned (LBA % 8 != 0) or where size is not modulus 4 KiB (block count != 8), assuming logical block size (LBS) = 512 B.'
    },
    [ordered]@{
        AttributeID = 182
        AttributeName = 'Erase Fail Count'
        Description = '"Pre-Fail" Attribute used at least in Samsung devices.'
    },
    [ordered]@{
        AttributeID = 183
        AttributeName = 'Runtine Bad Block'
        Description = 'Also known as "SATA Downshift Error Count". Western Digital, Samsung or Seagate attribute: Either the number of downshifts of link speed (e.g. from 6Gbps to 3Gbps) or the total number of data blocks with detected, uncorrectable errors encountered during normal operation. Although degradation of this parameter can be an indicator of drive aging and/or potential electromechanical problems, it does not directly indicate imminent drive failure.'
    },
    [ordered]@{
        AttributeID = 184
        AttributeName = 'End-to-End Error / IOEDC'
        Description = 'This attribute is a part of Hewlett-Packard''s SMART IV technology, as well as part of other vendors'' IO Error Detection and Correction schemas, and it contains a count of parity errors which occur in the data path to the media via the drive''s cache RAM.'
    },
    [ordered]@{
        AttributeID = 185
        AttributeName = 'Head Stability'
        Description = 'Western Digital attribute.'
    },
    [ordered]@{
        AttributeID = 186
        AttributeName = 'Induced Op-Vibration Detection'
        Description = 'Western Digital attribute.'
    },
    [ordered]@{
        AttributeID = 187
        AttributeName = 'Reported Uncorrectable Errors'
        Description = 'Reported Uncorrectable Errors S.M.A.R.T. parameter indicates a number of errors that could not be recovered using hardware ECC (error-correcting code).'
    },
    [ordered]@{
        AttributeID = 188
        AttributeName = 'Command Timeout'
        Description = 'Command Timeout S.M.A.R.T. parameter indicates a number of aborted operations due to hard disk timeout.'
    },
    [ordered]@{
        AttributeID = 189
        AttributeName = 'High Fly Writes'
        Description = 'High Fly Writes S.M.A.R.T. parameter indicates the count of these errors detected over the lifetime of the drive. HDD producers implement a Fly Height Monitor that attempts to provide additional protections for write operations by detecting when a recording head is flying outside its normal operating range. If an unsafe fly height condition is encountered, the write process is stopped, and the information is rewritten or reallocated to a safe region of the hard drive.'
    },
    [ordered]@{
        AttributeID = 190
        AttributeName = 'Airflow Temperature Celsius'
        Description = 'Also known as "Temperature Difference". Temperature Difference from 100 (Airflow Temperature) S.M.A.R.T. parameter indicates the temperature of the air inside the Seagate and Samsung hard disk housing. The value is equal to [100 - specified by manufacturer temperature °C], which allows setting the minimum threshold.'
    },
    [ordered]@{
        AttributeID = 191
        AttributeName = 'G-Sense Error Rate'
        Description = 'G-sense error rate S.M.A.R.T. parameter indicates the number of errors caused by externally-induced shock or vibration.'
    },
    [ordered]@{
        AttributeID = 192
        AttributeName = 'Power-off Retract Count'
        Description = 'Also known as "Emergency Retract Cycle Count" (Fujitsu) or "Unsafe Shutdown Count". Number of power-off or emergency retract cycles.'
    },
    [ordered]@{
        AttributeID = 193
        AttributeName = 'Load Cycle Count'
        Description = 'Also known as "Load/Unload Cycle Count" (Fujitsu). Load Cycle Count S.M.A.R.T. parameter indicates the number of cycles into Landing Zone position.'
    },
    [ordered]@{
        AttributeID = 194
        AttributeName = 'Temperature Celsius'
        Description = 'HDA Temperature S.M.A.R.T. parameter indicates a hard disk drive current internal temperature. The raw value of this attribute shows built-in heat sensor registrations (in degrees centigrade).'
    },
    [ordered]@{
        AttributeID = 195
        AttributeName = 'Hardware ECC Recovered'
        Description = '(Vendor-specific raw value.) The raw value has different structure for different vendors and is often not meaningful as a decimal number.'
    },
    [ordered]@{
        AttributeID = 196
        AttributeName = 'Reallocation Event Count'
        Description = 'Reallocation Event Count S.M.A.R.T. parameter indicates a count of remap operations (transferring data from a bad sector to a special reserved disk area - spare area).'
    },
    [ordered]@{
        AttributeID = 197
        AttributeName = 'Current Pending Sector Count'
        Description = 'Current Pending Sector Count S.M.A.R.T. parameter is a critical parameter and indicates the current count of unstable sectors (waiting for remapping). The raw value of this attribute indicates the total number of sectors waiting for remapping. Later, when some of these sectors are read successfully, the value is decreased. If errors still occur when reading some sector, the hard drive will try to restore the data, transfer it to the reserved disk area (spare area) and mark this sector as remapped.'
    },
    [ordered]@{
        AttributeID = 198
        AttributeName = 'Offline Uncorrectable Sector Count'
        Description = 'Uncorrectable Sector Count S.M.A.R.T. parameter is a critical parameter and indicates the quantity of uncorrectable errors. The raw value of this attribute indicates the total number of uncorrectable errors when reading/writing a sector.'
    },
    [ordered]@{
        AttributeID = 199
        AttributeName = 'Ultra DMA CRC Error Count'
        Description = 'UltraDMA CRC Error Count S.M.A.R.T. parameter indicates the total quantity of CRC errors during UltraDMA mode. The raw value of this attribute indicates the number of errors found during data transfer in UltraDMA mode by ICRC (Interface CRC).'
    },
    [ordered]@{
        AttributeID = 200
        AttributeName = 'Multi-Zone Error Rate'
        Description = 'Also known as "Write Error Rate". Write Error Rate / Multi-Zone Error Rate (Western Digital) S.M.A.R.T. parameter indicates the total number of errors appearing while recording data to a hard disk. This may be caused by problems with disk surface or the read/write heads.'
    },
    [ordered]@{
        AttributeID = 201
        AttributeName = 'Soft Read Error Rate'
        Description = 'Soft Read Error Rate / Off Track Errors (Maxtor) S.M.A.R.T. parameter indicates the number of uncorrectable software read errors.'
    },
    [ordered]@{
        AttributeID = 202
        AttributeName = 'Data Address Mark Errors'
        Description = 'Data Address Mark errors S.M.A.R.T. parameter indicates the number of incorrect or invalid address marks.'
    },
    [ordered]@{
        AttributeID = 203
        AttributeName = 'Run Out Cancel'
        Description = 'Run Out Cancel S.M.A.R.T. parameter indicates that an invalid error correction checksum was found during error correction.'
    },
    [ordered]@{
        AttributeID = 204
        AttributeName = 'Soft ECC correction'
        Description = 'Soft ECC Correction S.M.A.R.T. parameter indicates the number of errors corrected by the internal error correction mechanism.'
    },
    [ordered]@{
        AttributeID = 205
        AttributeName = 'Thermal Asperity Rate'
        Description = 'Thermal Asperity Rate (TAR) S.M.A.R.T. parameter indicates the total number of problems caused by high temperature.'
    },
    [ordered]@{
        AttributeID = 206
        AttributeName = 'Flying Height'
        Description = 'Flying Height S.M.A.R.T. parameter indicates the height of heads above the disk surface. The low value of this parameter increases the chances of a head crash while a flying height that is too high increases the chances of a read/write error.'
    },
    [ordered]@{
        AttributeID = 207
        AttributeName = 'Spin High Current'
        Description = 'Spin High Current S.M.A.R.T. parameter indicates the current needed to spin up the drive.'
    },
    [ordered]@{
        AttributeID = 208
        AttributeName = 'Spin Buzz'
        Description = 'Spin Buzz S.M.A.R.T. parameter indicates the number of retries during spin up because of low current available.'
    },
    [ordered]@{
        AttributeID = 209
        AttributeName = 'Offline Seek Performance'
        Description = 'Offline Seek Performance S.M.A.R.T. parameter indicates the seek performance of the hard drive during internal self tests.'
    },
    [ordered]@{
        AttributeID = 210
        AttributeName = 'Vibration Diring Write'
        Description = 'Found in Maxtor 6B200M0 200GB and Maxtor 2R015H1 15GB disks.'
    },
    [ordered]@{
        AttributeID = 211
        AttributeName = 'Vibration Diring Write'
        Description = 'Vibration During Write S.M.A.R.T. parameter indicates a vibration encountered during write operations.'
    },
    [ordered]@{
        AttributeID = 212
        AttributeName = 'Shock During Write'
        Description = 'Shock During Write S.M.A.R.T. parameter indicates shock encountered during write operations.'
    },
    [ordered]@{
        AttributeID = 220
        AttributeName = 'Disk Shift'
        Description = 'Disk Shift S.M.A.R.T. parameter indicates that a distance of the disk has shifted relative to the spindle, which could be caused by a mechanical shock or high temperature.'
    },
    [ordered]@{
        AttributeID = 221
        AttributeName = 'G-Sense Error Rate'
        Description = 'G-Sense Error Rate (Shock Sense Error Rate for Hitachi) S.M.A.R.T. parameter indicates a number of errors resulting from shock or vibration.'
    },
    [ordered]@{
        AttributeID = 222
        AttributeName = 'Loaded Hours'
        Description = 'Loaded Hours S.M.A.R.T. parameter indicates a number of powered on hours. This value is constantly increasing (once per every hour).'
    },
    [ordered]@{
        AttributeID = 223
        AttributeName = 'Load/Unload Retry Count'
        Description = 'Load/Unload Retry Count S.M.A.R.T. parameter indicates a number of drive head enters/leaves the data zone.'
    },
    [ordered]@{
        AttributeID = 224
        AttributeName = 'Load Friction'
        Description = 'Load Friction S.M.A.R.T. parameter indicates the rate of friction between mechanical parts of the hard disk. The increasing value means there is a problem with the mechanical subsystem of the drive.'
    },
    [ordered]@{
        AttributeID = 225
        AttributeName = 'Load/Unload Cycle Count'
        Description = 'Load/Unload Cycle Count S.M.A.R.T. parameter indicates a total number of load cycles.'
    },
    [ordered]@{
        AttributeID = 226
        AttributeName = 'Load-in time'
        Description = 'Load-in Time S.M.A.R.T. parameter indicates total time the heads are loaded.'
    },
    [ordered]@{
        AttributeID = 227
        AttributeName = 'Torque Amplification Count'
        Description = 'Torque Amplification Count S.M.A.R.T. parameter indicates a number of attempts to compensate for platter speed variations.'
    },
    [ordered]@{
        AttributeID = 228
        AttributeName = 'Power-Off Retract Cycle'
        Description = 'The number of power-off cycles which are counted whenever there is a "retract event" and the heads are loaded off of the media such as when the machine is powered down, put to sleep, or is idle.'
    },
    [ordered]@{
        AttributeID = 230
        AttributeName = 'GMR Head Amplitude (magnetic HDDs), Drive Life Protection Status (SSDs)'
        Description = 'Amplitude of "thrashing" (repetitive head moving motions between operations). In solid-state drives, indicates whether usage trajectory is outpacing the expected life curve.'
    },
    [ordered]@{
        AttributeID = 231
        AttributeName = 'Life Left (SSDs) or Temperature'
        Description = 'Indicates the approximate SSD life left, in terms of program/erase cycles or available reserved blocks. A normalized value of 100 represents a new drive, with a threshold value at 10 indicating a need for replacement. A value of 0 may mean that the drive is operating in read-only mode to allow data recovery. Previously (pre-2010) occasionally used for Drive Temperature (more typically reported at 0xC2).'
    },
    [ordered]@{
        AttributeID = 232
        AttributeName = 'Endurance Remaining or Available Reserved Space'
        Description = 'Number of physical erase cycles completed on the SSD as a percentage of the maximum physical erase cycles the drive is designed to endure. Intel SSDs report the available reserved space as a percentage of the initial reserved space.'
    },
    [ordered]@{
        AttributeID = 233
        AttributeName = 'Media Wearout Indicator (SSDs) or Power-On Hours'
        Description = 'Intel SSDs report a normalized value from 100, a new drive, to a minimum of 1. It decreases while the NAND erase cycles increase from 0 to the maximum-rated cycles. Previously (pre-2010) occasionally used for Power-On Hours (more typically reported in 0x09).'
    },
    [ordered]@{
        AttributeID = 234
        AttributeName = 'Average erase count AND Maximum Erase Count'
        Description = 'Decoded as: byte 0-1-2 = average erase count (big endian) and byte 3-4-5 = max erase count (big endian).'
    },
    [ordered]@{
        AttributeID = 235
        AttributeName = 'Good Block Count AND System(Free) Block Count'
        Description = 'Decoded as: byte 0-1-2 = good block count (big endian) and byte 3-4 = system (free) block count.'
    },
    [ordered]@{
        AttributeID = 240
        AttributeName = 'Head Flying Hours or Transfer Error Rate (Fujitsu)'
        Description = 'Head Flying Hours / Transfer Error Rate (Fujitsu) S.M.A.R.T. parameter indicates time spent during the positioning of the drive heads.'
    },
    [ordered]@{
        AttributeID = 241
        AttributeName = 'Total LBAs Written'
        Description = 'Total LBAs Written S.M.A.R.T. parameter indicates a total number of LBAs written.'
    },
    [ordered]@{
        AttributeID = 242
        AttributeName = 'Total LBAs Read'
        Description = 'Total LBAs Read S.M.A.R.T. parameter indicates a total number of LBAs read.'
    },
    [ordered]@{
        AttributeID = 243
        AttributeName = 'Total LBAs Written Expanded'
        Description = 'The upper 5 bytes of the 12-byte total number of LBAs written to the device. The lower 7 byte value is located at attribute 0xF1.'
    },
    [ordered]@{
        AttributeID = 244
        AttributeName = 'Total LBAs Read Expanded'
        Description = 'The upper 5 bytes of the 12-byte total number of LBAs read from the device. The lower 7 byte value is located at attribute 0xF2.'
    },
    [ordered]@{
        AttributeID = 249
        AttributeName = 'NAND Writes (1GiB)'
        Description = 'Total NAND Writes. Raw value reports the number of writes to NAND in 1 GB increments.'
    },
    [ordered]@{
        AttributeID = 250
        AttributeName = 'Read Error Retry Rate'
        Description = 'Read Error Retry Rate S.M.A.R.T. parameter indicates a number of errors found during reading a sector from disk surface.'
    },
    [ordered]@{
        AttributeID = 251
        AttributeName = 'Minimum Spares Remaining'
        Description = 'The Minimum Spares Remaining attribute indicates the number of remaining spare blocks as a percentage of the total number of spare blocks available.'
    },
    [ordered]@{
        AttributeID = 252
        AttributeName = 'Newly Added Bad Flash Block'
        Description = 'The Newly Added Bad Flash Block attribute indicates the total number of bad flash blocks the drive detected since it was first initialized in manufacturing.'
    },
    [ordered]@{
        AttributeID = 254
        AttributeName = 'Free Fall Sensor'
        Description = 'Free Fall Protection S.M.A.R.T. parameter indicates a number of free fall events detected by the accelerometer sensor.'
    }
)

$Script:descriptions = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($descriptionHash in $descriptionsHash)
{
    $descriptionHash.Insert(1, "AttributeIDHex", $descriptionHash.AttributeID.ToString("X"))
    $descriptions.Add(([PSCustomObject]$descriptionHash | Add-Member -TypeName 'DiskSmartAttributeDescription' -PassThru))
}
