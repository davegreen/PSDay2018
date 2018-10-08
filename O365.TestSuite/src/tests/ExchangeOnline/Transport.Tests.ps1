Describe "Transport" -Tags 'Exchange Online', 'Transport' {
    Context "Service" {
        $TransportConfig = Get-EOLTransportConfig

        It "Anonymous sender to recipient rate (Messages per hour) is $(
        $Test.Data.TransportAnonymousSenderToRecipientRatePerHour)" {
            $TransportConfig.AnonymousSenderToRecipientRatePerHour |
                Should -Be $Test.Data.TransportAnonymousSenderToRecipientRatePerHour
        }

        It "Journaling is disabled" {
            $TransportConfig.JournalArchivingEnabled | Should -Be $Test.Data.TransportJournalArchivingEnabled
        }

        It "Journaling NDR's are sent to $($Test.Data.TransportJournalingReportNdrTo)" {
            $TransportConfig.JournalingReportNdrTo | Should -Be $Test.Data.TransportJournalingReportNdrTo
        }
    }

    if ($Test.Data.TransportRule.Count -ge 1) {
        Context "Rules" {
            $TransportRule = Get-EOLTransportRule

            It "Extra transport rules don't exist" {
                $Splat = @{
                    ReferenceObject  = $TransportRule.Identity
                    DifferenceObject = $Test.Data.TransportRule.Identity
                }

                Compare-Object @Splat | Should -BeNullOrEmpty
            }

            It "<Name> is configured with priority <Priority>" -TestCases ($Test.Data.TransportRule) {
                Param ($Identity, $Name, $Priority, $Conditions, $Actions, $State, $Mode, $FromScope, $StopRuleProcessing)

                ($TransportRule | Where-Object -Property Identity -eq -Value $Identity).Identity | Should -Be $Identity
                ($TransportRule | Where-Object -Property Identity -eq -Value $Identity).Enabled  | Should -Be $Enabled
                ($TransportRule | Where-Object -Property Identity -eq -Value $Identity).Priority | Should -Be $Priority
                ($TransportRule | Where-Object -Property Identity -eq -Value $Identity).Mode  | Should -Be $Mode
            }

            It "<Name> is configured with expected conditions and actions" -TestCases ($Test.Data.TransportRule) {
                Param ($Identity, $Name, $Priority, $Conditions, $Actions, $State, $Mode, $FromScope, $StopRuleProcessing)

                ($TransportRule | Where-Object -Property Identity -eq -Value $Identity).Conditions | Should -Be $Conditions
                ($TransportRule | Where-Object -Property Identity -eq -Value $Identity).Actions | Should -Be $Actions
            }

            It "<Name> has comments to explain what it does" -TestCases ($Test.Data.TransportRule) {
                Param ($Identity, $Name, $Priority, $Conditions, $Actions, $State, $Mode, $FromScope, $StopRuleProcessing)

                ($TransportRule | Where-Object -Property Identity -eq -Value $Identity).Comments |
                    Should -Not -BeNullOrEmpty

                ($TransportRule | Where-Object -Property Identity -eq -Value $Identity).Comments.Length |
                    Should -BeGreaterThan 1
            }

            It "<Name> has the correct scope configured" -TestCases ($Test.Data.TransportRule) {
                Param ($Identity, $Name, $Priority, $Conditions, $Actions, $State, $Mode, $FromScope, $StopRuleProcessing)

                ($TransportRule | Where-Object -Property Identity -eq -Value $Identity).FromScope | Should -Be $FromScope
            }

            It "<Name> is configured with correct rule processing action" -TestCases ($Test.Data.TransportRule) {
                Param ($Identity, $Name, $Priority, $Conditions, $Actions, $State, $Mode, $FromScope, $StopRuleProcessing)

                ($TransportRule | Where-Object -Property Identity -eq -Value $Identity).StopRuleProcessing |
                    Should -Be $StopRuleProcessing
            }
        }
    }
}