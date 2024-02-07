---
external help file: DiskSmartInfo-help.xml
Module Name: DiskSmartInfo
online version:
schema: 2.0.0
---

# Get-DiskSmartAttributeDescription

## SYNOPSIS
Командлет отображает описание общих атрибутов SMART

## SYNTAX

### Default
```
Get-DiskSmartAttributeDescription [[-AttributeID] <Int32[]>] [-AttributeIDHex <String[]>]
 [-AttributeIDHex <String[]>] [-CriticalOnly] [<CommonParameters>]
```

## DESCRIPTION
Командлет отображает описание общих атрибутов SMART (Self-Monitoring, Analysis and Reporting Technology)

## PARAMETERS

### -AttributeID
Параметр указывает идентификатор атрибута.

Результат включает в себя все атрибуты, указанные в параметрах -AttributeID, -AttributeIDHex и -AttributeName.

```yaml
Type: Int32[]
Parameter Sets: Default
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttributeIDHex
Параметр указывает идентификатор атрибута в шестнадцатеричном формате.

Результат включает в себя все атрибуты, указанные в параметрах -AttributeID, -AttributeIDHex и -AttributeName.

```yaml
Type: String[]
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttributeName
Параметр указывает имя атрибута.

Результат включает в себя все атрибуты, указанные в параметрах -AttributeID, -AttributeIDHex и -AttributeName.

Этот параметр поддерживает автоматическое завершение значений.

```yaml
Type: String[]
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CriticalOnly
Параметр задает, что выводиться должны только критические атрибуты.

Если заданы любые из параметров идентификации атрибутов, результат включает в себя только
критические атрибуты из указанных.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
Командлет поддерживает общие параметры: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. Дополнительная информация [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## EXAMPLES

### Example 1: Получение описания атрибутов
```powershell
Get-DiskSmartAttributeDescription
```

```
AttributeID    : 1
AttributeIDHex : 1
AttributeName  : Read Error Rate
BetterValue    : Low
IsCritical     :
Description    : (Vendor specific raw value.) Stores data related to the rate of hardware read errors that occurred when reading data from a disk surface. The raw value has different structure for different vendors and is often not meaningful as a decimal number.

AttributeID    : 2
AttributeIDHex : 2
AttributeName  : Throughput Performance
BetterValue    : High
IsCritical     :
Description    : Overall (general) throughput performance of a hard disk drive. If the value of this attribute is decreasing there is a high probability that there is a problem with the disk.

...
```

Команда отображает описание атрибутов SMART.

### Example 2: Получение описания атрибута по ID
```powershell
Get-DiskSmartAttributeDescription -AttributeID 192
```

```
AttributeID    : 192
AttributeIDHex : C0
AttributeName  : Power-off Retract Count
BetterValue    : Low
IsCritical     :
Description    : Also known as "Emergency Retract Cycle Count" (Fujitsu) or "Unsafe Shutdown Count". Number of power-off or emergency retract cycles.
```

Команда отображает описание атрибута с ID 192.

### Example 3: Получение описания атрибута по ID без указания имени параметра AttributeID
```powershell
Get-DiskSmartAttributeDescription 192
```

```
AttributeID    : 192
AttributeIDHex : C0
AttributeName  : Power-off Retract Count
BetterValue    : Low
IsCritical     :
Description    : Also known as "Emergency Retract Cycle Count" (Fujitsu) or "Unsafe Shutdown Count". Number of power-off or emergency retract cycles.
```

Команда отображает описание атрибута с ID 192.

### Example 4: Получение описания атрибута по IDHex
```powershell
Get-DiskSmartAttributeDescription -AttributeIDHex C2
```

```
AttributeID    : 194
AttributeIDHex : C2
AttributeName  : Temperature
BetterValue    : Low
IsCritical     :
Description    : Indicates the device temperature, if the appropriate sensor is fitted. Lowest byte of the raw value contains the exact temperature value (Celsius degrees).
```

Команда отображает описание атрибута с IDHex C2.

### Example 5: Получение описания атрибутов по имени
```powershell
Get-DiskSmartAttributeDescription -AttributeName 'Throughput Performance', 'Temperature Celsius'
```

```
AttributeID    : 2
AttributeIDHex : 2
AttributeName  : Throughput Performance
IsCritical     : False
BetterValue    : High
Description    : Overall (general) throughput performance of a hard disk drive. If the value of this attribute is decreasing there is a high probability that there is a problem with the disk.

AttributeID    : 194
AttributeIDHex : C2
AttributeName  : Temperature
IsCritical     : False
BetterValue    : Low
Description    : Indicates the device temperature, if the appropriate sensor is fitted. Lowest byte of the raw value contains the exact temperature value (Celsius degrees).
```

Команда отображает описание атрибутов с указанными именами.

### Example 6: Получение описания критических атрибутов
```powershell
Get-DiskSmartAttributeDescription -CriticalOnly
```

```
AttributeID    : 5
AttributeIDHex : 5
AttributeName  : Reallocated Sectors Count
BetterValue    :
IsCritical     : True
Description    : Count of reallocated sectors. The raw value represents a count of the bad sectors that have been found and remapped.[25] Thus, the higher the attribute value, the more sectors the drive has had to reallocate. This value is primarily used as a metric of the life expectancy of the drive; a drive which has had any reallocations at all is significantly more likely to fail in the immediate months.

AttributeID    : 10
AttributeIDHex : A
AttributeName  : Spin Retry Count
BetterValue    : Low
IsCritical     : True
Description    : Count of retry of spin start attempts. This attribute stores a total count of the spin start attempts to reach the fully operational speed (under the condition that the first attempt was unsuccessful). An increase of this attribute value is a sign of problems in the hard disk mechanical subsystem.

...
```

Команда отображает описание критических атрибутов SMART.

### Example 7: Получение описания критических атрибутов из указанных
```powershell
Get-DiskSmartAttributeDescription -AttributeID (1..5) -CriticalOnly
```

```
AttributeID    : 5
AttributeIDHex : 5
AttributeName  : Reallocated Sectors Count
BetterValue    :
IsCritical     : True
Description    : Count of reallocated sectors. The raw value represents a count of the bad sectors that have been found and remapped.[25] Thus, the higher the attribute value, the more sectors the drive has had to reallocate. This value is primarily used as a metric of the life expectancy of the drive; a drive which has had any reallocations at all is significantly more likely to fail in the immediate months.
```

Команда отображает описание критических атрибутов SMART из диапазона указанных.

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
