@{
    # Connect
    ConnectCredentials                             = @{
        Key     = "365Admin"
        Message = "Admin credentials for Exchange Online"
    }

    ConnectURI                                     = 'https://outlook.com/powershell-liveid'

    # Audit

    AdminAuditLogEnabled                           = $true
    AdminAuditLogCmdlets                           = '*'
    AdminAuditLogParameters                        = '*'

    # Journaling

    TransportJournalArchivingEnabled               = $false
    TransportJournalingReportNdrTo                 = '<>'

    # Misc

    TransportAnonymousSenderToRecipientRatePerHour = 1800
    UserMailboxDirSyncedPercent                    = 0

    # Domains

    AcceptedDomain                                 = @(
        @{ DomainName = 'neongreenie.onmicrosoft.com'; Default = $false },
        @{ DomainName = 'tookitaway.co.uk'; Default = $true }
    )

    # Mailbox Plan

    DefaultUserMailboxPlan                         = @{
        Name = 'ExchangeOnlineEnterprise'
        Guid = 'dcfd83b1-adae-405e-ac8e-956dd4ceed96'
    }

    # Antispam / Antimalware
    ATPMailPassStatus                              = 'Message passed'
    ATPDetectionThresholdPercentage                = 0.1
    SpamDetectionThresholdPercentage               = 100
    StdMailPassStatus                              = 'GoodMail', 'NonSpam_ContentScanPassed', 'NonSpam_ETRPassed'
    MailTrafficBadStatus                           = @(
        'Spam_AdditionalSpamFiltered',
        'Spam_BlockList',
        'Spam_BulkFiltered',
        'Spam_ContentScanFiltered',
        'Spam_ETRFiltered'
        'Spam_SenderBlocked',
        'SpamIPBlock',
        'SpamDBEBFilter',
        'SpamEnvelopeBlock',
        'SpamContentFiltered',
        'Malware'
    )

    # Remote Domains

    RemoteDomain                                   = @(
        @{
            DomainName     = '*'
            AllowedOOFType = 'External'
        }
    )

    # Transport Rules

    TransportRule                                  = @(
        #@{
        #    Identity           = $null
        #    Name               = $null
        #    Priority           = $null
        #    Conditions         = $null
        #    Actions            = $null
        #    State              = $null
        #    Mode               = $null
        #    FromScope          = $null
        #    StopRuleProcessing = $null
        #}
    )

    # Connectors

    InboundConnector                               = @(
        #@{
        #    Name                         = $null
        #    SenderDomains                = $null
        #    SenderIPAddresses            = $null
        #    RequireTls                   = $null
        #    CloudServicesMailEnabled     = $null
        #    Enabled                      = $null
        #    TreatMessagesAsInternal      = $null
        #    RestrictDomainsToCertificate = $null
        #    TlsSenderCertificateName     = $null
        #}
    )

    OutboundConnector                              = @(
        #@{
        #    Name                          = $null
        #    RecipientDomains              = $null
        #    SmartHosts                    = $null
        #    Enabled                       = $null
        #    TlsSettings                   = $null
        #    CloudServicesMailEnabled      = $null
        #    UseMXRecord                   = $null
        #    IsTransportRuleScoped         = $null
        #    RouteAllMessagesViaOnPremises = $null
        #    AllAcceptedDomains            = $null
        #}
    )

    # Permissions

    RoleGroup                                      = @(
        #@{
        #    Name    = $null
        #    Guid    = $null
        #    Roles   = $null
        #    Members = $null
        #}
    )
}