# Do not use -SkipLimitCheck because there are no such a parameter in Windows PowerShell 5.1
$testData = Import-PowerShellDataFile -Path $PSScriptRoot\testData.psd1
$testDataProprietary = Import-PowerShellDataFile -Path $PSScriptRoot\testData.proprietary.psd1
$testDataCtl = Import-PowerShellDataFile -Path $PSScriptRoot\testData.ctl.psd1

# Class names
$namespaceWMI = 'root/WMI'
$classSmartData = 'MSStorageDriver_ATAPISmartData'
$classThresholds = 'MSStorageDriver_FailurePredictThresholds'
$classFailurePredictStatus = 'MSStorageDriver_FailurePredictStatus'
$classDiskDrive = 'Win32_DiskDrive'

$namespaceStorage = 'root/Microsoft/Windows/Storage'
$classDisk = 'MSFT_Disk'
$classPhysicalDisk = 'MSFT_PhysicalDisk'

# Class objects
if (-not $IsLinux)
{
    $cimClassSmartData = Get-CimClass -Namespace $namespaceWMI -ClassName $classSmartData
    $cimClassThresholds = Get-CimClass -Namespace $namespaceWMI -ClassName $classThresholds
    $cimClassFailurePredictStatus = Get-CimClass -Namespace $namespaceWMI -ClassName $classFailurePredictStatus
    $cimClassDiskDrive = Get-CimClass -ClassName $classDiskDrive

    $cimClassDisk = Get-CimClass -Namespace $namespaceStorage -ClassName $classDisk
    $cimClassPhysicalDisk = Get-CimClass -Namespace $namespaceStorage -ClassName $classPhysicalDisk
}

# Properties
# HDD1
$diskSmartDataPropertiesHDD1 = @{
    VendorSpecific = $testData.AtapiSmartData_VendorSpecific_HDD1
    InstanceName = $testData.InstanceName_HDD1
}

$diskThresholdsPropertiesHDD1 = @{
    VendorSpecific = $testData.FailurePredictThresholds_VendorSpecific_HDD1
    InstanceName = $testData.InstanceName_HDD1
}

$diskFailurePredictStatusPropertiesHDD1 = @{
    PredictFailure = $testData.FailurePredictStatus_PredictFailure_HDD1
    InstanceName = $testData.InstanceName_HDD1
}

$diskFailurePredictStatusTruePropertiesHDD1 = @{
    PredictFailure = $testData.FailurePredictStatus_PredictFailureTrue_HDD1
    InstanceName = $testData.InstanceName_HDD1
}

$diskDrivePropertiesHDD1 = @{
    Index = $testData.Index_HDD1
    PNPDeviceID = $testData.Device_HDD1
    Model = $testData.Model_HDD1
    BytesPerSector = $testData.BytesPerSector_HDD1
}

$diskDrivePropertiesATAHDD1 = @{
    Index = $testData.Index_HDD1
    PNPDeviceID = $testData.Device_HDD1
    Model = $testData.ModelATA_HDD1
    BytesPerSector = $testData.BytesPerSector_HDD1
}

$diskPropertiesHDD1 = @{
    Number = $testData.Index_HDD1
}

$physicalDiskPropertiesHDD1 = @{
    DeviceId = $testData.Index_HDD1
}

# HDD2
$diskSmartDataPropertiesHDD2 = @{
    VendorSpecific = $testData.AtapiSmartData_VendorSpecific_HDD2
    InstanceName = $testData.InstanceName_HDD2
}

$diskThresholdsPropertiesHDD2 = @{
    VendorSpecific = $testData.FailurePredictThresholds_VendorSpecific_HDD2
    InstanceName = $testData.InstanceName_HDD2
}

$diskFailurePredictStatusPropertiesHDD2 = @{
    PredictFailure = $testData.FailurePredictStatus_PredictFailure_HDD2
    InstanceName = $testData.InstanceName_HDD2
}

$diskDrivePropertiesHDD2 = @{
    Index = $testData.Index_HDD2
    PNPDeviceID = $testData.Device_HDD2
    Model = $testData.Model_HDD2
    BytesPerSector = $testData.BytesPerSector_HDD2
}

$diskPropertiesHDD2 = @{
    Number = $testData.Index_HDD2
}

$physicalDiskPropertiesHDD2 = @{
    DeviceId = $testData.Index_HDD2
}

# SSD1
$diskSmartDataPropertiesSSD1 = @{
    VendorSpecific = $testData.AtapiSmartData_VendorSpecific_SSD1
    InstanceName = $testData.InstanceName_SSD1
}

$diskThresholdsPropertiesSSD1 = @{
    VendorSpecific = $testData.FailurePredictThresholds_VendorSpecific_SSD1
    InstanceName = $testData.InstanceName_SSD1
}

