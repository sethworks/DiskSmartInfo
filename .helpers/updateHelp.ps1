$docspath = './docs/en-us'
$helppath = './en-US'

# Generate xml
New-ExternalHelp -Path $docspath -OutputPath $helppath -Force

# Add two empty lines after all examples except the last
foreach ($file in (Get-ChildItem -Path $helppath -Filter *.xml).FullName)
{
    (Get-Content -Path $file -Raw) `
        -replace "</maml:para>\r\n        </dev:remarks>\r\n      </command:example>\r\n      <command:example>",
                 "</maml:para>`n          <maml:para/>`n          <maml:para/>`n        </dev:remarks>`n      </command:example>`n      <command:example>" |
        Set-Content -Path $file
}

$docspath = './docs/ru-ru'
$helppath = './ru-RU'

# Generate xml
New-ExternalHelp -Path $docspath -OutputPath $helppath -Force

# Add two empty lines after all examples except the last
foreach ($file in (Get-ChildItem -Path $helppath -Filter *.xml).FullName)
{
    (Get-Content -Path $file -Raw) `
        -replace "</maml:para>\r\n        </dev:remarks>\r\n      </command:example>\r\n      <command:example>",
                 "</maml:para>`n          <maml:para/>`n          <maml:para/>`n        </dev:remarks>`n      </command:example>`n      <command:example>" |
        Set-Content -Path $file
}
