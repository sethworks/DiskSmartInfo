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
Параметр добавляет ковертированные данные для определенных атрибутов.

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

Результат включает в себя все диски, указанные в параметрах -DiskNumber и -DiskModel.

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

Результат включает в себя все диски, указанные в параметрах -DiskNumber и -DiskModel.

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

### -AttributeID
Параметр указывает идентификатор атрибута.

Результат включает в себя все атрибуты, указанные в параметрах -AttributeID, -AttributeIDHex и -AttributeName.

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
Параметр указывает идентификатор атрибута в шестнадцатеричном формате.

Результат включает в себя все атрибуты, указанные в параметрах -AttributeID, -AttributeIDHex и -AttributeName.

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
Параметр указывает имя атрибута.

Параметр принимает только имена атрибутов по умолчанию (и не включает проприетарные),
затем преобразовывает их числовые идентификаторы атрибутов, которые и используются
для запроса.

Результат включает в себя все атрибуты, указанные в параметрах -AttributeID, -AttributeIDHex и -AttributeName.

Этот параметр поддерживает автоматическое завершение значений. Механизм автозавершения предлагает
только значения по умолчанию и не включает проприетарные.

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
Параметр отображает только критичные атрибуты со значением свойства Data, превышающим 0,
а также не критичные атрибуты, в том случае, если значение их свойства Value меньше или равно
значению свойства Threshold.

Если заданы любые из параметров выбора атрибутов, результат включает в себя только
соответствующе условиям атрибуты из указанных.

Если диск не содержит удовлетворяющих условиям атрибутов, этот диск не отображается.

Это можно изменить конфигурационным параметром SuppressResultsWithEmptySmartData.

Больше информации в about_DiskSmartInfo_config.

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
Отображает ранее сохраненное значение свойства Data рядом с его текущим значением.

По умолчанию отображается сохраненное значение для всех атрибутов, даже если
текущее значение не изменилось.

Это можно изменить конфигурационным параметром ShowUnchangedDataHistory.

Больше информации в about_DiskSmartInfo_config.

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
Сохраняет текущие значения свойства Data для всех дисков указанных компьютеров
для последующего сравнения.

Если для определенного компьютера уже существуют сохраненные данные,
они перезаписываются. То есть сохраняется только один экземпляр данных.

Команда сохраняет значения свойства Data для всех дисков и атрибутов указанных компьютеров,
даже если использовались параметры выбора дисков и атрибутов.

По умолчанию данные сохраняются в папке history, расположенной в каталоге модуля.

Это расположение может быть изменено конфигурационным параметром DataHistoryPath.

Больше информации в about_DiskSmartInfo_config.

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
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    8397
              10  A     Spin Retry Count                   51        252   252   0
              12  C     Power Cycle Count                  0         99    99    22
              177 B1    Wear Leveling Count                0         98    98    33
              179 B3    Used Reserved Block Count Total    10        100   100   0
              181 B5    Program Fail Count Total           10        100   100   0
              182 B6    Erase Fail Count Total             10        100   100   0
              183 B7    Runtime Bad Block                  10        100   100   0
              187 BB    Reported Uncorrectable Errors      0         100   100   0
              190 BE    Airflow Temperature Celsius        0         53    48    47
              195 C3    Hardware ECC Recovered             0         200   200   0
              196 C4    Reallocation Event Count           0         252   252   0
              197 C5    Current Pending Sector Count       0         252   252   0
              198 C6    Offline Uncorrectable Sector Count 0         252   252   0
              199 C7    Ultra DMA CRC Error Count          0         100   100   0
              241 F1    Total LBAs Written                 0         99    99    12720469069
