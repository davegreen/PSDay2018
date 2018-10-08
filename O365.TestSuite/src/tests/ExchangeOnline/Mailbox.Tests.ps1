Describe "Mailbox Auditing and Compliance" -Tags 'Exchange Online', 'Mailbox' {
    $MailboxACTests = {
        It "Auditing enabled" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.AuditEnabled | Should -Be $Test.Data.AuditEnabled
            }
        }

        It "Audit log age is set to at least $($Test.Data.AuditLogAgeLimit) days" {
            foreach ($Mailbox in $Mailboxes) {
                [int]$Mailbox.AuditLogAgeLimit.Split('.')[0] | Should -BeGreaterOrEqual $Test.Data.AuditLogAgeLimit
            }
        }

        It "Admin auditing is configured" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.AuditAdmin | ForEach-Object {
                    $_ | Should -BeIn $Test.Data.AuditAdminAction
                }
            }
        }

        It "Delegate auditing is configured" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.AuditDelegate| ForEach-Object {
                    $_ | Should -BeIn $Test.Data.AuditDelegateAction
                }
            }
        }

        It "Owner auditing is configured" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.AuditOwner | ForEach-Object {
                    $_ | Should -BeIn $Test.Data.AuditOwnerAction
                }
            }
        }

        It "Deleted items are retained for at least $($Test.Data.RetainDeletedItemsFor) days" {
            foreach ($Mailbox in $Mailboxes) {
                if ($Mailbox.RecipientTypeDetails -eq 'DiscoveryMailbox') {
                    [int]$Mailbox.RetainDeletedItemsFor.Split('.')[0] |
                        Should -BeGreaterOrEqual $Test.Data.RetainDeletedItemsForDiscovery
                }
                else {
                    [int]$Mailbox.RetainDeletedItemsFor.Split('.')[0] |
                        Should -BeGreaterOrEqual $Test.Data.RetainDeletedItemsFor
                }
            }
        }

        It "Retention policy is set to $($Test.Data.RetentionPolicy.Name)" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.RetentionPolicy | Should -Be $Test.Data.RetentionPolicy.Name
            }
        }

        It "Antispam bypasses are disabled" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.AntispamBypassEnabled | Should -Be $Test.Data.AntispamBypassEnabled
            }
        }

        It "Litigation hold duration setting" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.LitigationHoldDuration | Should -Be $Test.Data.MailboxLitigationHoldDuration
            }
        }

        It "Mailbox quota of recoverable items" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.RecoverableItemsQuota | Should -Be $Test.Data.MailboxRecoverableItemsQuota
                $Mailbox.RecoverableItemsWarningQuota | Should -Be $Test.Data.MailboxRecoverableItemsWarningQuota
            }
        }
    }

    Context "Default Mailbox Plan" {
        $Mailboxes = Get-EOLMailboxPlan | Where-Object -Property isdefault -eq -Value $true

        It "Default User Mailbox Plan is the expected object" {
            ($Mailboxes | Measure-Object).Count | Should -Be 1
            $Mailboxes.DisplayName | Should -Be $Test.Data.DefaultUserMailboxPlan.Name
            $Mailboxes.Guid | Should -Be $Test.Data.DefaultUserMailboxPlan.Guid
        }

        It "Mailbox quota prohibiting sending mail" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.ProhibitSendQuota | Should -Be $Test.Data.MailboxProhibitSendQuota
            }
        }

        It "Mailbox quota prohibiting sending or receiving mail" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.ProhibitSendReceiveQuota | Should -Be $Test.Data.MailboxProhibitSendReceiveQuota
            }
        }

        It "Maximum send message size should be the organisation default" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.MaxSendSize | Should -Be $Test.Data.MailboxMaxSendSize
            }
        }

        It "Maximum receive message size should be the organisation default" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.MaxReceiveSize | Should -Be $Test.Data.MailboxMaxReceiveSize
            }
        }

        It "Deleted items are retained for at least $($Test.Data.RetainDeletedItemsFor) days" {
            foreach ($Mailbox in $Mailboxes) {
                [int]$Mailbox.RetainDeletedItemsFor.Split('.')[0] |
                    Should -BeGreaterOrEqual $Test.Data.RetainDeletedItemsFor
            }
        }
    }

    Context "User Mailboxes" {
        $Mailboxes = Get-EOLMailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq 'UserMailbox' }

        . $MailboxACTests

        It "Percent of user mailboxes that are connected to on-premises account is over $(
        $Test.Data.UserMailboxDirSyncedPercent)%" {
            ($Mailboxes.IsDirSynced | Measure-Object -Average).Average |
                Should -BeGreaterOrEqual ($Test.Data.UserMailboxDirSyncedPercent / 100)
        }

        It "Mailbox quota prohibiting sending mail" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.ProhibitSendQuota | Should -Be $Test.Data.MailboxProhibitSendQuota
            }
        }

        It "Mailbox quota prohibiting sending or receiving mail" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.ProhibitSendReceiveQuota | Should -Be $Test.Data.MailboxProhibitSendReceiveQuota
            }
        }

        It "Maximum send message size should be the organisation default" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.MaxSendSize | Should -Be $Test.Data.MailboxMaxSendSize
            }
        }

        It "Maximum receive message size should be the organisation default" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.MaxReceiveSize | Should -Be $Test.Data.MailboxMaxReceiveSize
            }
        }
    }

    Context "Group Mailboxes" {
        [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
        $Mailboxes = Get-EOLMailbox -GroupMailbox -ResultSize Unlimited

        It "Antispam bypasses are disabled" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.AntispamBypassEnabled | Should -Be $Test.Data.AntispamBypassEnabled
            }
        }

        It "Litigation hold duration setting" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.LitigationHoldDuration | Should -Be $Test.Data.MailboxLitigationHoldDuration
            }
        }

        It "Mailbox quota of recoverable items" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.RecoverableItemsQuota | Should -Be $Test.Data.MailboxRecoverableItemsQuota
                $Mailbox.RecoverableItemsWarningQuota | Should -Be $Test.Data.MailboxRecoverableItemsWarningQuota
            }
        }

        It "Mailbox quota prohibiting sending mail" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.ProhibitSendQuota | Should -Be $Test.Data.GroupMailboxProhibitSendQuota
            }
        }

        It "Mailbox quota prohibiting sending or receiving mail" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.ProhibitSendReceiveQuota | Should -Be $Test.Data.GroupMailboxProhibitSendReceiveQuota
            }
        }

        It "Maximum send message size should be the organisation default" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.MaxSendSize | Should -Be $Test.Data.MailboxMaxSendSize
            }
        }

        It "Maximum receive message size should be the organisation default" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.MaxReceiveSize | Should -Be $Test.Data.MailboxMaxReceiveSize
            }
        }
    }

    Context "Shared Mailboxes" {
        [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
        $Mailboxes = Get-EOLMailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq 'SharedMailbox' }

        . $MailboxACTests

        It "Mailbox quota prohibiting sending mail" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.ProhibitSendQuota | Should -Be $Test.Data.MailboxProhibitSendQuota
            }
        }

        It "Mailbox quota prohibiting sending or receiving mail" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.ProhibitSendReceiveQuota | Should -Be $Test.Data.MailboxProhibitSendReceiveQuota
            }
        }

        It "Maximum send message size should be the organisation default" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.MaxSendSize | Should -Be $Test.Data.MailboxMaxSendSize
            }
        }

        It "Maximum receive message size should be the organisation default" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.MaxReceiveSize | Should -Be $Test.Data.MailboxMaxReceiveSize
            }
        }
    }

    Context "Room Mailboxes" {
        [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
        $Mailboxes = Get-EOLMailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq 'RoomMailbox' }

        . $MailboxACTests

        It "Mailbox quota prohibiting sending mail" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.ProhibitSendQuota | Should -Be $Test.Data.MailboxProhibitSendQuota
            }
        }

        It "Mailbox quota prohibiting sending or receiving mail" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.ProhibitSendReceiveQuota | Should -Be $Test.Data.MailboxProhibitSendReceiveQuota
            }
        }

        It "Maximum send message size should be the organisation default" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.MaxSendSize | Should -Be $Test.Data.MailboxMaxSendSize
            }
        }

        It "Maximum receive message size should be the organisation default" {
            foreach ($Mailbox in $Mailboxes) {
                $Mailbox.MaxReceiveSize | Should -Be $Test.Data.MailboxMaxReceiveSize
            }
        }
    }
}