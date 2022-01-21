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

### DefaultParameterSet (Default)
```
Get-DiskSmartInfo [-ComputerName <String[]>] [-ShowConvertedData] [-CriticalAttributesOnly] [-NoWMIFallback]
 [<CommonParameters>]
```

### Silence
```
Get-DiskSmartInfo [-ComputerName <String[]>] [-ShowConvertedData] [-SilenceIfNotInWarningOrCriticalState]
 [-NoWMIFallback] [<CommonParameters>]
```

## DESCRIPTION
Cmdlet gets disk SMART (Self-Monitoring, Analysis and Reporting Technology) information

## PARAMETERS

### -ComputerName
Specifies computer names to get data.

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

### -ShowConvertedData
Adds converted data for some of the attributes.

Such attributes are: "Spin-Up Time" (displays value in seconds),
"Power-On Hours" (displays value in days),
"Temperature Difference" (shows actual temperature),
and "Total LBAs Written" (shows value in Tb).

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

You can get the list of such attributes by using the Get-DiskSmartAttributeDescription -CriticalOnly
command.

```yaml
Type: SwitchParameter
Parameter Sets: DefaultParameterSet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SilenceIfNotInWarningOrCriticalState
Displays only attributes, whose value is in Warning or Critical state.

If attribute if critical, it is shown, if its Data greater than 0.
If attribute is not critical, it is shown, if its Value is less or equal to its threshold.

If disk does not have attributes with values in Warning or Critical state, it is not shown.

```yaml
Type: SwitchParameter
Parameter Sets: Silence
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoWMIFallback
{{ Fill NoWMIFallback Description }}

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
Get-DiskSmartInfo -ShowConvertedData
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
Get-DiskSmartInfo -SilenceIfNotInWarningOrCriticalState
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

The command gets disk SMART information and displays only the attributes with values in Warning or Critical state.
Disks that does not have attributes with values in such states does not display.

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS