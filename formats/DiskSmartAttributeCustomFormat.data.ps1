$AttributePropertyFormat = @{
    ID = '@{Name="ID"; Expression={$PSItem.ID}; Alignment="Left"}'
    IDHex = '@{Name="IDHex"; Expression={$PSItem.IDHex}; Alignment="Left"}'
    AttributeName = '@{Name="AttributeName"; Expression={$PSItem.Name}; Alignment="Left"}'
    Threshold = '@{Name="Threshold"; Expression={$PSItem.Threshold}; Alignment="Left"}'
    Value = '@{Name="Value"; Expression={$PSItem.Value}; Alignment="Left"}'
    Worst = '@{Name="Worst"; Expression={$PSItem.Worst}; Alignment="Left"}'
    Data = '@{Name="Data"; Expression={$PSItem.Data}; Alignment="Left"}'
    History = '@{Name="History"; Expression={$PSItem.DataHistory}; Alignment="Left"}'
    # Converted = '@{Name="Converted"; Expression={$PSItem.DataConverted}; Alignment="Right"}'
    Converted = '@{Name="Converted"; Expression={$PSItem.DataConverted}; Alignment="Left"}'
}
