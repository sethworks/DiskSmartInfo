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

### ComputerName (Default)
```
Get-DiskSmartInfo [[-ComputerName] <String[]>] [-ShowConverted] [-CriticalAttributesOnly] 
[-DiskNumber <Int32[]>] [-DiskModel <String[]>] [-AttributeID <Int32[]>] [-AttributeIDHex <String[]>]
[-AttributeName <String[]>] [-Quiet] [-ShowHistory] [-UpdateHistory] [<CommonParameters>]
```

### CimSession
```
Get-DiskSmartInfo -CimSession <CimSession[]> [-ShowConverted] [-CriticalAttributesOnly] 
[-DiskNumber <Int32[]>] [-DiskModel <String[]>] [-AttributeID <Int32[]>] [-AttributeIDHex <String[]>]
[-AttributeName <String[]>] [-Quiet] [-ShowHistory] [-UpdateHistory] [<CommonParameters>]
```

## DESCRIPTION
Командлет получает информацию SMART (Self-Monitoring, Analysis and Reporting Technology) жестких дисков

## PARAMETERS

### -ComputerName
Параметр указывает имена компьютеров для получения информации.

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
Параметр указывает объекты CimSession для получения информации.

Возможно использование как WSMAN так и DCOM типов сессий.

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
Параметр добавляет ковертированные данные для некоторых атрибутов.

Механизмы конвертации заданы в качестве свойства ConvertScriptBlock атрибутов,
перечисленных в файлах attributes/default.ps1 и attributes/proprietary.ps1.

Больше информации в about_DiskSmartInfo_attributes.

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

Критичность определяется свойством IsCritical атрибутов, перечисленных 
в файлах attributes/default.ps1 и attributes/proprietary.ps1.

Больше информации в about_DiskSmartInfo_attributes.

Если заданы любые из параметров выбора атрибутов, результат включает в себя только
критические атрибуты из указанных.

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
Задает номера дисков для запроса.

Номер диска соответствует свойству Index класса WMI Win32_DiskDrive,
свойству Number класса MSFT_Disk (результата командлета Get-Disk),
свойству DeviceId класса MSFT_PhysicalDisk (результата командлета Get-PhysicalDisk)
и номеру диска в утилите diskpart.

Параметр поддерживает автоматическое завершение значений. Если параметры -ComputerName или -CimSession
не заданы, механизм автоматического завершения предлагает диски локального компьютера, если задано
имя единственного компьютера или единственная cim-сессия, механизм автозавершения предлагает диски
с указанного удаленного компьютера. Механизм автозавершения не предлагает номера дисков в случае,
если указаны имена нескольких компьютеров или несколько cim-сессий.

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
Задает модели дисков для запроса.

Модель диска соответствует свойствам Model класса WMI MSFT_Disk (результата командлета Get-Disk), 
и класса MSFT_PhysicalDisk (результата командлета Get-PhysicalDisk).

На самом деле, эта команда сравнивает указанное знечение со свойством Model класса WMI Win32_DiskDrive
после удаления суффикса, указывающего тип диска. Например, свойство Model класса WMI Win32_DiskDrive
может быть следующим: "Disk Model 2 TB ATA Device". По умолчанию команда удаляет суффикс " ATA Device"
для того, чтобы данное значение соответствовало свойствам Model классов MSFT_Disk и MSFT_PhysicalDisk.

Это может быть изменено конфигурационным параметром TrimDiskDriveModel.

Больше информации в about_DiskSmartInfo_config.

Параметр поддерживает автоматическое завершение значений. Если параметры -ComputerName или -CimSession
не заданы, механизм автоматического завершения предлагает диски локального компьютера, если задано
имя единственного компьютера или единственная cim-сессия, механизм автозавершения предлагает диски
с указанного удаленного компьютера. Механизм автозавершения не предлагает модели дисков в случае,
если указаны имена нескольких компьютеров или несколько cim-сессий.

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

### -Quiet
Параметр отображает только те атрибуты, чьи значения находятся в состоянии Warning или Critical.

Если атрибут относится к критичным, он отображается, если его значение (Data) больше 0.

Если атрибут к критичным не относится, он отображается, если его значение (Value) меньше или равняется пороговому значению (Threshold).

Если диск не содержит атрибутов, чьи значения находятся в состоянии Warning или Critical, то сведения о нем не отображаются.

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

### Example 4: Вывод только тех атрибутов, чьи значения находятся в состоянии Warning или Critical
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

Команда получает информацию SMART жестких дисков и отображает только те атрибуты, чьи значения находятся в состоянии Warning или Critical.

Если диск не содержит атрибутов, чьи значения находятся в состоянии Warning или Critical, то сведения о нем не отображаются.

### Example 5: Вывод только тех критических атрибутов, чьи значения находятся в состоянии Warning или Critical
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

Команда получает информацию SMART жестких дисков и отображает только те критические атрибуты, чьи значения находятся в состоянии Warning или Critical.

Если диск не содержит критических атрибутов, чьи значения находятся в состоянии Warning или Critical, то сведения о нем не отображаются.


### Example 6: Получение данных SMART с удаленных компьютеров
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

Команда получает информацию SMART жестких дисков с удаленного компьютера.

### Example 7: Получение данных SMART с удаленных компьютеров без указания имени параметра ComputerName
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

Команда получает информацию SMART жестких дисков с удаленного компьютера.

### Example 8: Получение данных SMART с удаленных компьютеров с использованием объектов CimSession
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

Команда получает информацию SMART жестких дисков с удаленного компьютера с использованием объектов CimSession.

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
