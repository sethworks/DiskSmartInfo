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
Get-DiskSmartInfo [[-ComputerName] <String[]>] [-Transport <String>] [-Source <String>] [-Convert]
[-CriticalAttributesOnly] [-DiskNumber <Int32[]>] [-DiskModel <String[]>] [-Device <String[]>]
[-AttributeID <Int32[]>] [-AttributeIDHex <String[]>] [-AttributeName <String[]>]
[-AttributeProperty <AttributeProperty[]>] [-Quiet] [-ShowHistory] [-UpdateHistory] [-Archive]
[-Credential <PSCredential>] [<CommonParameters>]
```

### Session
```
Get-DiskSmartInfo [-CimSession <CimSession[]>] [-PSSession <PSSession[]>] [-Source <String>] [-Convert]
[-CriticalAttributesOnly] [-DiskNumber <Int32[]>] [-DiskModel <String[]>] [-Device <String[]>]
[-AttributeID <Int32[]>] [-AttributeIDHex <String[]>] [-AttributeName <String[]>]
[-AttributeProperty <AttributeProperty[]>] [-Quiet] [-ShowHistory] [-UpdateHistory] [-Archive]
[<CommonParameters>]
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

### -Transport
Specifies type of session used for connecting to computers, listed or bound to the
-ComputerName parameter.

It is not used locally or with -CimSession or -PSSession parameters.

The following values can be specified:

CIMSession (default) - use CIMSession for remote connection

PSSession - use PSSession with WSMan transport

SSHSession - use PSSession with SSH transport

```yaml
Type: String
Parameter Sets: ComputerName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CimSession
Specifies CimSessions to query.

You can use both WSMAN and DCOM types of sessions.

```yaml
Type: CimSession[]
Parameter Sets: Session
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PSSession
Specifies PSSession to use.

You can use both WSMAN and SSH sessions.

