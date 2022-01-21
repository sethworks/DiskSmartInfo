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

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

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

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
