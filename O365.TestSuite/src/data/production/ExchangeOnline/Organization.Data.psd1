@{
    # Organisation Config

    HybridConnection             = $false

    OnPremisesOrganization                         = @{
        OrganizationGuid         = $null
        HybridDomains            = $null
        InboundConnector         = $null
        OutboundConnector        = $null
        OrganizationRelationship = $null
    }

    OrganizationRelationship                       = @{
        Guid                  = $null
        Name                  = $null
        DomainNames           = $null
        Enabled               = $null
        FreeBusyAccessEnabled = $null
        FreeBusyAccessLevel   = $null
        FreeBusyAccessScope   = $null
        DeliveryReportEnabled = $null
        TargetAutodiscoverEpr = $null
        MailboxMoveEnabled    = $null
        MailboxMoveCapability = $null
    }
}