$diskFailurePredictStatusPropertiesSSD1 = @{
    PredictFailure = $testData.FailurePredictStatus_PredictFailure_SSD1
    InstanceName = $testData.InstanceName_SSD1
}

$diskDrivePropertiesSSD1 = @{
    Index = $testData.Index_SSD1
    PNPDeviceID = $testData.Device_SSD1
    Model = $testData.Model_SSD1
    BytesPerSector = $testData.BytesPerSector_SSD1
}

$diskPropertiesSSD1 = @{
    Number = $testData.Index_SSD1
}

$physicalDiskPropertiesSSD1 = @{
    DeviceId = $testData.Index_SSD1
}

# SSD2
$diskSmartDataPropertiesSSD2 = @{
    VendorSpecific = $testData.AtapiSmartData_VendorSpecific_SSD2
    InstanceName = $testData.InstanceName_SSD2
}

$diskThresholdsPropertiesSSD2 = @{
    VendorSpecific = $testData.FailurePredictThresholds_VendorSpecific_SSD2
    InstanceName = $testData.InstanceName_SSD2
}

$diskFailurePredictStatusPropertiesSSD2 = @{
    PredictFailure = $testData.FailurePredictStatus_PredictFailure_SSD2
    InstanceName = $testData.InstanceName_SSD2
}

$diskDrivePropertiesSSD2 = @{
    Index = $testData.Index_SSD2
    PNPDeviceID = $testData.Device_SSD2
    Model = $testData.Model_SSD2
    BytesPerSector = $testData.BytesPerSector_SSD2
}

$diskPropertiesSSD2 = @{
    Number = $testData.Index_SSD2
}

$physicalDiskPropertiesSSD2 = @{
    DeviceId = $testData.Index_SSD2
}

# HFSSSD1
$diskSmartDataPropertiesHFSSSD1 = @{
    VendorSpecific = $testDataProprietary.AtapiSmartData_VendorSpecific_HFSSSD1
    InstanceName = $testDataProprietary.InstanceName_HFSSSD1
}

$diskThresholdsPropertiesHFSSSD1 = @{
    VendorSpecific = $testDataProprietary.FailurePredictThresholds_VendorSpecific_HFSSSD1
    InstanceName = $testDataProprietary.InstanceName_HFSSSD1
}

$diskFailurePredictStatusPropertiesHFSSSD1 = @{
    PredictFailure = $testDataProprietary.FailurePredictStatus_PredictFailure_HFSSSD1
    InstanceName = $testDataProprietary.InstanceName_HFSSSD1
}

$diskDrivePropertiesHFSSSD1 = @{
    Index = $testDataProprietary.Index_HFSSSD1
    PNPDeviceID = $testDataProprietary.Device_HFSSSD1
    Model = $testDataProprietary.Model_HFSSSD1
    BytesPerSector = $testDataProprietary.BytesPerSector_HFSSSD1
}

$diskPropertiesHFSSSD1 = @{
    Number = $testDataProprietary.Index_HFSSSD1
}

$physicalDiskPropertiesHFSSSD1 = @{
    DeviceId = $testDataProprietary.Index_HFSSSD1
}

# KINGSTONSSD1
$diskSmartDataPropertiesKINGSTONSSD1 = @{
    VendorSpecific = $testDataProprietary.AtapiSmartData_VendorSpecific_KINGSTONSSD1
    InstanceName = $testDataProprietary.InstanceName_KINGSTONSSD1
}

$diskThresholdsPropertiesKINGSTONSSD1 = @{
    VendorSpecific = $testDataProprietary.FailurePredictThresholds_VendorSpecific_KINGSTONSSD1
    InstanceName = $testDataProprietary.InstanceName_KINGSTONSSD1
}

$diskFailurePredictStatusPropertiesKINGSTONSSD1 = @{
    PredictFailure = $testDataProprietary.FailurePredictStatus_PredictFailure_KINGSTONSSD1
    InstanceName = $testDataProprietary.InstanceName_KINGSTONSSD1
}

$diskDrivePropertiesKINGSTONSSD1 = @{
    Index = $testDataProprietary.Index_KINGSTONSSD1
    PNPDeviceID = $testDataProprietary.Device_KINGSTONSSD1
    Model = $testDataProprietary.Model_KINGSTONSSD1
    BytesPerSector = $testDataProprietary.BytesPerSector_KINGSTONSSD1
}

$diskPropertiesKINGSTONSSD1 = @{
    Number = $testDataProprietary.Index_KINGSTONSSD1
}

$physicalDiskPropertiesKINGSTONSSD1 = @{
    DeviceId = $testDataProprietary.Index_KINGSTONSSD1
}

