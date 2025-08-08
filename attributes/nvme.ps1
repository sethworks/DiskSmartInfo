$Script:nvmeAttributes = @(
    @{Family = 'Samsung SSD 970 EVO Plus 500GB'
    ModelPatterns = @('^Samsung SSD 970 EVO.*')
    Attributes = @(
        [ordered]@{AttributeName = 'Critical Warning'
            IsCritical = { [Int32]::Parse($args[0]) -gt 0 }
        }
    ) } )
