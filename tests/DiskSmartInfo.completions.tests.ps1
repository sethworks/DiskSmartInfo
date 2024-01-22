BeforeAll {
    Remove-Module -Name DiskSmartInfo -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\DiskSmartInfo.psd1"
}

Describe "DiskSmartInfo completions tests" {

    Context "AttributeName" {
        It "Suggests all values" {
            $command = "Get-DiskSmartInfo -AttributeName "
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 64

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'Raw Read Error Rate'"
            $commandCompletion.CompletionMatches[0].ListItemText | Should -BeExactly "Raw Read Error Rate"
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly "1: Raw Read Error Rate"

            $commandCompletion.CompletionMatches[63].CompletionText | Should -BeExactly "'Free Fall Sensor'"
            $commandCompletion.CompletionMatches[63].ListItemText | Should -BeExactly "Free Fall Sensor"
            $commandCompletion.CompletionMatches[63].ToolTip | Should -BeExactly "254: Free Fall Sensor"
        }

        It "Suggests proper values" {
            $command = "Get-DiskSmartInfo -AttributeName T"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 7

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'Throughput Performance'"
            $commandCompletion.CompletionMatches[0].ListItemText | Should -BeExactly "Throughput Performance"
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly "2: Throughput Performance"

            $commandCompletion.CompletionMatches[6].CompletionText | Should -BeExactly "'Total LBAs Read'"
            $commandCompletion.CompletionMatches[6].ListItemText | Should -BeExactly "Total LBAs Read"
            $commandCompletion.CompletionMatches[6].ToolTip | Should -BeExactly "242: Total LBAs Read"
        }

        It "Omits already specified values" {
            $command = "get-disksmartInfo -AttributeName 'Thermal Asperity Rate', 'Torque Amplification Count', T"
            $commandCompletion = TabExpansion2 -inputScript $command -cursorColumn $command.Length

            $commandCompletion.CompletionMatches | Should -HaveCount 5

            $commandCompletion.CompletionMatches[0].CompletionText | Should -BeExactly "'Throughput Performance'"
            $commandCompletion.CompletionMatches[0].ListItemText | Should -BeExactly "Throughput Performance"
            $commandCompletion.CompletionMatches[0].ToolTip | Should -BeExactly "2: Throughput Performance"

            $commandCompletion.CompletionMatches[4].CompletionText | Should -BeExactly "'Total LBAs Read'"
            $commandCompletion.CompletionMatches[4].ListItemText | Should -BeExactly "Total LBAs Read"
            $commandCompletion.CompletionMatches[4].ToolTip | Should -BeExactly "242: Total LBAs Read"
        }
    }
}
