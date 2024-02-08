---
external help file: DiskSmartInfo-help.xml
Module Name: DiskSmartInfo
online version:
schema: 2.0.0
---

# Get-DiskSmartInfo

## SYNOPSIS
Gets disk SMART information

## SYNTAX

### ComputerName (Default)
```
Get-DiskSmartInfo [[-ComputerName] <String[]>] [-ShowConverted] [-CriticalAttributesOnly] 
[-Quiet] [<CommonParameters>]
```

### CimSession
```
Get-DiskSmartInfo -CimSession <String[]> [-ShowConverted] [-CriticalAttributesOnly] 
[-Quiet] CommonParameters>]
```

## DESCRIPTION
Cmdlet gets disk SMART (Self-Monitoring, Analysis and Reporting Technology) information

## PARAMETERS

### -ComputerName
Specifies computer names to query.

```yaml
Type: String[]
Parameter Sets: ComputerName
Aliases: PSComputerName

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -CimSession
Specifies CimSessions to query.

You can use both WSMAN and DCOM types of sessions.

```yaml
Type: CimSession[]
Parameter Sets: CimSession
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ShowConverted
Adds converted data for some of the attributes.

These conversions are defined as ConvertScriptBlock property of attributes, listed in
attributes/default.ps1 and attributes/proprietary.ps1 files.

For more information, see about_DiskSmartInfo_attributes.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CriticalAttributesOnly
Displays only critical attributes.

This is defined by IsCritical property of attributes, listed in
attributes/default.ps1 and attributes/proprietary.ps1 files.

For more information, see about_DiskSmartInfo_attributes.

If any of the attribute selection parameters are used, the result includes only critical attributes from specified.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DiskNumber
Specifies disk numbers to query.

Disk number corresponds to Index property of Win32_DiskDrive WMI class,
Number property of MSFT_Disk class (result of Get-Disk cmdlet),
DeviceId property of MSFT_PhysicalDisk class (result of Get-PhysicalDisk cmdlet),
and disk number in diskpart utility.

This parameter supports autocompletion. When -ComputerName or -CimSession parameters are not specified,
autocompletion suggests disks from local computer, where there are single ComputerName or CimSession
specified, autocompletion suggests disks from that computer. Autocompletion does not suggest disk numbers
if more than one ComputerName or CimSession specified.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: Index, Number, DeviceId

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DiskModel
Specified disk models to query.

Disk number corresponds to Model properties of MSFT_Disk class (result of Get-Disk cmdlet)
and MSFT_PhysicalDisk class (result of Get-PhysicalDisk cmdlet).

Actually, the cmdlet compares specified value to Model property of Win32_DiskDrive WMI class, after stripping
drive type suffix. For example, Model property of Win32_DiskDrive WMI class can be "Disk Model 2 TB ATA Device".
By default the cmdlet strips " ATA Device" suffix, so that the value corresponds to MSFT_Disk
and MSFT_PhysicalDisk Model property.

This can be changed by TrimDiskDriveModel config parameter.

This parameter supports autocompletion. When -ComputerName or -CimSession parameters are not specified,
autocompletion suggests disks from local computer, where there are single ComputerName or CimSession
specified, autocompletion suggests disks from that computer. Autocompletion does not suggest disk models
if more than one ComputerName or CimSession specified.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Model

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -AttributeID
Specifies attribute id.

The result is cumulative and includes all attributes specified in -AttributeID, -AttributeIDHex, and -AttributeName parameters.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttributeIDHex
Specifies attribute id in hexadecimal.

The result is cumulative and includes all attributes specified in -AttributeID, -AttributeIDHex, and -AttributeName parameters.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttributeName
Specifies attribute name.

The result is cumulative and includes all attributes specified in -AttributeID, -AttributeIDHex, and -AttributeName parameters.

This parameter supports autocompletion. Autocompletion suggests only default attributes and does not include proprietary ones.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Quiet
Displays only those attributes, that are critical and their Data is greater than 0,
or that are non-critical and their Value is less or equal to their Threshold.

If any of the attribute selection parameters are used, the result includes such an attributes only from specified.

If there are no such an attributes for a disk, that disk is not shown.

This can be changed by SuppressEmptySmartData config parameter.

For more inforrmation, see about_DiskSmartInfo_config.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowHistory
Displays previously saved history Data alongside current Data.

By default the cmdlet shows history data for all attribues, even if there were no changes occured.

This can be changed by ShowUnchangedHistoricalData config parameter.

For more inforrmation, see about_DiskSmartInfo_config.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UpdateHistory
Saves current Data for all disks of specified computers for later comparison.

It there are some data already saved for specific computer, the cmdlet overwrites it.
So the data it stored for one point in time only.

