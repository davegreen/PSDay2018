@{
    # Mailbox

    AntispamBypassEnabled                          = $false
    AuditEnabled                                   = $false
    AuditLogAgeLimit                               = 90 # Days
    AuditAdminAction                               = @( 'Update', 'Copy', 'Move', 'MoveToDeletedItems', 'SoftDelete', 'UpdateCalendarDelegation',
        'HardDelete', 'FolderBind', 'SendAs', 'SendOnBehalf', 'MessageBind', 'Create', 'UpdateFolderPermissions', 'UpdateInboxRules' )

    AuditDelegateAction                            = @( 'Update', 'Move', 'MoveToDeletedItems', 'SoftDelete',
        'HardDelete', 'FolderBind', 'SendAs', 'SendOnBehalf', 'Create', 'UpdateFolderPermissions', 'UpdateInboxRules' )

    AuditOwnerAction                               = @( 'Update', 'Move', 'MoveToDeletedItems', 'SoftDelete',
        'HardDelete', 'Create', 'MailboxLogin', 'UpdateFolderPermissions', 'UpdateCalendarDelegation', 'UpdateInboxRules' )

    DiscoveryMailboxMaxReceiveSize                 = '100 MB (104,857,600 bytes)'
    DiscoveryMailboxMaxSendSize                    = '100 MB (104,857,600 bytes)'
    DiscoveryMailboxProhibitSendQuota              = '50 GB (53,687,091,200 bytes)'
    DiscoveryMailboxProhibitSendReceiveQuota       = '50 GB (53,687,091,200 bytes)'
    GroupMailboxProhibitSendQuota                  = '49.5 GB (53,150,220,288 bytes)'
    GroupMailboxProhibitSendReceiveQuota           = '50 GB (53,687,091,200 bytes)'
    MailboxLitigationHoldDuration                  = 'Unlimited'
    MailboxMaxReceiveSize                          = '36 MB (37,748,736 bytes)'
    MailboxMaxSendSize                             = '35 MB (36,700,160 bytes)'
    MailboxProhibitSendQuota                       = '99 GB (106,300,440,576 bytes)'
    MailboxProhibitSendReceiveQuota                = '100 GB (107,374,182,400 bytes)'
    MailboxRecoverableItemsQuota                   = '100 GB (107,374,182,400 bytes)'
    MailboxRecoverableItemsWarningQuota            = '90 GB (96,636,764,160 bytes)'
    RetainDeletedItemsFor                          = 14 # Days
    RetainDeletedItemsForDiscovery                 = 14 # Days

    RetentionPolicy                                = @{
        Name                    = 'Default MRM Policy'
        RetentionPolicyTagLinks = '5 Year Delete', '1 Year Delete', '6 Month Delete', 'Personal 5 year move to archive',
        '1 Month Delete', '1 Week Delete', 'Personal never move to archive', 'Personal 1 year move to archive',
        'Default 2 year move to archive', 'Junk Email', 'Recoverable Items 14 days move to archive', 'Never Delete'
        IsDefault               = $true
    }

    AgeLimitForRetention                           = 730
}