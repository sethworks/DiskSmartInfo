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

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

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

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