The cmdlet stores Data for all disks and attributes of specified computers,
even if disk selection or attribute selection parameters are used.

History by default is located in the history folder of the module directory.

This can be changed by HistoricalDataPath config parameter.

For more inforrmation, see about_DiskSmartInfo_config.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## EXAMPLES

### Example 1: Get disk SMART info
```powershell
Get-DiskSmartInfo
```

```
Model:        Disk model
InstanceId:   Disk Instance Id
SMARTData:

              ID  IDHex AttributeName                                 Threshold Value Worst Data
              --  ----- -------------                                 --------- ----- ----- ----
              5   5     Reallocated Sectors Count                     10        100   100   0
              9   9     Power-On Hours                                0         98    98    8397
              12  C     Power Cycle Count                             0         99    99    22
              177 B1    Wear Range Delta                              0         98    98    33
              179 B3    Used Reserved Block Count Total               10        100   100   0
              181 B5    Program Fail Count Total                      10        100   100   0
              182 B6    Erase Fail Count                              10        100   100   0
              183 B7    SATA Downshift Error Count                    10        100   100   0
              187 BB    Reported Uncorrectable Errors                 0         100   100   0
              190 BE    Temperature Difference                        0         53    48    47
              195 C3    Hardware ECC Recovered                        0         200   200   0
              199 C7    Ultra DMA CRC Error Count                     0         100   100   0
              235 EB    Good Block Count AND System(Free) Block Count 0         99    99    6
              241 F1    Total LBAs Written                            0         99    99    12720469069
```

The command gets disk SMART information.

### Example 2: Converted data
```powershell
Get-DiskSmartInfo -ShowConverted
```

```
Model:        Disk model
InstanceId:   Disk Instance Id
SMARTData:

              ID  IDHex AttributeName                                 Threshold Value Worst Data        ConvertedData
              --  ----- -------------                                 --------- ----- ----- ----        -------------
              5   5     Reallocated Sectors Count                     10        100   100   0
              9   9     Power-On Hours                                0         98    98    8397          349.88 Days
              12  C     Power Cycle Count                             0         99    99    22
              177 B1    Wear Range Delta                              0         98    98    33
              179 B3    Used Reserved Block Count Total               10        100   100   0
              181 B5    Program Fail Count Total                      10        100   100   0
              182 B6    Erase Fail Count                              10        100   100   0
              183 B7    SATA Downshift Error Count                    10        100   100   0
              187 BB    Reported Uncorrectable Errors                 0         100   100   0
              190 BE    Temperature Difference                        0         53    48    47                   53 C
              195 C3    Hardware ECC Recovered                        0         200   200   0
              199 C7    Ultra DMA CRC Error Count                     0         100   100   0
              235 EB    Good Block Count AND System(Free) Block Count 0         99    99    6
              241 F1    Total LBAs Written                            0         99    99    12720469069      5.923 Tb
```

The command gets disk SMART information and adds converted data for some of the attributes.

### Example 3: Critical attributes only
```powershell
Get-DiskSmartInfo -CriticalAttributesOnly
```

```
Model:        Disk model
InstanceId:   Disk Instance Id
SMARTData:

              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        252   252   0
              10  A     Spin Retry Count                   51        252   252   0
              196 C4    Reallocation Event Count           0         252   252   0
              197 C5    Current Pending Sector Count       0         252   252   0
              198 C6    Offline Uncorrectable Sector Count 0         252   252   0
```

The command gets disk SMART information and displays only critical attributes.

### Example 4: Silence if not in warning or critical state
```powershell
Get-DiskSmartInfo -Quiet
```

```
Model:        Disk model
InstanceId:   Disk Instance Id
SMARTData:

              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              3   3     Spin-Up Time                       21        20    20    6825
              197 C5    Current Pending Sector Count       0         200   200   20
              198 C6    Offline Uncorrectable Sector Count 0         200   200   20
```

The command gets disk SMART information and displays only the attributes with values in Warning or Critical state.
Disks that does not have attributes with values in such states does not display.

### Example 5: Silence if critical attributes are not in warning or critical state
```powershell
Get-DiskSmartInfo -CriticalAttributesOnly -Quiet
```

```
Model:        Disk model
InstanceId:   Disk Instance Id
SMARTData:

              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              197 C5    Current Pending Sector Count       0         200   200   20
              198 C6    Offline Uncorrectable Sector Count 0         200   200   20
```

The command gets disk SMART information and displays only the the critical attributes with values in Warning or Critical state.
Disks that does not have critical attributes with values in such states does not display.

### Example 6: Get disk SMART info from remote computers
```powershell
Get-DiskSmartInfo -ComputerName SomeComputer
```