```

Команда получает информацию SMART жестких дисков

### Example 2: Конвертированные данные
```powershell
Get-DiskSmartInfo -ShowConverted
```

```
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data        ConvertedData
              --  ----- -------------                      --------- ----- ----- ----        -------------
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    8397          349.88 Days
              10  A     Spin Retry Count                   51        252   252   0
              12  C     Power Cycle Count                  0         99    99    22
              177 B1    Wear Leveling Count                0         98    98    33
              179 B3    Used Reserved Block Count Total    10        100   100   0
              181 B5    Program Fail Count Total           10        100   100   0
              182 B6    Erase Fail Count Total             10        100   100   0
              183 B7    Runtime Bad Block                  10        100   100   0
              187 BB    Reported Uncorrectable Errors      0         100   100   0
              190 BE    Airflow Temperature Celsius        0         53    48    47                   53 C
              195 C3    Hardware ECC Recovered             0         200   200   0
              196 C4    Reallocation Event Count           0         252   252   0
              197 C5    Current Pending Sector Count       0         252   252   0
              198 C6    Offline Uncorrectable Sector Count 0         252   252   0
              199 C7    Ultra DMA CRC Error Count          0         100   100   0
              241 F1    Total LBAs Written                 0         99    99    12720469069      5.923 Tb
```

Команда получает информацию SMART жестких дисков и добавляет конвертированные данные для определенных атрибутов.

### Example 3: Только критические атрибуты
```powershell
Get-DiskSmartInfo -CriticalAttributesOnly
```

```
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
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

### Example 4: Использование параметра -Quiet
```powershell
Get-DiskSmartInfo -Quiet
```

```
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              3   3     Spin-Up Time                       21        20    20    6825
              197 C5    Current Pending Sector Count       0         200   200   20
              198 C6    Offline Uncorrectable Sector Count 0         200   200   20
```

Команда получает информацию SMART жестких дисков и отображает только критичные атрибуты
со значением свойства Data, превышающим 0, а также не критичные атрибуты, в том случае,
если значение их свойства Value меньше или равно значению свойства Threshold.

### Example 5: Использование параметров -CriticalAttributesOnly и -Quiet
```powershell
Get-DiskSmartInfo -CriticalAttributesOnly -Quiet
```

```
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              197 C5    Current Pending Sector Count       0         200   200   20
              198 C6    Offline Uncorrectable Sector Count 0         200   200   20
```

Команда получает информацию SMART жестких дисков и отображает только критические атрибуты
со значением свойства Data, превышающим 0.

### Example 6: Получение данных SMART с удаленных компьютеров
```powershell
Get-DiskSmartInfo -ComputerName SomeComputer
```

```
ComputerName: SomeComputer
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    8397
              10  A     Spin Retry Count                   51        252   252   0
              12  C     Power Cycle Count                  0         99    99    22
              177 B1    Wear Leveling Count                0         98    98    33
              179 B3    Used Reserved Block Count Total    10        100   100   0
              181 B5    Program Fail Count Total           10        100   100   0
              182 B6    Erase Fail Count Total             10        100   100   0
              183 B7    Runtime Bad Block                  10        100   100   0
              187 BB    Reported Uncorrectable Errors      0         100   100   0
              190 BE    Airflow Temperature Celsius        0         53    48    47
              195 C3    Hardware ECC Recovered             0         200   200   0
              196 C4    Reallocation Event Count           0         252   252   0
              197 C5    Current Pending Sector Count       0         252   252   0
              198 C6    Offline Uncorrectable Sector Count 0         252   252   0
              199 C7    Ultra DMA CRC Error Count          0         100   100   0
              241 F1    Total LBAs Written                 0         99    99    12720469069
```

Команда получает информацию SMART жестких дисков с удаленного компьютера.

### Example 7: Получение данных SMART с удаленных компьютеров с использованием объектов CimSession
```powershell
$Credential = Get-Credential
$CimSession_WSMAN = New-CimSession -ComputerName SomeComputer -Credential $Credential

$SessionOption = New-CimSessionOption -Protocol Dcom
$CimSession_DCOM = New-CimSession -ComputerName SomeAnotherComputer -SessionOption $SessionOption -Credential $Credential

Get-DiskSmartInfo -CimSession $CimSession_WSMAN, $CimSession_DCOM
```