# NVMe1
$diskDrivePropertiesNVMe1 = @{
    Index = $testDataCtl.CtlIndex_NVMe1
    PNPDeviceID = $testDataCtl.CtlDevice_NVMe1
    Model = $testDataCtl.CtlModel_NVMe1
    BytesPerSector = $testDataCtl.CtlBytesPerSector_NVMe1
}

$diskPropertiesNVMe1 = @{
    Number = $testDataCtl.CtlIndex_NVMe1
}

$physicalDiskPropertiesNVMe1 = @{
    DeviceId = $testDataCtl.CtlIndex_NVMe1
}

# NVMe2
$diskDrivePropertiesNVMe2 = @{
    Index = $testDataCtl.CtlIndex_NVMe2
    PNPDeviceID = $testDataCtl.CtlDevice_NVMe2
    Model = $testDataCtl.CtlModel_NVMe2
    BytesPerSector = $testDataCtl.CtlBytesPerSector_NVMe2
}

$diskPropertiesNVMe2 = @{
    Number = $testDataCtl.CtlIndex_NVMe2
}

$physicalDiskPropertiesNVMe2 = @{
    DeviceId = $testDataCtl.CtlIndex_NVMe2
}

# CIM object
if (-not $IsLinux)
{
    # MSStorageDriver_ATAPISmartData
    $diskSmartDataHDD1 = New-CimInstance -CimClass $cimClassSmartData -Property $diskSmartDataPropertiesHDD1 -ClientOnly
    $diskSmartDataHDD2 = New-CimInstance -CimClass $cimClassSmartData -Property $diskSmartDataPropertiesHDD2 -ClientOnly
    $diskSmartDataSSD1 = New-CimInstance -CimClass $cimClassSmartData -Property $diskSmartDataPropertiesSSD1 -ClientOnly
    $diskSmartDataSSD2 = New-CimInstance -CimClass $cimClassSmartData -Property $diskSmartDataPropertiesSSD2 -ClientOnly
    $diskSmartDataHFSSSD1 = New-CimInstance -CimClass $cimClassSmartData -Property $diskSmartDataPropertiesHFSSSD1 -ClientOnly
    $diskSmartDataKINGSTONSSD1 = New-CimInstance -CimClass $cimClassSmartData -Property $diskSmartDataPropertiesKINGSTONSSD1 -ClientOnly

    # MSStorageDriver_FailurePredictThresholds
    $diskThresholdsHDD1 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesHDD1 -ClientOnly
    $diskThresholdsHDD2 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesHDD2 -ClientOnly
    $diskThresholdsSSD1 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesSSD1 -ClientOnly
    $diskThresholdsSSD2 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesSSD2 -ClientOnly
    $diskThresholdsHFSSSD1 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesHFSSSD1 -ClientOnly
    $diskThresholdsKINGSTONSSD1 = New-CimInstance -CimClass $cimClassThresholds -Property $diskThresholdsPropertiesKINGSTONSSD1 -ClientOnly

    # MSStorageDriver_FailurePredictStatus
    $diskFailurePredictStatusHDD1 = New-CimInstance -CimClass $cimClassFailurePredictStatus -Property $diskFailurePredictStatusPropertiesHDD1 -ClientOnly
    $diskFailurePredictStatusTrueHDD1 = New-CimInstance -CimClass $cimClassFailurePredictStatus -Property $diskFailurePredictStatusTruePropertiesHDD1 -ClientOnly
    $diskFailurePredictStatusHDD2 = New-CimInstance -CimClass $cimClassFailurePredictStatus -Property $diskFailurePredictStatusPropertiesHDD2 -ClientOnly
    $diskFailurePredictStatusSSD1 = New-CimInstance -CimClass $cimClassFailurePredictStatus -Property $diskFailurePredictStatusPropertiesSSD1 -ClientOnly
    $diskFailurePredictStatusSSD2 = New-CimInstance -CimClass $cimClassFailurePredictStatus -Property $diskFailurePredictStatusPropertiesSSD2 -ClientOnly
    $diskFailurePredictStatusHFSSSD1 = New-CimInstance -CimClass $cimClassFailurePredictStatus -Property $diskFailurePredictStatusPropertiesHFSSSD1 -ClientOnly
    $diskFailurePredictStatusKINGSTONSSD1 = New-CimInstance -CimClass $cimClassFailurePredictStatus -Property $diskFailurePredictStatusPropertiesKINGSTONSSD1 -ClientOnly

    # Win32_DiskDrive
    $diskDriveHDD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHDD1 -ClientOnly
    $diskDriveATAHDD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesATAHDD1 -ClientOnly
    $diskDriveHDD2 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHDD2 -ClientOnly
    $diskDriveSSD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesSSD1 -ClientOnly
    $diskDriveSSD2 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesSSD2 -ClientOnly
    $diskDriveHFSSSD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHFSSSD1 -ClientOnly
    $diskDriveKINGSTONSSD1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesKINGSTONSSD1 -ClientOnly
    $diskDriveNVMe1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesNVMe1 -ClientOnly
    $diskDriveNVMe2 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesNVMe2 -ClientOnly

    # MSFT_Disk
    $diskHDD1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHDD1 -ClientOnly
    $diskHDD2 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHDD2 -ClientOnly
    $diskSSD1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesSSD1 -ClientOnly
    $diskSSD2 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesSSD2 -ClientOnly
    $diskHFSSSD1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHFSSSD1 -ClientOnly
    $diskKINGSTONSSD1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesKINGSTONSSD1 -ClientOnly
    $diskNVMe1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesNVMe1 -ClientOnly
    $diskNVMe2 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesNVMe2 -ClientOnly

    # MSFT_PhysicalDisk
    $physicalDiskHDD1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHDD1 -ClientOnly
    $physicalDiskHDD2 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHDD2 -ClientOnly
    $physicalDiskSSD1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesSSD1 -ClientOnly
    $physicalDiskSSD2 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesSSD2 -ClientOnly
    $physicalDiskHFSSSD1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHFSSSD1 -ClientOnly
    $physicalDiskKINGSTONSSD1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesKINGSTONSSD1 -ClientOnly
    $physicalDiskNVMe1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesNVMe1 -ClientOnly
    $physicalDiskNVMe2 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesNVMe2 -ClientOnly
}