```yaml
Type: PSSession[]
Parameter Sets: Session
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Source
Specifies the source of SMART data.

It can be used locally and remotely.

The following values can be specified:

CIM (default) - use Common Information Model (Windows Management Instrumentation)

SmartCtl - use SmartCtl utility

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Convert
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

The result is cumulative and includes all disks specified in -DiskNumber, -DiskModel, and -Device parameters.

This parameter supports autocompletion. When -ComputerName or -CimSession parameters are not specified,
autocompletion suggests disks from local computer, where there are single ComputerName or CimSession
specified, autocompletion suggests disks from that remote computer. Autocompletion does not suggest disk numbers
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

Disk model corresponds to Model properties of MSFT_Disk class (result of Get-Disk cmdlet)
and MSFT_PhysicalDisk class (result of Get-PhysicalDisk cmdlet).

Actually, the cmdlet compares specified value to Model property of Win32_DiskDrive WMI class, after stripping
drive type suffix. For example, Model property of Win32_DiskDrive WMI class can be "Disk Model 2 TB ATA Device".
By default the cmdlet strips " ATA Device" suffix, so that the value corresponds to MSFT_Disk
and MSFT_PhysicalDisk Model property.

This can be changed by TrimDiskDriveModelSuffix config parameter.

For more information, see about_DiskSmartInfo_config.

The result is cumulative and includes all disks specified in -DiskNumber, -DiskModel, and -Device parameters.

This parameter supports autocompletion. When -ComputerName or -CimSession parameters are not specified,
autocompletion suggests disks from local computer, where there are single ComputerName or CimSession
specified, autocompletion suggests disks from that remote computer. Autocompletion does not suggest disk models
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

### -Device
Specifies device to query.

Device corresponds to PNPDeviceId on Windows and device file on Linux.

The result is cumulative and includes all disks specified in -DiskNumber, -DiskModel, and -Device parameters.

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

The parameter accepts only default (and not proprietary) attribute names,
then transforms them into attribute ids, that are actually used.

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

### -AttributeProperty
Specifies which properties of the attributes should be displayed.

If you specify History or Converted among the properties, the -ShowHistory
and -Convert parameters respectively are set automatically.

Specifying this parameter results in attribute objects of type DiskSmartAttributeCustom.

```yaml
Type: AttributeProperty[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quiet
Displays only those attributes, that are critical and their Data is greater than the CriticalThreshold property,
or that are non-critical and their Value is less or equal to their Threshold.

If any of the attribute selection parameters are used, the result includes such attributes only from the specified ones.

If there are no such attributes for a disk, that disk is not shown.

This can be changed by SuppressResultsWithEmptySmartData config parameter.

For more information on CriticalThreshold attribute description property, see about_DiskSmartInfo_attributes.

For more information on SuppressResultsWithEmptySmartData config parameter, see about_DiskSmartInfo_config.

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

By default the cmdlet shows history data for all attributes, even if there were no changes occurred.

This can be changed by ShowUnchangedDataHistory config parameter.

For more information, see about_DiskSmartInfo_config.

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

This can be changed by DataHistoryPath config parameter.

For more information, see about_DiskSmartInfo_config.

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
### -Archive
Specifies that SMART data should be saved to archive folder.

The cmdlet stores SMART data for all disks and attributes of specified computers,
even if disk selection or attribute selection parameters are used.

Archive by default is located in the archive folder of the module directory.

This can be changed by ArchivePath config parameter.

For more information, see about_DiskSmartInfo_config.

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

### -Credential
Specifies credential used for connecting to computers, listed or bound to the
-ComputerName parameter.

It is not used locally or with -CimSession or -PSSession parameters.

```yaml
Type: PSCredential
Parameter Sets: ComputerName
Aliases:

Required: False
Position: 1
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
Disk:         0: Disk model
Device:       Disk device
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

The command gets disk SMART information.

### Example 2: Converted data
```powershell
Get-DiskSmartInfo -Convert
```

```
Disk:         0: Disk model
Device:       Disk device
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data        Converted
              --  ----- -------------                      --------- ----- ----- ----        ---------
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    8397        349.88 Days
              10  A     Spin Retry Count                   51        252   252   0
              12  C     Power Cycle Count                  0         99    99    22
              177 B1    Wear Leveling Count                0         98    98    33
              179 B3    Used Reserved Block Count Total    10        100   100   0
              181 B5    Program Fail Count Total           10        100   100   0
              182 B6    Erase Fail Count Total             10        100   100   0
              183 B7    Runtime Bad Block                  10        100   100   0
              187 BB    Reported Uncorrectable Errors      0         100   100   0
              190 BE    Airflow Temperature Celsius        0         53    48    47          53 C
              195 C3    Hardware ECC Recovered             0         200   200   0
              196 C4    Reallocation Event Count           0         252   252   0
              197 C5    Current Pending Sector Count       0         252   252   0
              198 C6    Offline Uncorrectable Sector Count 0         252   252   0
              199 C7    Ultra DMA CRC Error Count          0         100   100   0
              241 F1    Total LBAs Written                 0         99    99    12720469069 5.923 Tb
```

The command gets disk SMART information and adds converted data for applicable attributes.

### Example 3: Critical attributes only
```powershell
Get-DiskSmartInfo -CriticalAttributesOnly
```

```
Disk:         0: Disk model
Device:       Disk device
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

### Example 4: Using -Quiet parameter
```powershell
Get-DiskSmartInfo -Quiet
```

```
Disk:         0: Disk model
Device:       Disk device
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              3   3     Spin-Up Time                       21        20    20    6825
              197 C5    Current Pending Sector Count       0         200   200   20
              198 C6    Offline Uncorrectable Sector Count 0         200   200   20
```

The command gets disk SMART information and displays only attributes that are critical and their Data is greater than 0,
or that are non-critical and their Value is less or equal to their Threshold.

### Example 5: Using -CriticalAttributesOnly and -Quiet parameters
```powershell
Get-DiskSmartInfo -CriticalAttributesOnly -Quiet
```

```
Disk:         0: Disk model
Device:       Disk device
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              197 C5    Current Pending Sector Count       0         200   200   20
              198 C6    Offline Uncorrectable Sector Count 0         200   200   20
```

The command gets disk SMART information and displays only attributes that are critical and their Data is greater than 0.

### Example 6: Get disk SMART info from remote computers
```powershell
Get-DiskSmartInfo -ComputerName SomeComputer
```

```
ComputerName: SomeComputer
Disk:         0: Disk model
Device:       Disk device
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

The command gets disk SMART information from remote computer.

### Example 7: Get disk SMART info from remote computers using PSSession with WSMan transport
```powershell
Get-DiskSmartInfo -ComputerName SomeComputer -Transport PSSession
```

```
ComputerName: SomeComputer
Disk:         0: Disk model
Device:       Disk device
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

The command gets disk SMART information from remote computer using PSSession with WSMan transport.

### Example 8: Get disk SMART info from remote computers using PSSession with SSH transport
```powershell
Get-DiskSmartInfo -ComputerName SomeUser@SomeComputer -Transport SSHSession
```

```
ComputerName: SomeComputer
Disk:         0: Disk model
Device:       Disk device
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

The command gets disk SMART information from remote computer using PSSession with SSH transport.

### Example 9: Get disk SMART info from remote computers using PSSession with SSH transport and SmartCtl as data source
```powershell
Get-DiskSmartInfo -ComputerName SomeUser@SomeComputer -Transport SSHSession -Source SmartCtl
```

```
ComputerName: SomeComputer
Disk:         0: Disk model
Device:       Disk device
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

The command gets disk SMART information from remote computer using PSSession with SSH transport and SmartCtl as data source.

### Example 10: Get disk SMART info from remote computers using specified CimSessions
```powershell
$Credential = Get-Credential
$CimSession_WSMAN = New-CimSession -ComputerName SomeComputer -Credential $Credential

$SessionOption = New-CimSessionOption -Protocol Dcom
$CimSession_DCOM = New-CimSession -ComputerName SomeOtherComputer -SessionOption $SessionOption -Credential $Credential

Get-DiskSmartInfo -CimSession $CimSession_WSMAN, $CimSession_DCOM
```

```
ComputerName: SomeComputer
Disk:         0: Disk model
Device:       Disk device
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

ComputerName: SomeOtherComputer
Disk:         0: Disk model
Device:       Disk device
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    7395
              10  A     Spin Retry Count                   51        252   252   0
...
```

The command gets disk SMART information from remote computers using specified CimSessions.

### Example 11: Get disk SMART info from remote computers using specified PSSession
```powershell
$Credential = Get-Credential
$PSSession = New-PSSession -ComputerName SomeComputer -Credential $Credential
$SSHSession = New-PSSession -HostName SomeOtherComputer

Get-DiskSmartInfo -PSSession $PSSession, $SSHSession
```

```
ComputerName: SomeComputer
Disk:         0: Disk model
Device:       Disk device
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

ComputerName: SomeOtherComputer
Disk:         0: Disk model
Device:       Disk device
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    7395
              10  A     Spin Retry Count                   51        252   252   0
...
```

The command gets disk SMART information from remote computers using specified PSSession.

### Example 12: Get selected attributes
```powershell
Get-DiskSmartInfo -AttributeID 5,9 -AttributeIDHex BB -AttributeName 'Hardware ECC Recovered'
```

```
Disk:         0: Disk model
Device:       Disk device
SMARTData:
              ID  IDHex AttributeName                 Threshold Value Worst Data
              --  ----- -------------                 --------- ----- ----- ----
              5   5     Reallocated Sectors Count     10        100   100   0
              9   9     Power-On Hours                0         98    98    8397
              187 BB    Reported Uncorrectable Errors 0         100   100   0
              195 C3    Hardware ECC Recovered        0         200   200   0
```

The command gets specified SMART attributes.

### Example 13: Get data for selected disks
```powershell
Get-DiskSmartInfo -DiskNumber 1 -DiskModel "Some Specific Mod*" -Device "*Specific Dev*"
```

```
Disk:         1: Disk model
Device:       Disk device
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    8397
              10  A     Spin Retry Count                   51        252   252   0
...

Disk:         2: Some Specific Model
Device:       Disk device
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    7395
              10  A     Spin Retry Count                   51        252   252   0
...

Disk:         3: Disk Model
Device:       Some Specific Device
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    4682
              10  A     Spin Retry Count                   51        252   252   0
...
```

The command gets SMART information for specified disks.

### Example 14: Save history data
```powershell
Get-DiskSmartInfo -UpdateHistory
```

```
Disk:         0: Disk model
Device:       Disk device
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

The command gets SMART information and saves current Data.

### Example 15: Show history data
```powershell
Get-DiskSmartInfo -ShowHistory
```

```
Disk:         0: Disk model
Device:       Disk device
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

The command gets SMART information and displays history Data.

### Example 16: Get selected attribute properties
```powershell
Get-DiskSmartInfo -AttributeProperty ID, AttributeName, Data, History, Converted
```

```
Disk:         0: Disk model
Device:       Disk device
HistoryDate:  MM/dd/yyyy hh:mm:ss
SMARTData:
              ID  AttributeName                      Data        History     Converted
              --  -------------                      ----        -------     ---------
              5   Reallocated Sectors Count          0           0
              9   Power-On Hours                     8398        8397        349.88 Days
              10  Spin Retry Count                   0           0
              12  Power Cycle Count                  22          22
              177 Wear Leveling Count                33          33
              179 Used Reserved Block Count Total    0           0
              181 Program Fail Count Total           0           0
              182 Erase Fail Count Total             0           0
              183 Runtime Bad Block                  0           0
              187 Reported Uncorrectable Errors      0           0
              190 Airflow Temperature Celsius        47          47          53 C
              195 Hardware ECC Recovered             0           0
              196 Reallocation Event Count           0           0
              197 Current Pending Sector Count       0           0
              198 Offline Uncorrectable Sector Count 0           0
              199 Ultra DMA CRC Error Count          0           0
              241 Total LBAs Written                 12720469270 12720469069 5.923 Tb
```

The command gets specified properties of SMART attributes.

### Example 17: Using pipeline
```powershell
$ComputerName = 'Computer1'
$CimSession = New-CimSession -ComputerName 'Computer2'
$PSSession = New-PSSession -ComputerName 'Computer3'
$SSHSession = New-PSSession -HostName 'Computer4'

$DiskDrive = Get-CimInstance -ClassName Win32_DiskDrive -Filter 'Index=0' -ComputerName 'Computer5'
$Disk = Get-Disk -Number 1 -CimSession 'Computer6'
$PhysicalDisk = Get-PhysicalDisk -DeviceNumber 2 -CimSession 'Computer7'

$ComputerName, $CimSession, $PSSession, $SSHSession, $DiskDrive, $Disk, $PhysicalDisk | Get-DiskSmartInfo
```

```
ComputerName: Computer1
Disk:         0: Disk model
Device:       Disk device
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
Device:       Disk device
SMARTData:
              ID  IDHex AttributeName                      Threshold Value Worst Data
              --  ----- -------------                      --------- ----- ----- ----
              5   5     Reallocated Sectors Count          10        100   100   0
              9   9     Power-On Hours                     0         98    98    7395
              10  A     Spin Retry Count                   51        252   252   0
...
```

The command gets SMART information for all disks from computers Computer1, Computer2, Computer3, and
Computer4, and for specified disks from computers Computer5, Computer6, and Computer7.

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