```
ComputerName: SomeComputer
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    8397
              10  A     Spin Retry Count                   51        252   252   0
              12  C     Power Cycle Count                  0         99    99    22
              177 B1    Wear Leveling Count                0         98    98    33
              179 B3    Used Reserved Block Count Total    10        100   100   0
              181 B5    Program Fail Count Total           10        100   100   0
              182 B6    Erase Fail Count Total             10        100   100   0
              183 B7    Runtime Bad Block                  10        100   100   0
              187 BB    Reported Uncorrectable Errors      0         100   100   0
              190 BE    Airflow Temperature Celsius        0         53    48    47
              195 C3    Hardware ECC Recovered             0         200   200   0
              196 C4    Reallocation Event Count           0         252   252   0
              197 C5    Current Pending Sector Count       0         252   252   0
              198 C6    Offline Uncorrectable Sector Count 0         252   252   0
              199 C7    Ultra DMA CRC Error Count          0         100   100   0
              241 F1    Total LBAs Written                 0         99    99    12720469069

ComputerName: SomeAnotherComputer
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    7395
              10  A     Spin Retry Count                   51        252   252   0
...
```

Команда получает информацию SMART жестких дисков с удаленного компьютера с использованием объектов CimSession.

### Example 8: Получение указанных атрибутов
```powershell
Get-DiskSmartInfo -AttributeID 5,9 -AttributeIDHex BB -AttributeName 'Hardware ECC Recovered'
```

```
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                 Threshold Value Worst Data
              --  ----- -------------                 --------- ----- ----- ----
              5   5     Reallocated Sectors Count     10        100   100   0
              9   9     Power-On Hours                0         98    98    8397
              187 BB    Reported Uncorrectable Errors 0         100   100   0
              195 C3    Hardware ECC Recovered        0         200   200   0
```

Команда получает указанные SMART атрибуты

### Example 9: Получение данных SMART для указанных дисков
```powershell
Get-DiskSmartInfo -DiskNumber 1 -DiskModel "Some Specific*"
```

```
Disk:         1: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    8397
              10  A     Spin Retry Count                   51        252   252   0
              12  C     Power Cycle Count                  0         99    99    22
              177 B1    Wear Leveling Count                0         98    98    33
              179 B3    Used Reserved Block Count Total    10        100   100   0
              181 B5    Program Fail Count Total           10        100   100   0
              182 B6    Erase Fail Count Total             10        100   100   0
              183 B7    Runtime Bad Block                  10        100   100   0
              187 BB    Reported Uncorrectable Errors      0         100   100   0
              190 BE    Airflow Temperature Celsius        0         53    48    47
              195 C3    Hardware ECC Recovered             0         200   200   0
              196 C4    Reallocation Event Count           0         252   252   0
              197 C5    Current Pending Sector Count       0         252   252   0
              198 C6    Offline Uncorrectable Sector Count 0         252   252   0
              199 C7    Ultra DMA CRC Error Count          0         100   100   0
              241 F1    Total LBAs Written                 0         99    99    12720469069

Disk:         2: Some Specific Model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    7395
              10  A     Spin Retry Count                   51        252   252   0
...
```

Команда получает информацию SMART для указанных жестких дисков.

### Example 10: Сохранение данных для последующего сравнения
```powershell
Get-DiskSmartInfo -UpdateHistory
```

```
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    8397
              10  A     Spin Retry Count                   51        252   252   0
              12  C     Power Cycle Count                  0         99    99    22
              177 B1    Wear Leveling Count                0         98    98    33
              179 B3    Used Reserved Block Count Total    10        100   100   0
              181 B5    Program Fail Count Total           10        100   100   0
              182 B6    Erase Fail Count Total             10        100   100   0
              183 B7    Runtime Bad Block                  10        100   100   0
              187 BB    Reported Uncorrectable Errors      0         100   100   0
              190 BE    Airflow Temperature Celsius        0         53    48    47
              195 C3    Hardware ECC Recovered             0         200   200   0
              196 C4    Reallocation Event Count           0         252   252   0
              197 C5    Current Pending Sector Count       0         252   252   0
              198 C6    Offline Uncorrectable Sector Count 0         252   252   0
              199 C7    Ultra DMA CRC Error Count          0         100   100   0
              241 F1    Total LBAs Written                 0         99    99    12720469069
```