# CtlData
# Windows PowerShell 5.1 (.net 4) Split() can't use "`r`n" as a separator
$ctlDataHDD1 = $testDataCtl.CtlData_HDD1.Replace("`r`n","`n").Split("`n")
$ctlDataPredictFailureTrueHDD1 = $testDataCtl.CtlDataPredictFailureTrue_HDD1.Replace("`r`n","`n").Split("`n")
$ctlDataHDD2 = $testDataCtl.CtlData_HDD2.Replace("`r`n","`n").Split("`n")
$ctlDataSSD1 = $testDataCtl.CtlData_SSD1.Replace("`r`n","`n").Split("`n")
$ctlDataSSD2 = $testDataCtl.CtlData_SSD2.Replace("`r`n","`n").Split("`n")
$ctlDataHFSSSD1 = $testDataCtl.CtlData_HFSSSD1.Replace("`r`n","`n").Split("`n")
$ctlDataKINGSTONSSD1 = $testDataCtl.CtlData_KINGSTONSSD1.Replace("`r`n","`n").Split("`n")
$ctlDataNVMe1 = $testDataCtl.CtlData_NVMe1.Replace("`r`n","`n").Split("`n")
$ctlDataPredictFailureTrueNVMe1 = $testDataCtl.CtlDataPredictFailureTrue_NVMe1.Replace("`r`n","`n").Split("`n")
$ctlDataNVMe2 = $testDataCtl.CtlData_NVMe2.Replace("`r`n","`n").Split("`n")

# Remoting
if (-not $IsLinux)
{
    $computerNames = $env:computername, 'localhost'
}
elseif ($IsLinux)
{
    $computerNames = (hostname), 'localhost'
}
$ipAddresses = '127.0.0.1', '127.0.0.2'

if (-not $IsLinux)
{
    # Win32_DiskDrive
    $diskDrivePropertiesHost1 = @{ Index = 1 }
    $diskDrivePropertiesHost2 = @{ Index = 2 }

    $diskDriveHost1 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHost1 -ClientOnly
    $diskDriveHost1 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[0] -Force

    $diskDriveHost2 = New-CimInstance -CimClass $cimClassDiskDrive -Property $diskDrivePropertiesHost2 -ClientOnly
    $diskDriveHost2 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[1] -Force

    # MSFT_Disk
    $diskPropertiesHost1 = @{ Number = 1 }
    $diskPropertiesHost2 = @{ Number = 2 }

    $diskHost1 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHost1 -ClientOnly
    $diskHost1 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[0] -Force

    $diskHost2 = New-CimInstance -CimClass $cimClassDisk -Property $diskPropertiesHost2 -ClientOnly
    $diskHost2 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[1] -Force

    # MSFT_PhysicalDisk
    $physicalDiskPropertiesHost1 = @{ DeviceId = 1 }
    $physicalDiskPropertiesHost2 = @{ DeviceId = 2 }

    $physicalDiskHost1 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHost1 -ClientOnly
    $physicalDiskHost1 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[0] -Force

    $physicalDiskHost2 = New-CimInstance -CimClass $cimClassPhysicalDisk -Property $physicalDiskPropertiesHost2 -ClientOnly
    $physicalDiskHost2 | Add-Member -MemberType NoteProperty -Name PSComputerName -Value $computerNames[1] -Force
}
