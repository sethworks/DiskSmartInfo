@{
    # HDD1
    CtlData_HDD1 = '
=== START OF INFORMATION SECTION ===
Model Family:     HDD1
Device Model:     HDD1
Serial Number:    1234567890
LU WWN Device Id: 5 0024e9 205f84c55
Firmware Version: 1AJ10001
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database
ATA Version is:   ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Sun Jul 27 17:55:08 2025 RTZST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail  Always       -       17
  2 Throughput_Performance  0x0026   252   252   000    Old_age   Always       -       0
  3 Spin_Up_Time            0x0023   071   069   025    Pre-fail  Always       -       9059
  4 Start_Stop_Count        0x0032   075   075   000    Old_age   Always       -       25733
  5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   252   252   051    Old_age   Always       -       0
  8 Seek_Time_Performance   0x0024   252   252   015    Old_age   Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       73446
 10 Spin_Retry_Count        0x0032   252   252   051    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Always       -       702
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       258
191 G-Sense_Error_Rate      0x0022   100   100   000    Old_age   Always       -       26
192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0002   061   053   000    Old_age   Always       -       39 (Min/Max 14/47)
195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age   Always       -       0
196 Reallocated_Event_Count 0x0032   252   252   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   252   252   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   252   252   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0036   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x002a   100   100   000    Old_age   Always       -       74
223 Load_Retry_Count        0x0032   100   100   000    Old_age   Always       -       702
225 Load_Cycle_Count        0x0032   098   098   000    Old_age   Always       -       26047'

    CtlDataPredictFailureTrue_HDD1 = '
=== START OF INFORMATION SECTION ===
Model Family:     HDD1
Device Model:     HDD1
Serial Number:    1234567890
LU WWN Device Id: 5 0024e9 205f84c55
Firmware Version: 1AJ10001
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database
ATA Version is:   ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Sun Jul 27 17:55:08 2025 RTZST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: FAILED

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail  Always       -       17
  2 Throughput_Performance  0x0026   252   252   000    Old_age   Always       -       0
  3 Spin_Up_Time            0x0023   071   069   025    Pre-fail  Always       -       9059
  4 Start_Stop_Count        0x0032   075   075   000    Old_age   Always       -       25733
  5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   252   252   051    Old_age   Always       -       0
  8 Seek_Time_Performance   0x0024   252   252   015    Old_age   Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       73446
 10 Spin_Retry_Count        0x0032   252   252   051    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Always       -       702
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       258
191 G-Sense_Error_Rate      0x0022   100   100   000    Old_age   Always       -       26
192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0002   061   053   000    Old_age   Always       -       39 (Min/Max 14/47)
195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age   Always       -       0
196 Reallocated_Event_Count 0x0032   252   252   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   252   252   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   252   252   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0036   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x002a   100   100   000    Old_age   Always       -       74
223 Load_Retry_Count        0x0032   100   100   000    Old_age   Always       -       702
225 Load_Cycle_Count        0x0032   098   098   000    Old_age   Always       -       26047'

    CtlIndex_HDD1 = 0
    CtlModel_HDD1 = "HDD1"
    CtlDevice_HDD1 = '/dev/sda'
    CtlScan_HDD1 = '/dev/sda -d ata # /dev/sda, ATA device'
    CtlPredictFailure_HDD1 = $false
    CtlPredictFailureTrue_HDD1 = $true
    CtlBytesPerSector_HDD1 = 512

    # HDD2
    CtlData_HDD2 = '
=== START OF INFORMATION SECTION ===
Model Family:     HDD2
Device Model:     HDD2
Serial Number:    1234567890
LU WWN Device Id: 5 0014ee 25e3ee2f0
Firmware Version: 01.01A01
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sun Jul 27 17:59:21 2025 RTZST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   199   197   051    Pre-fail  Always       -       76
  3 Spin_Up_Time            0x0027   020   020   021    Pre-fail  Always       -       6825
  4 Start_Stop_Count        0x0032   027   027   000    Old_age   Always       -       73592
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   039   039   000    Old_age   Always       -       45066
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       285
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       40
193 Load_Cycle_Count        0x0032   176   176   000    Old_age   Always       -       73551
194 Temperature_Celsius     0x0022   109   101   000    Old_age   Always       -       41
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       20
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       20
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       20'

    CtlIndex_HDD2 = 1
    CtlModel_HDD2 = "HDD2"
    CtlDevice_HDD2 = '/dev/sdb'
    CtlScan_HDD2 = '/dev/sdb -d ata # /dev/sdb, ATA device'
    CtlPredictFailure_HDD2 = $false
    CtlBytesPerSector_HDD2 = 512

    # SSD1
    CtlData_SSD1 = '
=== START OF INFORMATION SECTION ===
Model Family:     SSD1
Device Model:     SSD1
Serial Number:    1234567890
LU WWN Device Id: 5 002538 e90b7c931
Firmware Version: RVT04B6Q
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
TRIM Command:     Available, deterministic, zeroed
Device is:        In smartctl database
ATA Version is:   ACS-4 T13/BSR INCITS 529 revision 5
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sun Jul 27 18:02:54 2025 RTZST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   098   098   000    Old_age   Always       -       8414
 12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       22
177 Wear_Leveling_Count     0x0013   098   098   000    Pre-fail  Always       -       33
179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail  Always       -       0
181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age   Always       -       0
182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age   Always       -       0
183 Runtime_Bad_Block       0x0013   100   100   010    Pre-fail  Always       -       0
187 Uncorrectable_Error_Cnt 0x0032   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0032   060   048   000    Old_age   Always       -       40
195 ECC_Error_Rate          0x001a   200   200   000    Old_age   Always       -       0
199 CRC_Error_Count         0x003e   100   100   000    Old_age   Always       -       0
235 POR_Recovery_Count      0x0012   099   099   000    Old_age   Always       -       22
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       12740846422
242 Total_LBAs_Read         0x0032   099   099   000    Old_age   Always       -       9556432520'

    CtlIndex_SSD1 = 2
    CtlModel_SSD1 = "SSD1"
    CtlDevice_SSD1 = '/dev/sdc'
    CtlScan_SSD1 = '/dev/sdc -d ata # /dev/sdc, ATA device'
    CtlPredictFailure_SSD1 = $false
    CtlBytesPerSector_SSD1 = 512

    # SSD2
    CtlData_SSD2 = '
=== START OF INFORMATION SECTION ===
Model Family:     SSD2
Device Model:     SSD2
Serial Number:    1234567890
LU WWN Device Id: 5 002538 e90b7c931
Firmware Version: RVT04B6Q
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
TRIM Command:     Available, deterministic, zeroed
Device is:        In smartctl database
ATA Version is:   ACS-4 T13/BSR INCITS 529 revision 5
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sun Jul 27 18:02:54 2025 RTZST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   098   098   000    Old_age   Always       -       11998
 12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       15
177 Wear_Leveling_Count     0x0013   098   098   000    Pre-fail  Always       -       38
179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail  Always       -       0
181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age   Always       -       0
182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age   Always       -       0
183 Runtime_Bad_Block       0x0013   100   100   010    Pre-fail  Always       -       0
187 Uncorrectable_Error_Cnt 0x0032   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0032   060   048   000    Old_age   Always       -       42
195 ECC_Error_Rate          0x001a   200   200   000    Old_age   Always       -       0
199 CRC_Error_Count         0x003e   100   100   000    Old_age   Always       -       0
235 POR_Recovery_Count      0x0012   099   099   000    Old_age   Always       -       6
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       12757689431
242 Total_LBAs_Read         0x0032   099   099   000    Old_age   Always       -       9573275529
255 Artificial_Attr         0x0032   100   100   001    Old_age   Always       -       6618611909121'

    CtlIndex_SSD2 = 3
    CtlModel_SSD2 = "SSD2"
    CtlDevice_SSD2 = '/dev/sdd'
    CtlScan_SSD2 = '/dev/sdd -d ata # /dev/sdd, ATA device'
    CtlPredictFailure_SSD2 = $false
    CtlBytesPerSector_SSD2 = 512

    # HFSSSD1
    CtlData_HFSSSD1 = '
=== START OF INFORMATION SECTION ===
Model Family:     SK hynix SATA SSDs
Device Model:     HFS128G32TNF-N3A0A
Serial Number:    MJ89N605812109J6K
Firmware Version: 70000P10
User Capacity:    128,035,676,160 bytes [128 GB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
TRIM Command:     Available, deterministic, zeroed
Device is:        In smartctl database
ATA Version is:   ACS-3 (minor revision not indicated)
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Jul 27 18:17:12 2025 RTZST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART Attributes Data Structure revision number: 0
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   166   166   006    Pre-fail  Always       -       0
  5 Retired_Block_Count     0x0032   253   253   036    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   098   098   000    Old_age   Always       -       487
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       291
100 Total_Erase_Count       0x0032   100   100   000    Old_age   Always       -       174611
168 Min_Erase_Count         0x0032   100   100   000    Old_age   Always       -       3
169 Max_Erase_Count         0x0032   099   099   000    Old_age   Always       -       23
171 Program_Fail_Count      0x0032   253   253   000    Old_age   Always       -       0
172 Erase_Fail_Count        0x0032   253   253   000    Old_age   Always       -       0
173 Wear_Leveling_Count     0x0032   100   100   000    Old_age   Always       -       12
174 Unexpect_Power_Loss_Ct  0x0030   100   100   000    Old_age   Offline      -       6
175 Program_Fail_Count_Chip 0x0032   253   253   000    Old_age   Always       -       0
176 Unused_Rsvd_Blk_Cnt_Tot 0x0032   253   253   000    Old_age   Always       -       0
178 Used_Rsvd_Blk_Cnt_Chip  0x0032   253   253   000    Old_age   Always       -       0
179 Used_Rsvd_Blk_Cnt_Tot   0x0032   253   253   000    Old_age   Always       -       0
180 Erase_Fail_Count        0x0033   100   100   010    Pre-fail  Always       -       100
184 End-to-End_Error        0x0032   253   253   000    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   253   253   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   253   253   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0002   028   018   000    Old_age   Always       -       24 (Min/Max 19/41)
195 Hardware_ECC_Recovered  0x0032   253   253   000    Old_age   Always       -       0
196 Reallocated_Event_Count 0x0032   253   253   036    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0032   253   253   000    Old_age   Always       -       0
199 UDMA_CRC_Error_Count    0x0032   253   253   000    Old_age   Always       -       0
212 Phy_Error_Count         0x0032   100   100   000    Old_age   Always       -       2336
233 Media_Wearout_Indicator 0x0033   100   100   001    Pre-fail  Always       -       100
236 Unknown_SK_hynix_Attrib 0x0032   097   097   001    Old_age   Always       -       98
241 Total_Writes_GB         0x0032   100   100   000    Old_age   Always       -       2034
242 Total_Reads_GB          0x0032   100   100   000    Old_age   Always       -       2596
249 NAND_Writes_GiB         0x0032   100   100   000    Old_age   Always       -       1745'

    CtlIndex_HFSSSD1 = 4
    CtlModel_HFSSSD1 = "HFS512G32TNF-N3A0A"
    CtlDevice_HFSSSD1 = '/dev/sde'
    CtlScan_HFSSSD1 = '/dev/sde -d ata # /dev/sde, ATA device'
    CtlPredictFailure_HFSSSD1 = $false
    CtlBytesPerSector_HFSSSD1 = 512

    # KINGSTONSSD1
    CtlData_KINGSTONSSD1 = '
=== START OF INFORMATION SECTION ===
Model Family:     Phison Driven SSDs
Device Model:     KINGSTON SA400S37480G
Serial Number:    50026B778421AC56
LU WWN Device Id: 5 0026b7 78421ac56
Firmware Version: S3H01103
User Capacity:    480,103,981,056 bytes [480 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
TRIM Command:     Available
Device is:        In smartctl database
ATA Version is:   ACS-3 T13/2161-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Jul 29 16:03:22 2025 RTZ
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x0032   100   100   000    Old_age   Always       -       100
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       6240
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       870
148 Unknown_Attribute       0x0000   100   100   000    Old_age   Offline      -       2
149 Unknown_Attribute       0x0000   100   100   000    Old_age   Offline      -       0
167 Write_Protect_Mode      0x0000   100   100   000    Old_age   Offline      -       0
168 SATA_Phy_Error_Count    0x0012   100   100   000    Old_age   Always       -       0
169 Bad_Block_Rate          0x0000   100   100   000    Old_age   Offline      -       0
170 Bad_Blk_Ct_Lat/Erl      0x0000   100   100   010    Old_age   Offline      -       260/258
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       0
173 MaxAvgErase_Ct          0x0000   100   100   000    Old_age   Offline      -       0
181 Program_Fail_Count      0x0032   100   100   000    Old_age   Always       -       0
182 Erase_Fail_Count        0x0000   100   100   000    Old_age   Offline      -       2
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
192 Unsafe_Shutdown_Count   0x0012   100   100   000    Old_age   Always       -       19
194 Temperature_Celsius     0x0022   034   040   000    Old_age   Always       -       34 (Min/Max 18/40)
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       1
199 SATA_CRC_Error_Count    0x0032   100   100   000    Old_age   Always       -       0
218 CRC_Error_Count         0x0032   100   100   000    Old_age   Always       -       0
231 SSD_Life_Left           0x0000   095   095   000    Old_age   Offline      -       95
233 Flash_Writes_GiB        0x0032   100   100   000    Old_age   Always       -       1886
241 Lifetime_Writes_GiB     0x0032   100   100   000    Old_age   Always       -       7389
242 Lifetime_Reads_GiB      0x0032   100   100   000    Old_age   Always       -       7223
244 Average_Erase_Count     0x0000   100   100   000    Old_age   Offline      -       59
245 Max_Erase_Count         0x0000   100   100   000    Old_age   Offline      -       94
246 Total_Erase_Count       0x0000   100   100   000    Old_age   Offline      -       315801'

    CtlIndex_KINGSTONSSD1 = 5
    CtlModel_KINGSTONSSD1 = "KINGSTON SA400S37480G"
    CtlDevice_KINGSTONSSD1 = '/dev/sdf'
    CtlScan_KINGSTONSSD1 = '/dev/sdf -d ata # /dev/sdf, ATA device'
    CtlPredictFailure_KINGSTONSSD1 = $false
    CtlBytesPerSector_KINGSTONSSD1 = 512
}
