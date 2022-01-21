---
external help file: DiskSmartInfo-help.xml
Module Name: DiskSmartInfo
online version:
schema: 2.0.0
---

# Get-DiskSmartInfo

## SYNOPSIS
Командлет получает информацию SMART жестких дисков

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
Командлет получает информацию SMART (Self-Monitoring, Analysis and Reporting Technology) жестких дисков

## PARAMETERS

### -ComputerName
Параметр указывает имена компьютеров для получения информации.

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
Параметр добавляет ковертированные данные для некоторых атрибутов.

Такими атрибутами являются: "Spin-Up Time" (показывает данные в секундах),
"Power-On Hours" (показывает данные в днях),
"Temperature Difference" (показывает действительную температуру),
и "Total LBAs Written" (показывает данные в терабайтах).
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
Параметр отображает только критические атрибуты.

Вы можете получить список критических атрибутов при помощи команды
Get-DiskSmartAttributeDescription -CriticalOnly

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
Параметр отображает только те атрибуты, чьи значения находятся в состоянии Warning или Critical.

Если атрибут относится к критичным, он отображается, если его значение (Data) больше 0.

Если атрибут к критичным не относится, он отображается, если его значение (Value) меньше или равняется пороговому значению (Threshold).

Если диск не содержит атрибутов, чьи значения находятся в состоянии Warning или Critical, то сведения о нем не отображаются.

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

### Example 1: Получение данных SMART
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

Команда получает информацию SMART жестких дисков

### Example 2: Конвертированные данные
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

Команда получает информацию SMART жестких дисков и добавляет конвертированные данные для некоторых атрибутов.

### Example 3: Только критические атрибуты
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

Команда получает информацию SMART жестких дисков и выводит данные только критических атрибутов.

### Example 4: Вывод данных только тех атрибутов, чьи значения находятся в состоянии Warning или Critical
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

Команда получает информацию SMART жестких дисков и отображает только те атрибуты, чьи значения находятся в состоянии Warning или Critical.

Если диск не содержит атрибутов, чьи значения находятся в состоянии Warning или Critical, то сведения о нем не отображаются.

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
