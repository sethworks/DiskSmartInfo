$descriptionsHash = @(
    [ordered]@{
        AttributeID = 1
        AttributeName = 'Raw Read Error Rate'
        IsCritical = $false
        BetterValue = 'Low'
        Description = '(Vendor specific raw value.) Stores data related to the rate of hardware read errors that occurred when reading data from a disk surface. The raw value has different structure for different vendors and is often not meaningful as a decimal number.'
    },
    [ordered]@{
        AttributeID = 2
        AttributeName = 'Throughput Performance'
        IsCritical = $false
        BetterValue = 'High'
        Description = 'Overall (general) throughput performance of a hard disk drive. If the value of this attribute is decreasing there is a high probability that there is a problem with the disk.'
    },
    [ordered]@{
        AttributeID = 3
        AttributeName = 'Spin-Up Time'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Average time of spindle spin up (from zero RPM to fully operational [milliseconds]).'
    },
    [ordered]@{
        AttributeID = 4
        AttributeName = 'Start/Stop Count'
        IsCritical = $false
        BetterValue = ''
        Description = 'A tally of spindle start/stop cycles. The spindle turns on, and hence the count is increased, both when the hard disk is turned on after having before been turned entirely off (disconnected from power source) and when the hard disk returns from having previously been put to sleep mode.'
    },
    [ordered]@{
        AttributeID = 5
        AttributeName = 'Reallocated Sectors Count'
        IsCritical = $true
        BetterValue = ''
        Description = 'Count of reallocated sectors. The raw value represents a count of the bad sectors that have been found and remapped.[25] Thus, the higher the attribute value, the more sectors the drive has had to reallocate. This value is primarily used as a metric of the life expectancy of the drive; a drive which has had any reallocations at all is significantly more likely to fail in the immediate months.'
    },
    [ordered]@{
        AttributeID = 6
        AttributeName = 'Read Channel Margin'
        IsCritical = $false
        BetterValue = ''
        Description = 'Margin of a channel while reading data. The function of this attribute is not specified.'
    },
    [ordered]@{
        AttributeID = 7
        AttributeName = 'Seek Error Rate'
        IsCritical = $false
        BetterValue = 'Varies'
        Description = '(Vendor specific raw value.) Rate of seek errors of the magnetic heads. If there is a partial failure in the mechanical positioning system, then seek errors will arise. Such a failure may be due to numerous factors, such as damage to a servo, or thermal widening of the hard disk. The raw value has different structure for different vendors and is often not meaningful as a decimal number.'
    },
    [ordered]@{
        AttributeID = 8
        AttributeName = 'Seek Time Performance'
        IsCritical = $false
        BetterValue = 'High'
        Description = 'Average performance of seek operations of the magnetic heads. If this attribute is decreasing, it is a sign of problems in the mechanical subsystem.'
    },
    [ordered]@{
        AttributeID = 9
        AttributeName = 'Power-On Hours'
        IsCritical = $false
        BetterValue = ''
        Description = 'Count of hours in power-on state. The raw value of this attribute shows total count of hours (or minutes, or seconds, depending on manufacturer) in power-on state.
"By default, the total expected lifetime of a hard disk in perfect condition is defined as 5 years (running every day and night on all days). This is equal to 1825 days in 24/7 mode or 43800 hours."
On some pre-2005 drives, this raw value may advance erratically and/or "wrap around" (reset to zero periodically).'
    },
    [ordered]@{
        AttributeID = 10
        AttributeName = 'Spin Retry Count'
        IsCritical = $true
        BetterValue = 'Low'
        Description = 'Count of retry of spin start attempts. This attribute stores a total count of the spin start attempts to reach the fully operational speed (under the condition that the first attempt was unsuccessful). An increase of this attribute value is a sign of problems in the hard disk mechanical subsystem.'
    },
    [ordered]@{
        AttributeID = 11
        AttributeName = 'Calibration Retry Count'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Also known as "Calibration Retries". This attribute indicates the count that recalibration was requested (under the condition that the first attempt was unsuccessful). An increase of this attribute value is a sign of problems in the hard disk mechanical subsystem.'
    },
    [ordered]@{
        AttributeID = 12
        AttributeName = 'Power Cycle Count'
        IsCritical = $false
        BetterValue = ''
        Description = 'This attribute indicates the count of full hard disk power on/off cycles.'
    },
    [ordered]@{
        AttributeID = 13
        AttributeName = 'Read Soft Error Rate'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Uncorrected read errors reported to the operating system.'
    },
    [ordered]@{
        AttributeID = 22
        AttributeName = 'Current Helium Level'
        IsCritical = $false
        BetterValue = ''
        Description = 'Specific to He8 drives from HGST. This value measures the helium inside of the drive specific to this manufacturer. It is a pre-fail attribute that trips once the drive detects that the internal environment is out of specification.'
    },
    [ordered]@{
        AttributeID = 170
        AttributeName = 'Available Reserved Space'
        IsCritical = $false
        BetterValue = ''
        Description = 'Identical to attribute 232 (E8)'
    },
    [ordered]@{
        AttributeID = 171
        AttributeName = 'SSD Program Fail Count'
        IsCritical = $false
        BetterValue = ''
        Description = '(Kingston) The total number of flash program operation failures since the drive was deployed. Identical to attribute 181.'
    },
    [ordered]@{
        AttributeID = 172
        AttributeName = 'SSD Erase Fail Count'
        IsCritical = $false
        BetterValue = ''
        Description = '(Kingston) Counts the number of flash erase failures. This attribute returns the total number of Flash erase operation failures since the drive was deployed. This attribute is identical to attribute 182.'
    },
    [ordered]@{
        AttributeID = 173
        AttributeName = 'SSD Wear Leveling Count'
        IsCritical = $false
        BetterValue = ''
        Description = 'Counts the maximum worst erase count on any block.'
    },
    [ordered]@{
        AttributeID = 174
        AttributeName = 'Unexpected power loss count'
        IsCritical = $false
        BetterValue = ''
        Description = 'Also known as "Power-off Retract Count" per conventional HDD terminology. Raw value reports the number of unclean shutdowns, cumulative over the life of an SSD, where an "unclean shutdown" is the removal of power without STANDBY IMMEDIATE as the last command (regardless of PLI activity using capacitor power). Normalized value is always 100.'
    },
    [ordered]@{
        AttributeID = 175
        AttributeName = 'Power Loss Protection Failure'
        IsCritical = $false
        BetterValue = ''
        Description = 'Last test result as microseconds to discharge cap, saturated at its maximum value. Also logs minutes since last test and lifetime number of tests. Raw value contains the following data:
Bytes 0-1: Last test result as microseconds to discharge cap, saturates at max value. Test result expected in range 25 <= result <= 5000000, lower indicates specific error code.
Bytes 2-3: Minutes since last test, saturates at max value.
Bytes 4-5: Lifetime number of tests, not incremented on power cycle, saturates at max value.
Normalized value is set to one on test failure or 11 if the capacitor has been tested in an excessive temperature condition, otherwise 100.'
    },
    [ordered]@{
        AttributeID = 176
        AttributeName = 'Erase Fail Count'
        IsCritical = $false
        BetterValue = ''
        Description = 'S.M.A.R.T. parameter indicates a number of flash erase command failures.'
    },
    [ordered]@{
        AttributeID = 177
        AttributeName = 'Wear Range Delta'
        IsCritical = $false
        BetterValue = ''
        Description = 'Delta between most-worn and least-worn Flash blocks. It describes how good/bad the wearleveling of the SSD works on a more technical way.'
    },
    [ordered]@{
        AttributeID = 178
        AttributeName = 'Used Reserved Block Count Chip'
        IsCritical = $false
        BetterValue = ''
        Description = 'Used Reserved Block Count (Chip) S.M.A.R.T. parameter indicates the number of a chip''s used reserved blocks.'
    },
    [ordered]@{
        AttributeID = 179
        AttributeName = 'Used Reserved Block Count Total'
        IsCritical = $false
        BetterValue = ''
        Description = '"Pre-Fail" attribute used at least in Samsung devices.'
    },
    [ordered]@{
        AttributeID = 180
        AttributeName = 'Unused Reserved Block Count Total'
        IsCritical = $false
        BetterValue = ''
        Description = '"Pre-Fail" attribute used at least in HP devices.'
    },
    [ordered]@{
        AttributeID = 181
        AttributeName = 'Program Fail Count Total'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Also known as "Non-4K Aligned Access Count". Total number of Flash program operation failures since the drive was deployed.
Number of user data accesses (both reads and writes) where LBAs are not 4 KiB aligned (LBA % 8 != 0) or where size is not modulus 4 KiB (block count != 8), assuming logical block size (LBS) = 512 B.'
    },
    [ordered]@{
        AttributeID = 182
        AttributeName = 'Erase Fail Count'
        IsCritical = $false
        BetterValue = ''
        Description = '"Pre-Fail" Attribute used at least in Samsung devices.'
    },
    [ordered]@{
        AttributeID = 183
        AttributeName = 'SATA Downshift Error Count'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Also known as "Runtine Bad Block". Western Digital, Samsung or Seagate attribute: Either the number of downshifts of link speed (e.g. from 6Gbps to 3Gbps) or the total number of data blocks with detected, uncorrectable errors encountered during normal operation. Although degradation of this parameter can be an indicator of drive aging and/or potential electromechanical problems, it does not directly indicate imminent drive failure.'
    },
    [ordered]@{
        AttributeID = 184
        AttributeName = 'End-to-End Error / IOEDC'
        IsCritical = $true
        BetterValue = 'Low'
        Description = 'This attribute is a part of Hewlett-Packard''s SMART IV technology, as well as part of other vendors'' IO Error Detection and Correction schemas, and it contains a count of parity errors which occur in the data path to the media via the drive''s cache RAM.'
    },
    [ordered]@{
        AttributeID = 185
        AttributeName = 'Head Stability'
        IsCritical = $false
        BetterValue = ''
        Description = 'Western Digital attribute.'
    },
    [ordered]@{
        AttributeID = 186
        AttributeName = 'Induced Op-Vibration Detection'
        IsCritical = $false
        BetterValue = ''
        Description = 'Western Digital attribute.'
    },
    [ordered]@{
        AttributeID = 187
        AttributeName = 'Reported Uncorrectable Errors'
        IsCritical = $true
        BetterValue = 'Low'
        Description = 'The count of errors that could not be recovered using hardware ECC (see attribute 195).'
    },
    [ordered]@{
        AttributeID = 188
        AttributeName = 'Command Timeout'
        IsCritical = $true
        BetterValue = 'Low'
        Description = 'The count of aborted operations due to HDD timeout. Normally this attribute value should be equal to zero.'
    },
    [ordered]@{
        AttributeID = 189
        AttributeName = 'High Fly Writes'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'HDD manufacturers implement a flying height sensor that attempts to provide additional protections for write operations by detecting when a recording head is flying outside its normal operating range. If an unsafe fly height condition is encountered, the write process is stopped, and the information is rewritten or reallocated to a safe region of the hard drive. This attribute indicates the count of these errors detected over the lifetime of the drive.
This feature is implemented in most modern Seagate drives and some of Western Digital''s drives, beginning with the WD Enterprise WDE18300 and WDE9180 Ultra2 SCSI hard drives, and will be included on all future WD Enterprise products.'
    },
    [ordered]@{
        AttributeID = 190
        AttributeName = 'Temperature Difference'
        IsCritical = $false
        BetterValue = 'Varies'
        Description = 'Also known as "Airflow Temperature". Value is equal to (100-temp. $([char]0xB0)C), allowing manufacturer to set a minimum threshold which corresponds to a maximum temperature. This also follows the convention of 100 being a best-case value and lower values being undesirable. However, some older drives may instead report raw Temperature (identical to 0xC2) or Temperature minus 50 here.'
    },
    [ordered]@{
        AttributeID = 191
        AttributeName = 'G-Sense Error Rate'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'The count of errors resulting from externally induced shock and vibration.'
    },
    [ordered]@{
        AttributeID = 192
        AttributeName = 'Power-off Retract Count'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Also known as "Emergency Retract Cycle Count" (Fujitsu) or "Unsafe Shutdown Count". Number of power-off or emergency retract cycles.'
    },
    [ordered]@{
        AttributeID = 193
        AttributeName = 'Load Cycle Count'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Also known as "Load/Unload Cycle Count" (Fujitsu). Count of load/unload cycles into head landing zone position. Some drives use 225 (0xE1) for Load Cycle Count instead.
Western Digital rates their VelociRaptor drives for 600,000 load/unload cycles, and WD Green drives for 300,000 cycles; the latter ones are designed to unload heads often to conserve power. On the other hand, the WD3000GLFS (a desktop drive) is specified for only 50,000 load/unload cycles.
Some laptop drives and "green power" desktop drives are programmed to unload the heads whenever there has not been any activity for a short period, to save power. Operating systems often access the file system a few times a minute in the background, causing 100 or more load cycles per hour if the heads unload: the load cycle rating may be exceeded in less than a year. There are programs for most operating systems that disable the Advanced Power Management (APM) and Automatic acoustic management (AAM) features causing frequent load cycles.'
    },
    [ordered]@{
        AttributeID = 194
        AttributeName = 'Temperature'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Indicates the device temperature, if the appropriate sensor is fitted. Lowest byte of the raw value contains the exact temperature value (Celsius degrees).'
    },
    [ordered]@{
        AttributeID = 195
        AttributeName = 'Hardware ECC Recovered'
        IsCritical = $false
        BetterValue = 'Varies'
        Description = '(Vendor-specific raw value.) The raw value has different structure for different vendors and is often not meaningful as a decimal number.'
    },
    [ordered]@{
        AttributeID = 196
        AttributeName = 'Reallocation Event Count'
        IsCritical = $true
        BetterValue = 'Low'
        Description = 'Count of remap operations. The raw value of this attribute shows the total count of attempts to transfer data from reallocated sectors to a spare area. Both successful and unsuccessful attempts are counted.'
    },
    [ordered]@{
        AttributeID = 197
        AttributeName = 'Current Pending Sector Count'
        IsCritical = $true
        BetterValue = 'Low'
        Description = 'Count of "unstable" sectors (waiting to be remapped, because of unrecoverable read errors). If an unstable sector is subsequently read successfully, the sector is remapped and this value is decreased. Read errors on a sector will not remap the sector immediately (since the correct value cannot be read and so the value to remap is not known, and also it might become readable later); instead, the drive firmware remembers that the sector needs to be remapped, and will remap it the next time it''s written.
However, some drives will not immediately remap such sectors when written; instead the drive will first attempt to write to the problem sector and if the write operation is successful then the sector will be marked good (in this case, the "Reallocation Event Count" (0xC4) will not be increased). This is a serious shortcoming, for if such a drive contains marginal sectors that consistently fail only after some time has passed following a successful write operation, then the drive will never remap these problem sectors.'
    },
    [ordered]@{
        AttributeID = 198
        AttributeName = 'Offline Uncorrectable Sector Count'
        IsCritical = $true
        BetterValue = 'Low'
        Description = 'The total count of uncorrectable errors when reading/writing a sector. A rise in the value of this attribute indicates defects of the disk surface and/or problems in the mechanical subsystem.'
    },
    [ordered]@{
        AttributeID = 199
        AttributeName = 'Ultra DMA CRC Error Count'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'The count of errors in data transfer via the interface cable as determined by ICRC (Interface Cyclic Redundancy Check).'
    },
    [ordered]@{
        AttributeID = 200
        AttributeName = 'Write Error Rate'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Also known as "Multi-Zone Error Rate". The count of errors found when writing a sector. The higher the value, the worse the disk''s mechanical condition is.'
    },
    [ordered]@{
        AttributeID = 201
        AttributeName = 'Soft Read Error Rate'
        IsCritical = $true
        BetterValue = 'Low'
        Description = 'Also known as "TA Counter Detected". Count indicates the number of uncorrectable software read errors.'
    },
    [ordered]@{
        AttributeID = 202
        AttributeName = 'Data Address Mark Errors'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Also known as "TA Counter Increased". Count of Data Address Mark errors (or vendor-specific).'
    },
    [ordered]@{
        AttributeID = 203
        AttributeName = 'Run Out Cancel'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'The number of errors caused by incorrect checksum during the error correction.'
    },
    [ordered]@{
        AttributeID = 204
        AttributeName = 'Soft ECC correction'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Count of errors corrected by the internal error correction software.'
    },
    [ordered]@{
        AttributeID = 205
        AttributeName = 'Thermal Asperity Rate'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Count of errors due to high temperature.'
    },
    [ordered]@{
        AttributeID = 206
        AttributeName = 'Flying Height'
        IsCritical = $false
        BetterValue = ''
        Description = 'Height of heads above the disk surface. If too low, head crash is more likely; if too high, read/write errors are more likely.'
    },
    [ordered]@{
        AttributeID = 207
        AttributeName = 'Spin High Current'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Amount of surge current used to spin up the drive.'
    },
    [ordered]@{
        AttributeID = 208
        AttributeName = 'Spin Buzz'
        IsCritical = $false
        BetterValue = ''
        Description = 'Count of buzz routines needed to spin up the drive due to insufficient power.'
    },
    [ordered]@{
        AttributeID = 209
        AttributeName = 'Offline Seek Performance'
        IsCritical = $false
        BetterValue = ''
        Description = 'Drive''s seek performance during its internal tests.'
    },
    [ordered]@{
        AttributeID = 210
        AttributeName = 'Vibration Diring Write'
        IsCritical = $false
        BetterValue = ''
        Description = 'Found in Maxtor 6B200M0 200GB and Maxtor 2R015H1 15GB disks.'
    },
    [ordered]@{
        AttributeID = 211
        AttributeName = 'Vibration Diring Write'
        IsCritical = $false
        BetterValue = ''
        Description = 'A recording of a vibration encountered during write operations.'
    },
    [ordered]@{
        AttributeID = 212
        AttributeName = 'Shock During Write'
        IsCritical = $false
        BetterValue = ''
        Description = 'A recording of shock encountered during write operations.'
    },
    [ordered]@{
        AttributeID = 220
        AttributeName = 'Disk Shift'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Distance the disk has shifted relative to the spindle (usually due to shock or temperature). Unit of measure is unknown.'
    },
    [ordered]@{
        AttributeID = 221
        AttributeName = 'G-Sense Error Rate'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'The count of errors resulting from externally induced shock and vibration.'
    },
    [ordered]@{
        AttributeID = 222
        AttributeName = 'Loaded Hours'
        IsCritical = $false
        BetterValue = ''
        Description = 'Time spent operating under data load (movement of magnetic head armature).'
    },
    [ordered]@{
        AttributeID = 223
        AttributeName = 'Load/Unload Retry Count'
        IsCritical = $false
        BetterValue = ''
        Description = 'Count of times head changes position.'
    },
    [ordered]@{
        AttributeID = 224
        AttributeName = 'Load Friction'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Resistance caused by friction in mechanical parts while operating.'
    },
    [ordered]@{
        AttributeID = 225
        AttributeName = 'Load/Unload Cycle Count'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Total count of load cycles. Some drives use 193 (0xC1) for Load Cycle Count instead. See Description for 193 for significance of this number.'
    },
    [ordered]@{
        AttributeID = 226
        AttributeName = 'Load-in time'
        IsCritical = $false
        BetterValue = ''
        Description = 'Total time of loading on the magnetic heads actuator (time not spent in parking area).'
    },
    [ordered]@{
        AttributeID = 227
        AttributeName = 'Torque Amplification Count'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Count of attempts to compensate for platter speed variations.'
    },
    [ordered]@{
        AttributeID = 228
        AttributeName = 'Power-Off Retract Cycle'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'The number of power-off cycles which are counted whenever there is a "retract event" and the heads are loaded off of the media such as when the machine is powered down, put to sleep, or is idle.'
    },
    [ordered]@{
        AttributeID = 230
        AttributeName = 'GMR Head Amplitude (magnetic HDDs), Drive Life Protection Status (SSDs)'
        IsCritical = $false
        BetterValue = ''
        Description = 'Amplitude of "thrashing" (repetitive head moving motions between operations). In solid-state drives, indicates whether usage trajectory is outpacing the expected life curve.'
    },
    [ordered]@{
        AttributeID = 231
        AttributeName = 'Life Left (SSDs) or Temperature'
        IsCritical = $false
        BetterValue = ''
        Description = 'Indicates the approximate SSD life left, in terms of program/erase cycles or available reserved blocks. A normalized value of 100 represents a new drive, with a threshold value at 10 indicating a need for replacement. A value of 0 may mean that the drive is operating in read-only mode to allow data recovery. Previously (pre-2010) occasionally used for Drive Temperature (more typically reported at 0xC2).'
    },
    [ordered]@{
        AttributeID = 232
        AttributeName = 'Endurance Remaining or Available Reserved Space'
        IsCritical = $false
        BetterValue = ''
        Description = 'Number of physical erase cycles completed on the SSD as a percentage of the maximum physical erase cycles the drive is designed to endure. Intel SSDs report the available reserved space as a percentage of the initial reserved space.'
    },
    [ordered]@{
        AttributeID = 233
        AttributeName = 'Media Wearout Indicator (SSDs) or Power-On Hours'
        IsCritical = $false
        BetterValue = ''
        Description = 'Intel SSDs report a normalized value from 100, a new drive, to a minimum of 1. It decreases while the NAND erase cycles increase from 0 to the maximum-rated cycles. Previously (pre-2010) occasionally used for Power-On Hours (more typically reported in 0x09).'
    },
    [ordered]@{
        AttributeID = 234
        AttributeName = 'Average erase count AND Maximum Erase Count'
        IsCritical = $false
        BetterValue = ''
        Description = 'Decoded as: byte 0-1-2 = average erase count (big endian) and byte 3-4-5 = max erase count (big endian).'
    },
    [ordered]@{
        AttributeID = 235
        AttributeName = 'Good Block Count AND System(Free) Block Count'
        IsCritical = $false
        BetterValue = ''
        Description = 'Decoded as: byte 0-1-2 = good block count (big endian) and byte 3-4 = system (free) block count.'
    },
    [ordered]@{
        AttributeID = 240
        AttributeName = 'Head Flying Hours or Transfer Error Rate (Fujitsu)'
        IsCritical = $false
        BetterValue = ''
        Description = 'Time spent during the positioning of the drive heads. Some Fujitsu drives report the count of link resets during a data transfer.'
    },
    [ordered]@{
        AttributeID = 241
        AttributeName = 'Total LBAs Written'
        IsCritical = $false
        BetterValue = ''
        Description = 'Total count of LBAs written.'
    },
    [ordered]@{
        AttributeID = 242
        AttributeName = 'Total LBAs Read'
        IsCritical = $false
        BetterValue = ''
        Description = 'Total count of LBAs read. Some S.M.A.R.T. utilities will report a negative number for the raw value since in reality it has 48 bits rather than 32.'
    },
    [ordered]@{
        AttributeID = 243
        AttributeName = 'Total LBAs Written Expanded'
        IsCritical = $false
        BetterValue = ''
        Description = 'The upper 5 bytes of the 12-byte total number of LBAs written to the device. The lower 7 byte value is located at attribute 0xF1.'
    },
    [ordered]@{
        AttributeID = 244
        AttributeName = 'Total LBAs Read Expanded'
        IsCritical = $false
        BetterValue = ''
        Description = 'The upper 5 bytes of the 12-byte total number of LBAs read from the device. The lower 7 byte value is located at attribute 0xF2.'
    },
    [ordered]@{
        AttributeID = 249
        AttributeName = 'NAND Writes (1GiB)'
        IsCritical = $false
        BetterValue = ''
        Description = 'Total NAND Writes. Raw value reports the number of writes to NAND in 1 GB increments.'
    },
    [ordered]@{
        AttributeID = 250
        AttributeName = 'Read Error Retry Rate'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Count of errors while reading from a disk.'
    },
    [ordered]@{
        AttributeID = 251
        AttributeName = 'Minimum Spares Remaining'
        IsCritical = $false
        BetterValue = ''
        Description = 'The Minimum Spares Remaining attribute indicates the number of remaining spare blocks as a percentage of the total number of spare blocks available.'
    },
    [ordered]@{
        AttributeID = 252
        AttributeName = 'Newly Added Bad Flash Block'
        IsCritical = $false
        BetterValue = ''
        Description = 'The Newly Added Bad Flash Block attribute indicates the total number of bad flash blocks the drive detected since it was first initialized in manufacturing.'
    },
    [ordered]@{
        AttributeID = 254
        AttributeName = 'Free Fall Protection'
        IsCritical = $false
        BetterValue = 'Low'
        Description = 'Count of "Free Fall Events" detected.'
    }
)

$Script:descriptions = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($descriptionHash in $descriptionsHash)
{
    $descriptionHash.Insert(1, "AttributeIDHex", $descriptionHash.AttributeID.ToString("X"))
    $descriptions.Add([PSCustomObject]$descriptionHash)
}
