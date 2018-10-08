Describe "SharePoint Online" -Tags 'SharePoint Online' {
    Context "Sharing" {
        It "Sharing is enabled to internal and authenticated external users" {
            $SPOTenantProps.SharingCapability |
                Should -Be $Test.Data.SharingCapability -Because (
                'sharing should be enabled as expected')
        }

        It "Default Sharing link type is set to least permissions" {
            $SPOTenantProps.DefaultSharingLinkType |
                Should -Be $Test.Data.DefaultSharingLinkType -Because (
                'sharing type should be least permissions, as configured (view by default)')
        }

        It "Email attestation for external users is disabled" {
            $SPOTenantProps.EmailAttestationRequired |
                Should -Be $Test.Data.EmailAttestationRequired -Because (
                'email attestation should be disabled as configured')
        }

        It "Email attestation should occur more than once a month" {
            $SPOTenantProps.EmailAttestationReAuthDays |
                Should -BeLessOrEqual $Test.Data.EmailAttestationReAuthDays -Because (
                'email attestation time should be more than once a month (<30)')
        }

        It "Prevent external users from resharing content" {
            $SPOTenantProps.PreventExternalUsersFromResharing |
                Should -Be $Test.Data.PreventExternalUsersFromResharing -Because (
                'external users should be prevented from resharing content')
        }

        It "External sharing accept account matches the invited account" {
            $SPOTenantProps.RequireAcceptingAccountMatchInvitedAccount |
                Should -Be $Test.Data.RequireAcceptingAccountMatchInvitedAccount -Because (
                'external users should be accepting using the same account as shared to')
        }

        It "Correct domain restrictions for sharing are in place" {
            $SPOTenantProps.SharingDomainRestrictionMode |
                Should -Be $Test.Data.SharingDomainRestrictionMode -Because (
                'domain restrictions should be as configured')
        }

        It "Guests can edit files" {
            $SPOTenantProps.FileAnonymousLinkType |
                Should -Be $Test.Data.FileAnonymousLinkType -Because (
                'maximum permissions granted to guests should be as configured')
        }

        It "Guests can edit folders" {
            $SPOTenantProps.FolderAnonymousLinkType |
                Should -Be $Test.Data.FolderAnonymousLinkType -Because (
                'maximum permissions granted to guests should be as configured')
        }
    }

    Context "Interface" {
        It "Display the names of users viewing files" {
            $SPOTenantProps.DisplayNamesOfFileViewers |
                Should -Be $Test.Data.DisplayNamesOfFileViewers -Because (
                'names of file viewers should be shown')
        }

        It "Notifications are enabled" {
            $SPOTenantProps.NotificationsInSharePointEnabled |
                Should -Be $Test.Data.NotificationsInSharePointEnabled -Because (
                'sharing notifications should be as configured')
        }

        It "Notify owners when re-sharing happens" {
            $SPOTenantProps.NotifyOwnersWhenItemsReshared |
                Should -Be $Test.Data.NotifyOwnersWhenItemsReshared -Because (
                'owners should be notified about resharing as configured')
        }

        It "Notify owners when sharing requests are accepted" {
            $SPOTenantProps.NotifyOwnersWhenInvitationsAccepted |
                Should -Be $Test.Data.NotifyOwnersWhenInvitationsAccepted -Because (
                'owners should be notified about invitations as configured')
        }

        It "Show people picker for guest users" {
            $SPOTenantProps.ShowPeoplePickerSuggestionsForGuestUsers |
                Should -Be $Test.Data.ShowPeoplePickerSuggestionsForGuestUsers -Because (
                'guest users should not be able to see the people picker as configured')
        }
    }
}