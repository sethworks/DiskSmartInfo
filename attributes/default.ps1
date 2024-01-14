$defaultAttributesHash = @(
    [ordered]@{
        AttributeID = 1
        AttributeIDHex = '1'
        AttributeName = 'Read Error Rate'
        BetterValue = 'Low'
        IsCritical = $null
        Description = '(Vendor specific raw value.) Stores data related to the rate of hardware read errors that occurred when reading data from a disk surface. The raw value has different structure for different vendors and is often not meaningful as a decimal number.'
    },
    [ordered]@{
        AttributeID = 2
        AttributeIDHex = '2'
        AttributeName = 'Throughput Performance'
        BetterValue = 'High'
        IsCritical = $null
        Description = 'Overall (general) throughput performance of a hard disk drive. If the value of this attribute is decreasing there is a high probability that there is a problem with the disk.'
    },
    [ordered]@{
        AttributeID = 3
        AttributeIDHex = '3'
        AttributeName = 'Spin-Up Time'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Average time of spindle spin up (from zero RPM to fully operational [milliseconds]).'
    },
    [ordered]@{
        AttributeID = 4
        AttributeIDHex = '4'
        AttributeName = 'Start/Stop Count'
        BetterValue = ''
        IsCritical = $null
        Description = 'A tally of spindle start/stop cycles. The spindle turns on, and hence the count is increased, both when the hard disk is turned on after having before been turned entirely off (disconnected from power source) and when the hard disk returns from having previously been put to sleep mode.'
    },
    [ordered]@{
        AttributeID = 5
        AttributeIDHex = '5'
        AttributeName = 'Reallocated Sectors Count'
        BetterValue = ''
        IsCritical = $true
        Description = 'Count of reallocated sectors. The raw value represents a count of the bad sectors that have been found and remapped.[25] Thus, the higher the attribute value, the more sectors the drive has had to reallocate. This value is primarily used as a metric of the life expectancy of the drive; a drive which has had any reallocations at all is significantly more likely to fail in the immediate months.'
    },
    [ordered]@{
        AttributeID = 6
        AttributeIDHex = '6'
        AttributeName = 'Read Channel Margin'
        BetterValue = ''
        IsCritical = $null
        Description = 'Margin of a channel while reading data. The function of this attribute is not specified.'
    },
    [ordered]@{
        AttributeID = 7
        AttributeIDHex = '7'
        AttributeName = 'Seek Error Rate'
        BetterValue = 'Varies'
        IsCritical = $null
        Description = '(Vendor specific raw value.) Rate of seek errors of the magnetic heads. If there is a partial failure in the mechanical positioning system, then seek errors will arise. Such a failure may be due to numerous factors, such as damage to a servo, or thermal widening of the hard disk. The raw value has different structure for different vendors and is often not meaningful as a decimal number.'
    },
    [ordered]@{
        AttributeID = 8
        AttributeIDHex = '8'
        AttributeName = 'Seek Time Performance'
        BetterValue = 'High'
        IsCritical = $null
        Description = 'Average performance of seek operations of the magnetic heads. If this attribute is decreasing, it is a sign of problems in the mechanical subsystem.'
    },
    [ordered]@{
        AttributeID = 9
        AttributeIDHex = '9'
        AttributeName = 'Power-On Hours'
        BetterValue = ''
        IsCritical = $null
        Description = 'Count of hours in power-on state. The raw value of this attribute shows total count of hours (or minutes, or seconds, depending on manufacturer) in power-on state.
"By default, the total expected lifetime of a hard disk in perfect condition is defined as 5 years (running every day and night on all days). This is equal to 1825 days in 24/7 mode or 43800 hours."
On some pre-2005 drives, this raw value may advance erratically and/or "wrap around" (reset to zero periodically).'
    },
    [ordered]@{
        AttributeID = 10
        AttributeIDHex = 'A'
        AttributeName = 'Spin Retry Count'
        BetterValue = 'Low'
        IsCritical = $true
        Description = 'Count of retry of spin start attempts. This attribute stores a total count of the spin start attempts to reach the fully operational speed (under the condition that the first attempt was unsuccessful). An increase of this attribute value is a sign of problems in the hard disk mechanical subsystem.'
    },
    [ordered]@{
        AttributeID = 11
        AttributeIDHex = 'B'
        AttributeName = 'Calibration Retry Count'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Also known as "Calibration Retries". This attribute indicates the count that recalibration was requested (under the condition that the first attempt was unsuccessful). An increase of this attribute value is a sign of problems in the hard disk mechanical subsystem.'
    },
    [ordered]@{
        AttributeID = 12
        AttributeIDHex = 'C'
        AttributeName = 'Power Cycle Count'
        BetterValue = ''
        IsCritical = $null
        Description = 'This attribute indicates the count of full hard disk power on/off cycles.'
    },
    [ordered]@{
        AttributeID = 13
        AttributeIDHex = 'D'
        AttributeName = 'Soft Read Error Rate'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Uncorrected read errors reported to the operating system.'
    },
    [ordered]@{
        AttributeID = 22
        AttributeIDHex = '16'
        AttributeName = 'Current Helium Level'
        BetterValue = ''
        IsCritical = $null
        Description = 'Specific to He8 drives from HGST. This value measures the helium inside of the drive specific to this manufacturer. It is a pre-fail attribute that trips once the drive detects that the internal environment is out of specification.'
    },
    [ordered]@{
        AttributeID = 170
        AttributeIDHex = 'AA'
        AttributeName = 'Available Reserved Space'
        BetterValue = ''
        IsCritical = $null
        Description = 'Identical to attribute 232 (E8)'
    },
    [ordered]@{
        AttributeID = 171
        AttributeIDHex = 'AB'
        AttributeName = 'SSD Program Fail Count'
        BetterValue = ''
        IsCritical = $null
        Description = '(Kingston) The total number of flash program operation failures since the drive was deployed. Identical to attribute 181.'
    },
    [ordered]@{
        AttributeID = 172
        AttributeIDHex = 'AC'
        AttributeName = 'SSD Erase Fail Count'
        BetterValue = ''
        IsCritical = $null
        Description = '(Kingston) Counts the number of flash erase failures. This attribute returns the total number of Flash erase operation failures since the drive was deployed. This attribute is identical to attribute 182.'
    },
    [ordered]@{
        AttributeID = 173
        AttributeIDHex = 'AD'
        AttributeName = 'SSD Wear Leveling Count'
        BetterValue = ''
        IsCritical = $null
        Description = 'Counts the maximum worst erase count on any block.'
    },
    [ordered]@{
        AttributeID = 174
        AttributeIDHex = 'AE'
        AttributeName = 'Unexpected power loss count'
        BetterValue = ''
        IsCritical = $null
        Description = 'Also known as "Power-off Retract Count" per conventional HDD terminology. Raw value reports the number of unclean shutdowns, cumulative over the life of an SSD, where an "unclean shutdown" is the removal of power without STANDBY IMMEDIATE as the last command (regardless of PLI activity using capacitor power). Normalized value is always 100.'
    },
    [ordered]@{
        AttributeID = 175
        AttributeIDHex = 'AF'
        AttributeName = 'Power Loss Protection Failure'
        BetterValue = ''
        IsCritical = $null
        Description = 'Last test result as microseconds to discharge cap, saturated at its maximum value. Also logs minutes since last test and lifetime number of tests. Raw value contains the following data:
Bytes 0-1: Last test result as microseconds to discharge cap, saturates at max value. Test result expected in range 25 <= result <= 5000000, lower indicates specific error code.
Bytes 2-3: Minutes since last test, saturates at max value.
Bytes 4-5: Lifetime number of tests, not incremented on power cycle, saturates at max value.
Normalized value is set to one on test failure or 11 if the capacitor has been tested in an excessive temperature condition, otherwise 100.'
    },
    [ordered]@{
        AttributeID = 176
        AttributeIDHex = 'B0'
        AttributeName = 'Erase Fail Count'
        BetterValue = ''
        IsCritical = $null
        Description = 'S.M.A.R.T. parameter indicates a number of flash erase command failures.'
    },
    [ordered]@{
        AttributeID = 177
        AttributeIDHex = 'B1'
        AttributeName = 'Wear Range Delta'
        BetterValue = ''
        IsCritical = $null
        Description = 'Delta between most-worn and least-worn Flash blocks. It describes how good/bad the wearleveling of the SSD works on a more technical way.'
    },
    [ordered]@{
        AttributeID = 179
        AttributeIDHex = 'B3'
        AttributeName = 'Used Reserved Block Count Total'
        BetterValue = ''
        IsCritical = $null
        Description = '"Pre-Fail" attribute used at least in Samsung devices.'
    },
    [ordered]@{
        AttributeID = 180
        AttributeIDHex = 'B4'
        AttributeName = 'Unused Reserved Block Count Total'
        BetterValue = ''
        IsCritical = $null
        Description = '"Pre-Fail" attribute used at least in HP devices.'
    },
    [ordered]@{
        AttributeID = 181
        AttributeIDHex = 'B5'
        AttributeName = 'Program Fail Count Total'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Also known as "Non-4K Aligned Access Count". Total number of Flash program operation failures since the drive was deployed.
Number of user data accesses (both reads and writes) where LBAs are not 4 KiB aligned (LBA % 8 != 0) or where size is not modulus 4 KiB (block count != 8), assuming logical block size (LBS) = 512 B.'
    },
    [ordered]@{
        AttributeID = 182
        AttributeIDHex = 'B6'
        AttributeName = 'Erase Fail Count'
        BetterValue = ''
        IsCritical = $null
        Description = '"Pre-Fail" Attribute used at least in Samsung devices.'
    },
    [ordered]@{
        AttributeID = 183
        AttributeIDHex = 'B7'
        AttributeName = 'SATA Downshift Error Count'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Also known as "Runtine Bad Block". Western Digital, Samsung or Seagate attribute: Either the number of downshifts of link speed (e.g. from 6Gbps to 3Gbps) or the total number of data blocks with detected, uncorrectable errors encountered during normal operation. Although degradation of this parameter can be an indicator of drive aging and/or potential electromechanical problems, it does not directly indicate imminent drive failure.'
    },
    [ordered]@{
        AttributeID = 184
        AttributeIDHex = 'B8'
        AttributeName = 'End-to-End Error / IOEDC'
        BetterValue = 'Low'
        IsCritical = $true
        Description = 'This attribute is a part of Hewlett-Packard''s SMART IV technology, as well as part of other vendors'' IO Error Detection and Correction schemas, and it contains a count of parity errors which occur in the data path to the media via the drive''s cache RAM.'
    },
    [ordered]@{
        AttributeID = 185
        AttributeIDHex = 'B9'
        AttributeName = 'Head Stability'
        BetterValue = ''
        IsCritical = $null
        Description = 'Western Digital attribute.'
    },
    [ordered]@{
        AttributeID = 186
        AttributeIDHex = 'BA'
        AttributeName = 'Induced Op-Vibration Detection'
        BetterValue = ''
        IsCritical = $null
        Description = 'Western Digital attribute.'
    },
    [ordered]@{
        AttributeID = 187
        AttributeIDHex = 'BB'
        AttributeName = 'Reported Uncorrectable Errors'
        BetterValue = 'Low'
        IsCritical = $true
        Description = 'The count of errors that could not be recovered using hardware ECC (see attribute 195).'
    },
    [ordered]@{
        AttributeID = 188
        AttributeIDHex = 'BC'
        AttributeName = 'Command Timeout'
        BetterValue = 'Low'
        IsCritical = $true
        Description = 'The count of aborted operations due to HDD timeout. Normally this attribute value should be equal to zero.'
    },
    [ordered]@{
        AttributeID = 189
        AttributeIDHex = 'BD'
        AttributeName = 'High Fly Writes'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'HDD manufacturers implement a flying height sensor that attempts to provide additional protections for write operations by detecting when a recording head is flying outside its normal operating range. If an unsafe fly height condition is encountered, the write process is stopped, and the information is rewritten or reallocated to a safe region of the hard drive. This attribute indicates the count of these errors detected over the lifetime of the drive.
This feature is implemented in most modern Seagate drives and some of Western Digital''s drives, beginning with the WD Enterprise WDE18300 and WDE9180 Ultra2 SCSI hard drives, and will be included on all future WD Enterprise products.'
    },
    [ordered]@{
        AttributeID = 190
        AttributeIDHex = 'BE'
        AttributeName = 'Temperature Difference'
        BetterValue = 'Varies'
        IsCritical = $null
        Description = 'Also known as "Airflow Temperature". Value is equal to (100-temp. °C), allowing manufacturer to set a minimum threshold which corresponds to a maximum temperature. This also follows the convention of 100 being a best-case value and lower values being undesirable. However, some older drives may instead report raw Temperature (identical to 0xC2) or Temperature minus 50 here.'
    },
    [ordered]@{
        AttributeID = 191
        AttributeIDHex = 'BF'
        AttributeName = 'G-Sense Error Rate'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'The count of errors resulting from externally induced shock and vibration.'
    },
    [ordered]@{
        AttributeID = 192
        AttributeIDHex = 'C0'
        AttributeName = 'Power-off Retract Count'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Also known as "Emergency Retract Cycle Count" (Fujitsu) or "Unsafe Shutdown Count". Number of power-off or emergency retract cycles.'
    },
    [ordered]@{
        AttributeID = 193
        AttributeIDHex = 'C1'
        AttributeName = 'Load Cycle Count'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Also known as "Load/Unload Cycle Count" (Fujitsu). Count of load/unload cycles into head landing zone position. Some drives use 225 (0xE1) for Load Cycle Count instead.
Western Digital rates their VelociRaptor drives for 600,000 load/unload cycles, and WD Green drives for 300,000 cycles; the latter ones are designed to unload heads often to conserve power. On the other hand, the WD3000GLFS (a desktop drive) is specified for only 50,000 load/unload cycles.
Some laptop drives and "green power" desktop drives are programmed to unload the heads whenever there has not been any activity for a short period, to save power. Operating systems often access the file system a few times a minute in the background, causing 100 or more load cycles per hour if the heads unload: the load cycle rating may be exceeded in less than a year. There are programs for most operating systems that disable the Advanced Power Management (APM) and Automatic acoustic management (AAM) features causing frequent load cycles.'
    },
    [ordered]@{
        AttributeID = 194
        AttributeIDHex = 'C2'
        AttributeName = 'Temperature'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Indicates the device temperature, if the appropriate sensor is fitted. Lowest byte of the raw value contains the exact temperature value (Celsius degrees).'
    },
    [ordered]@{
        AttributeID = 195
        AttributeIDHex = 'C3'
        AttributeName = 'Hardware ECC Recovered'
        BetterValue = 'Varies'
        IsCritical = $null
        Description = '(Vendor-specific raw value.) The raw value has different structure for different vendors and is often not meaningful as a decimal number.'
    },
    [ordered]@{
        AttributeID = 196
        AttributeIDHex = 'C4'
        AttributeName = 'Reallocation Event Count'
        BetterValue = 'Low'
        IsCritical = $true
        Description = 'Count of remap operations. The raw value of this attribute shows the total count of attempts to transfer data from reallocated sectors to a spare area. Both successful and unsuccessful attempts are counted.'
    },
    [ordered]@{
        AttributeID = 197
        AttributeIDHex = 'C5'
        AttributeName = 'Current Pending Sector Count'
        BetterValue = 'Low'
        IsCritical = $true
        Description = 'Count of "unstable" sectors (waiting to be remapped, because of unrecoverable read errors). If an unstable sector is subsequently read successfully, the sector is remapped and this value is decreased. Read errors on a sector will not remap the sector immediately (since the correct value cannot be read and so the value to remap is not known, and also it might become readable later); instead, the drive firmware remembers that the sector needs to be remapped, and will remap it the next time it''s written.
However, some drives will not immediately remap such sectors when written; instead the drive will first attempt to write to the problem sector and if the write operation is successful then the sector will be marked good (in this case, the "Reallocation Event Count" (0xC4) will not be increased). This is a serious shortcoming, for if such a drive contains marginal sectors that consistently fail only after some time has passed following a successful write operation, then the drive will never remap these problem sectors.'
    },
    [ordered]@{
        AttributeID = 198
        AttributeIDHex = 'C6'
        AttributeName = 'Offline Uncorrectable Sector Count'
        BetterValue = 'Low'
        IsCritical = $true
        Description = 'The total count of uncorrectable errors when reading/writing a sector. A rise in the value of this attribute indicates defects of the disk surface and/or problems in the mechanical subsystem.'
    },
    [ordered]@{
        AttributeID = 199
        AttributeIDHex = 'C7'
        AttributeName = 'Ultra DMA CRC Error Count'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'The count of errors in data transfer via the interface cable as determined by ICRC (Interface Cyclic Redundancy Check).'
    },
    [ordered]@{
        AttributeID = 200
        AttributeIDHex = 'C8'
        AttributeName = 'Write Error Rate'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Also known as "Multi-Zone Error Rate". The count of errors found when writing a sector. The higher the value, the worse the disk''s mechanical condition is.'
    },
    [ordered]@{
        AttributeID = 201
        AttributeIDHex = 'C9'
        AttributeName = 'Soft Read Error Rate'
        BetterValue = 'Low'
        IsCritical = $true
        Description = 'Also known as "TA Counter Detected". Count indicates the number of uncorrectable software read errors.'
    },
    [ordered]@{
        AttributeID = 202
        AttributeIDHex = 'CA'
        AttributeName = 'Data Address Mark Errors'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Also known as "TA Counter Increased". Count of Data Address Mark errors (or vendor-specific).'
    },
    [ordered]@{
        AttributeID = 203
        AttributeIDHex = 'CB'
        AttributeName = 'Run Out Cancel'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'The number of errors caused by incorrect checksum during the error correction.'
    },
    [ordered]@{
        AttributeID = 204
        AttributeIDHex = 'CC'
        AttributeName = 'Soft ECC correction'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Count of errors corrected by the internal error correction software.'
    },
    [ordered]@{
        AttributeID = 205
        AttributeIDHex = 'CD'
        AttributeName = 'Thermal Asperity Rate'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Count of errors due to high temperature.'
    },
    [ordered]@{
        AttributeID = 206
        AttributeIDHex = 'CE'
        AttributeName = 'Flying Height'
        BetterValue = ''
        IsCritical = $null
        Description = 'Height of heads above the disk surface. If too low, head crash is more likely; if too high, read/write errors are more likely.'
    },
    [ordered]@{
        AttributeID = 207
        AttributeIDHex = 'CF'
        AttributeName = 'Spin High Current'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Amount of surge current used to spin up the drive.'
    },
    [ordered]@{
        AttributeID = 208
        AttributeIDHex = 'D0'
        AttributeName = 'Spin Buzz'
        BetterValue = ''
        IsCritical = $null
        Description = 'Count of buzz routines needed to spin up the drive due to insufficient power.'
    },
    [ordered]@{
        AttributeID = 209
        AttributeIDHex = 'D1'
        AttributeName = 'Offline Seek Performance'
        BetterValue = ''
        IsCritical = $null
        Description = 'Drive''s seek performance during its internal tests.'
    },
    [ordered]@{
        AttributeID = 210
        AttributeIDHex = 'D2'
        AttributeName = 'Vibration Diring Write'
        BetterValue = ''
        IsCritical = $null
        Description = 'Found in Maxtor 6B200M0 200GB and Maxtor 2R015H1 15GB disks.'
    },
    [ordered]@{
        AttributeID = 211
        AttributeIDHex = 'D3'
        AttributeName = 'Vibration Diring Write'
        BetterValue = ''
        IsCritical = $null
        Description = 'A recording of a vibration encountered during write operations.'
    },
    [ordered]@{
        AttributeID = 212
        AttributeIDHex = 'D4'
        AttributeName = 'Shock During Write'
        BetterValue = ''
        IsCritical = $null
        Description = 'A recording of shock encountered during write operations.'
    },
    [ordered]@{
        AttributeID = 220
        AttributeIDHex = 'DC'
        AttributeName = 'Disk Shift'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Distance the disk has shifted relative to the spindle (usually due to shock or temperature). Unit of measure is unknown.'
    },
    [ordered]@{
        AttributeID = 221
        AttributeIDHex = 'DD'
        AttributeName = 'G-Sense Error Rate'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'The count of errors resulting from externally induced shock and vibration.'
    },
    [ordered]@{
        AttributeID = 222
        AttributeIDHex = 'DE'
        AttributeName = 'Loaded Hours'
        BetterValue = ''
        IsCritical = $null
        Description = 'Time spent operating under data load (movement of magnetic head armature).'
    },
    [ordered]@{
        AttributeID = 223
        AttributeIDHex = 'DF'
        AttributeName = 'Load/Unload Retry Count'
        BetterValue = ''
        IsCritical = $null
        Description = 'Count of times head changes position.'
    },
    [ordered]@{
        AttributeID = 224
        AttributeIDHex = 'E0'
        AttributeName = 'Load Friction'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Resistance caused by friction in mechanical parts while operating.'
    },
    [ordered]@{
        AttributeID = 225
        AttributeIDHex = 'E1'
        AttributeName = 'Load/Unload Cycle Count'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Total count of load cycles. Some drives use 193 (0xC1) for Load Cycle Count instead. See Description for 193 for significance of this number.'
    },
    [ordered]@{
        AttributeID = 226
        AttributeIDHex = 'E2'
        AttributeName = 'Load "In"-time'
        BetterValue = ''
        IsCritical = $null
        Description = 'Total time of loading on the magnetic heads actuator (time not spent in parking area).'
    },
    [ordered]@{
        AttributeID = 227
        AttributeIDHex = 'E3'
        AttributeName = 'Torque Amplification Count'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Count of attempts to compensate for platter speed variations.'
    },
    [ordered]@{
        AttributeID = 228
        AttributeIDHex = 'E4'
        AttributeName = 'Power-Off Retract Cycle'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'The number of power-off cycles which are counted whenever there is a "retract event" and the heads are loaded off of the media such as when the machine is powered down, put to sleep, or is idle.'
    },
    [ordered]@{
        AttributeID = 230
        AttributeIDHex = 'E6'
        AttributeName = 'GMR Head Amplitude (magnetic HDDs), Drive Life Protection Status (SSDs)'
        BetterValue = ''
        IsCritical = $null
        Description = 'Amplitude of "thrashing" (repetitive head moving motions between operations). In solid-state drives, indicates whether usage trajectory is outpacing the expected life curve.'
    },
    [ordered]@{
        AttributeID = 231
        AttributeIDHex = 'E7'
        AttributeName = 'Life Left (SSDs) or Temperature'
        BetterValue = ''
        IsCritical = $null
        Description = 'Indicates the approximate SSD life left, in terms of program/erase cycles or available reserved blocks. A normalized value of 100 represents a new drive, with a threshold value at 10 indicating a need for replacement. A value of 0 may mean that the drive is operating in read-only mode to allow data recovery. Previously (pre-2010) occasionally used for Drive Temperature (more typically reported at 0xC2).'
    },
    [ordered]@{
        AttributeID = 232
        AttributeIDHex = 'E8'
        AttributeName = 'Endurance Remaining or Available Reserved Space'
        BetterValue = ''
        IsCritical = $null
        Description = 'Number of physical erase cycles completed on the SSD as a percentage of the maximum physical erase cycles the drive is designed to endure. Intel SSDs report the available reserved space as a percentage of the initial reserved space.'
    },
    [ordered]@{
        AttributeID = 233
        AttributeIDHex = 'E9'
        AttributeName = 'Media Wearout Indicator (SSDs) or Power-On Hours'
        BetterValue = ''
        IsCritical = $null
        Description = 'Intel SSDs report a normalized value from 100, a new drive, to a minimum of 1. It decreases while the NAND erase cycles increase from 0 to the maximum-rated cycles. Previously (pre-2010) occasionally used for Power-On Hours (more typically reported in 0x09).'
    },
    [ordered]@{
        AttributeID = 234
        AttributeIDHex = 'EA'
        AttributeName = 'Average erase count AND Maximum Erase Count'
        BetterValue = ''
        IsCritical = $null
        Description = 'Decoded as: byte 0-1-2 = average erase count (big endian) and byte 3-4-5 = max erase count (big endian).'
    },
    [ordered]@{
        AttributeID = 235
        AttributeIDHex = 'EB'
        AttributeName = 'Good Block Count AND System(Free) Block Count'
        BetterValue = ''
        IsCritical = $null
        Description = 'Decoded as: byte 0-1-2 = good block count (big endian) and byte 3-4 = system (free) block count.'
    },
    [ordered]@{
        AttributeID = 240
        AttributeIDHex = 'F0'
        AttributeName = 'Head Flying Hours or Transfer Error Rate (Fujitsu)'
        BetterValue = ''
        IsCritical = $null
        Description = 'Time spent during the positioning of the drive heads. Some Fujitsu drives report the count of link resets during a data transfer.'
    },
    [ordered]@{
        AttributeID = 241
        AttributeIDHex = 'F1'
        AttributeName = 'Total LBAs Written'
        BetterValue = ''
        IsCritical = $null
        Description = 'Total count of LBAs written.'
    },
    [ordered]@{
        AttributeID = 242
        AttributeIDHex = 'F2'
        AttributeName = 'Total LBAs Read'
        BetterValue = ''
        IsCritical = $null
        Description = 'Total count of LBAs read. Some S.M.A.R.T. utilities will report a negative number for the raw value since in reality it has 48 bits rather than 32.'
    },
    [ordered]@{
        AttributeID = 243
        AttributeIDHex = 'F3'
        AttributeName = 'Total LBAs Written Expanded'
        BetterValue = ''
        IsCritical = $null
        Description = 'The upper 5 bytes of the 12-byte total number of LBAs written to the device. The lower 7 byte value is located at attribute 0xF1.'
    },
    [ordered]@{
        AttributeID = 244
        AttributeIDHex = 'F4'
        AttributeName = 'Total LBAs Read Expanded'
        BetterValue = ''
        IsCritical = $null
        Description = 'The upper 5 bytes of the 12-byte total number of LBAs read from the device. The lower 7 byte value is located at attribute 0xF2.'
    },
    [ordered]@{
        AttributeID = 249
        AttributeIDHex = 'F9'
        AttributeName = 'NAND Writes (1GiB)'
        BetterValue = ''
        IsCritical = $null
        Description = 'Total NAND Writes. Raw value reports the number of writes to NAND in 1 GB increments.'
    },
    [ordered]@{
        AttributeID = 250
        AttributeIDHex = 'FA'
        AttributeName = 'Read Error Retry Rate'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Count of errors while reading from a disk.'
    },
    [ordered]@{
        AttributeID = 251
        AttributeIDHex = 'FB'
        AttributeName = 'Minimum Spares Remaining'
        BetterValue = ''
        IsCritical = $null
        Description = 'The Minimum Spares Remaining attribute indicates the number of remaining spare blocks as a percentage of the total number of spare blocks available.'
    },
    [ordered]@{
        AttributeID = 252
        AttributeIDHex = 'FC'
        AttributeName = 'Newly Added Bad Flash Block'
        BetterValue = ''
        IsCritical = $null
        Description = 'The Newly Added Bad Flash Block attribute indicates the total number of bad flash blocks the drive detected since it was first initialized in manufacturing.'
    },
    [ordered]@{
        AttributeID = 254
        AttributeIDHex = 'FE'
        AttributeName = 'Free Fall Protection'
        BetterValue = 'Low'
        IsCritical = $null
        Description = 'Count of "Free Fall Events" detected.'
    }
)

$defaultAttributes = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($defaultAttributeHash in $defaultAttributesHash)
{
    $defaultAttributes.Add([PSCustomObject]$defaultAttributeHash)
}