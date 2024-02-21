---
external help file: DiskSmartInfo-help.xml
Module Name: DiskSmartInfo
online version:
schema: 2.0.0
---

# Get-DiskSmartAttributeDescription

## SYNOPSIS
Returns default SMART attributes description

## SYNTAX

### Default
```
Get-DiskSmartAttributeDescription [[-AttributeID] <Int32[]>] [-AttributeIDHex <String[]>]
 [-AttributeIDHex <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Cmdlet returns default SMART (Self-Monitoring, Analysis and Reporting Technology) attributes description

## PARAMETERS

### -AttributeID
Specifies attribute id.

The result is cumulative and includes all attributes specified in -AttributeID, -AttributeIDHex, and -AttributeName parameters.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
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

This parameter supports autocompletion.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## EXAMPLES

### Example 1: Get attributes description
```powershell
Get-DiskSmartAttributeDescription
```

```
AttributeID    : 1
AttributeIDHex : 1
AttributeName  : Read Error Rate
Description    : (Vendor specific raw value.) Stores data related to the rate of hardware read errors that occurred
                 when reading data from a disk surface. The raw value has different structure for different vendors
                 and is often not meaningful as a decimal number.

AttributeID    : 2
AttributeIDHex : 2
AttributeName  : Throughput Performance
Description    : Overall (general) throughput performance of a hard disk drive. If the value of this attribute is
                 decreasing there is a high probability that there is a problem with the disk.

...
```

The command gets SMART attributes description.

### Example 2: Get selected attributes
```powershell
Get-DiskSmartAttributeDescription -AttributeID 5 -AttributeIDHex BB -AttributeName "*ECC*"
```

```
AttributeID    : 5
AttributeIDHex : 5
AttributeName  : Reallocated Sectors Count
Description    : Count of reallocated sectors. The raw value represents a count of the bad sectors that have been
                 found and remapped. Thus, the higher the attribute value, the more sectors the drive has had to
                 reallocate. This value is primarily used as a metric of the life expectancy of the drive; a drive
                 which has had any reallocations at all is significantly more likely to fail in the immediate months.

AttributeID    : 187
AttributeIDHex : BB
AttributeName  : Reported Uncorrectable Errors
Description    : The count of errors that could not be recovered using hardware ECC (see attribute 195).

AttributeID    : 195
AttributeIDHex : C3
AttributeName  : Hardware ECC Recovered
Description    : (Vendor-specific raw value.) The raw value has different structure for different vendors and is often
                 not meaningful as a decimal number.
```

The command gets description for selected attributes.

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
