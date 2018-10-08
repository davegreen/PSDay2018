@{
    ConnectCredentials              = @{
        Key     = "365Admin"
        Message = "Admin credentials for Azure AD"
    }

    AccidentalDeletionThreshold     = 500
    DeletionPreventionType          = 'EnabledForCount'
    TechnicalNotificationEmails     = 'david.green@tookitaway.co.uk'
    MarketingNotificationEmails     = $null
    DirSyncServiceAccount           = $null
    DirectorySynchronizationEnabled = $false
    PasswordSynchronizationEnabled  = $false

    DirSyncFeature                  = @(
        @{
            DirSyncFeature = 'DeviceWriteback'
            Enabled        = $false
        },
        @{
            DirSyncFeature = 'DirectoryExtensions'
            Enabled        = $false
        },
        @{
            DirSyncFeature = 'DuplicateProxyAddressResiliency'
            Enabled        = $false
        },
        @{
            DirSyncFeature = 'DuplicateUPNResiliency'
            Enabled        = $false
        },
        @{
            DirSyncFeature = 'EnableSoftMatchOnUpn'
            Enabled        = $false
        },
        @{
            DirSyncFeature = 'EnforceCloudPasswordPolicyForPasswordSyncedUsers'
            Enabled        = $false
        },
        @{
            DirSyncFeature = 'PasswordSync'
            Enabled        = $false
        },
        @{
            DirSyncFeature = 'SynchronizeUpnForManagedUsers'
            Enabled        = $false
        },
        @{
            DirSyncFeature = 'UnifiedGroupWriteback'
            Enabled        = $false
        },
        @{
            DirSyncFeature = 'UserWriteback'
            Enabled        = $false
        }
    )
}