```
ComputerName: SomeComputer
Model:        Disk model
InstanceId:   Disk Instance Id
SMARTData:

              ID  IDHex AttributeName                                 Threshold Value Worst Data
              --  ----- -------------                                 --------- ----- ----- ----
              5   5     Reallocated Sectors Count                     10        100   100   0
              9   9     Power-On Hours                                0         98    98    8397
              12  C     Power Cycle Count                             0         99    99    22
              177 B1    Wear Range Delta                              0         98    98    33
              179 B3    Used Reserved Block Count Total               10        100   100   0
              181 B5    Program Fail Count Total                      10        100   100   0
              182 B6    Erase Fail Count                              10        100   100   0
              183 B7    SATA Downshift Error Count                    10        100   100   0
              187 BB    Reported Uncorrectable Errors                 0         100   100   0
              190 BE    Temperature Difference                        0         53    48    47
              195 C3    Hardware ECC Recovered                        0         200   200   0
              199 C7    Ultra DMA CRC Error Count                     0         100   100   0
              235 EB    Good Block Count AND System(Free) Block Count 0         99    99    6
              241 F1    Total LBAs Written                            0         99    99    12720469069
```

The command gets disk SMART information from remote computer.

### Example 7: Get disk SMART info from remote computers without specifying -ComputerName parameter name
```powershell
Get-DiskSmartInfo SomeComputer
```

```
ComputerName: SomeComputer
Model:        Disk model
InstanceId:   Disk Instance Id
SMARTData:

              ID  IDHex AttributeName                                 Threshold Value Worst Data
              --  ----- -------------                                 --------- ----- ----- ----
              5   5     Reallocated Sectors Count                     10        100   100   0
              9   9     Power-On Hours                                0         98    98    8397
              12  C     Power Cycle Count                             0         99    99    22
              177 B1    Wear Range Delta                              0         98    98    33
              179 B3    Used Reserved Block Count Total               10        100   100   0
              181 B5    Program Fail Count Total                      10        100   100   0
              182 B6    Erase Fail Count                              10        100   100   0
              183 B7    SATA Downshift Error Count                    10        100   100   0
              187 BB    Reported Uncorrectable Errors                 0         100   100   0
              190 BE    Temperature Difference                        0         53    48    47
              195 C3    Hardware ECC Recovered                        0         200   200   0
              199 C7    Ultra DMA CRC Error Count                     0         100   100   0
              235 EB    Good Block Count AND System(Free) Block Count 0         99    99    6
              241 F1    Total LBAs Written                            0         99    99    12720469069
```

The command gets disk SMART information from remote computer.

### Example 8: Get disk SMART info from remote computers using CimSessions.
```powershell
$Credential = Get-Credential
$CimSession_WSMAN = New-CimSession -ComputerName SomeComputer -Credential $Credential

$SessionOption = New-CimSessionOption -Protocol Dcom
$CimSession_DCOM = New-CimSession -ComputerName SomeAnotherComputer -SessionOption $SessionOption -Credential $Credential

Get-DiskSmartInfo -CimSession $CimSession_WSMAN, $CimSession_DCOM
```

```
ComputerName: SomeComputer
Model:        Disk model
InstanceId:   Disk Instance Id
SMARTData:

              ID  IDHex AttributeName                                 Threshold Value Worst Data
              --  ----- -------------                                 --------- ----- ----- ----
              5   5     Reallocated Sectors Count                     10        100   100   0
              9   9     Power-On Hours                                0         98    98    8397
              12  C     Power Cycle Count                             0         99    99    22
              177 B1    Wear Range Delta                              0         98    98    33
              179 B3    Used Reserved Block Count Total               10        100   100   0
              181 B5    Program Fail Count Total                      10        100   100   0
              182 B6    Erase Fail Count                              10        100   100   0
              183 B7    SATA Downshift Error Count                    10        100   100   0
              187 BB    Reported Uncorrectable Errors                 0         100   100   0
              190 BE    Temperature Difference                        0         53    48    47
              195 C3    Hardware ECC Recovered                        0         200   200   0
              199 C7    Ultra DMA CRC Error Count                     0         100   100   0
              235 EB    Good Block Count AND System(Free) Block Count 0         99    99    6
              241 F1    Total LBAs Written                            0         99    99    12720469069


ComputerName: SomeAnotherComputer
Model:        Disk model
InstanceId:   Disk Instance Id
SMARTData:

              ID  IDHex AttributeName                                 Threshold Value Worst Data
              --  ----- -------------                                 --------- ----- ----- ----
              5   5     Reallocated Sectors Count                     10        100   100   0
              9   9     Power-On Hours                                0         98    98    9584
              12  C     Power Cycle Count                             0         99    99    80
...
```

The command gets disk SMART information from remote computers using CimSessions.

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