Команда получает информацию SMART и сохраняет текущие значения свойства Data для всех атрибутов.

### Example 11: Отображение ранее сохраненных данных
```powershell
Get-DiskSmartInfo -ShowHistory
```

```
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
HistoryDate:  MM/dd/yyyy hh:mm:ss
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data        History
              --  ----- -------------                      --------- ----- ----- ----        -------
              5   5     Reallocated Sectors Count          10        100   100   0           0
              9   9     Power-On Hours                     0         98    98    8398        8397
              10  A     Spin Retry Count                   51        252   252   0           0
              12  C     Power Cycle Count                  0         99    99    22          22
              177 B1    Wear Leveling Count                0         98    98    33          33
              179 B3    Used Reserved Block Count Total    10        100   100   0           0
              181 B5    Program Fail Count Total           10        100   100   0           0
              182 B6    Erase Fail Count Total             10        100   100   0           0
              183 B7    Runtime Bad Block                  10        100   100   0           0
              187 BB    Reported Uncorrectable Errors      0         100   100   0           0
              190 BE    Airflow Temperature Celsius        0         53    48    47          47
              195 C3    Hardware ECC Recovered             0         200   200   0           0
              196 C4    Reallocation Event Count           0         252   252   0           0
              197 C5    Current Pending Sector Count       0         252   252   0           0
              198 C6    Offline Uncorrectable Sector Count 0         252   252   0           0
              199 C7    Ultra DMA CRC Error Count          0         100   100   0           0
              241 F1    Total LBAs Written                 0         99    99    12720469270 12720469069
```

Команда получает информацию SMART и отображает ранее сохраненные значения свойства Data
выводимых атрибутов.

### Example 12: Использование конвейера
```powershell
$ComputerName = 'Computer1'
$CimSession = New-CimSession -ComputerName 'Computer2'

$DiskDrive = Get-CimInstance -ClassName Win32_DiskDrive -Filter 'Index=0' -ComputerName 'Computer3'
$Disk = Get-Disk -Number 1 -CimSession 'Computer4'
$PhysicalDisk = Get-PhysicalDisk -DeviceNumber 2 -CimSession 'Computer5'

$ComputerName, $CimSession, $DiskDrive, $Disk, $PhysicalDisk | Get-DiskSmartInfo
```

```
ComputerName: Computer1
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    8397
              10  A     Spin Retry Count                   51        252   252   0
              12  C     Power Cycle Count                  0         99    99    22
              177 B1    Wear Leveling Count                0         98    98    33
              179 B3    Used Reserved Block Count Total    10        100   100   0
              181 B5    Program Fail Count Total           10        100   100   0
              182 B6    Erase Fail Count Total             10        100   100   0
              183 B7    Runtime Bad Block                  10        100   100   0
              187 BB    Reported Uncorrectable Errors      0         100   100   0
              190 BE    Airflow Temperature Celsius        0         53    48    47
              195 C3    Hardware ECC Recovered             0         200   200   0
              196 C4    Reallocation Event Count           0         252   252   0
              197 C5    Current Pending Sector Count       0         252   252   0
              198 C6    Offline Uncorrectable Sector Count 0         252   252   0
              199 C7    Ultra DMA CRC Error Count          0         100   100   0
              241 F1    Total LBAs Written                 0         99    99    12720469069

ComputerName: Computer2
Disk:         0: Disk model
PNPDeviceId:  Disk PNPDeviceId
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    7395
              10  A     Spin Retry Count                   51        252   252   0
...
```

Команда получает информацию SMART для всех дисков компьютеров Computer1 и Computer2,
и для указанных дисков компьютеров Computer3, Computer4 и Computer5.

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
