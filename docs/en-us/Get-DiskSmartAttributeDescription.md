---
external help file: DiskSmartInfo-help.xml
Module Name: DiskSmartInfo
online version:
schema: 2.0.0
---

# Get-DiskSmartAttributeDescription

## SYNOPSIS
Gets SMART attributes description

## SYNTAX

### AllAttributes (Default)
```
Get-DiskSmartAttributeDescription [<CommonParameters>]
```

### AttributeID
```
Get-DiskSmartAttributeDescription [-AttributeID <Int32>] [<CommonParameters>]
```

### AttributeIDHex
```
Get-DiskSmartAttributeDescription [-AttributeIDHex <String>] [<CommonParameters>]
```

### CriticalOnly
```
Get-DiskSmartAttributeDescription [-CriticalOnly] [<CommonParameters>]
```

## DESCRIPTION
Cmdlet gets SMART (Self-Monitoring, Analysis and Reporting Technology) attributes description

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AttributeID
Specifies attribute id.

```yaml
Type: Int32
Parameter Sets: AttributeID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttributeIDHex
Specifies attribute id in hexadecimal.

```yaml
Type: String
Parameter Sets: AttributeIDHex
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CriticalOnly
Displays critical attributes only.

```yaml
Type: SwitchParameter
Parameter Sets: CriticalOnly
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
