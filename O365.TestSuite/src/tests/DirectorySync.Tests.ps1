Describe "Directory Sync" -Tags 'Directory Sync' {
    Context "AD Connect" {
        $Errors = Get-MsolDirSyncProvisioningError
        $SyncFeatures = Get-MsolDirSyncFeatures
        $CompanyInfo = Get-MsolCompanyInformation

        if ($CompanyInfo.DirectorySynchronizationEnabled -eq $true) {
            $SyncConfig = Get-MsolDirSyncConfiguration
        }

        It "No Errors" {
            ($Errors).DisplayName | Should -BeNullOrEmpty
            $Errors | Should -BeNullOrEmpty
            Get-MsolHasObjectsWithDirSyncProvisioningErrors |
                Should -Be $false -Because (
                'Azure AD sync should have no errors')
        }

        It "Correct features are enabled <DirSyncFeature>" -TestCases ($Test.Data.DirSyncFeature) {
            Param($DirSyncFeature, $Enabled)
            ($SyncFeatures | Where-Object -Property DirSyncFeature -eq -Value $DirSyncFeature).Enabled |
                Should -Be $Enabled -Because (
                'the expected features should be configured')
        }

        It "No additional features exist" {
            $Splat = @{
                ReferenceObject  = $SyncFeatures.DirSyncFeature
                DifferenceObject = $Test.Data.DirSyncFeature.DirSyncFeature
            }

            Compare-Object @Splat | Should -BeNullOrEmpty -Because (
                'additional features should not exist')
        }

        if ($CompanyInfo.DirectorySynchronizationEnabled -eq $true) {
            It "Deletion Threshold" {
                ($SyncConfig).AccidentalDeletionThreshold |
                    Should -Be $Test.Data.AccidentalDeletionThreshold -Because (
                    'the deletion threshold amount should be as configured')

                ($SyncConfig).DeletionPreventionType |
                    Should -Be $Test.Data.DeletionPreventionType -Because (
                    'the deletion threshold should be as configured')
            }
        }

        It "Sync Service Account" {
            $CompanyInfo.DirSyncServiceAccount |
                Should -Be $Test.Data.DirSyncServiceAccount -Because (
                'the sync service account should be as configured')
        }

        It "Sync Enabled" {
            $CompanyInfo.DirectorySynchronizationEnabled |
                Should -Be $Test.Data.DirectorySynchronizationEnabled -Because (
                'synchronisation should be as configured')
        }

        It "Password Sync Enabled" {
            $CompanyInfo.PasswordSynchronizationEnabled |
                Should -Be $Test.Data.PasswordSynchronizationEnabled -Because (
                'password synchronisation should be as configured')
        }

        It "Technical Contact" {
            $CompanyInfo.TechnicalNotificationEmails |
                Should -Be $Test.Data.TechnicalNotificationEmails -Because (
                'technical notification email should be as configured')
        }

        It "Marketing Contact" {
            $CompanyInfo.MarketingNotificationEmails |
                Should -Be $Test.Data.MarketingNotificationEmails -Because (
                'marketing notification email should be as configured')
        }
    }
}