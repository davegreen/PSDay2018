Describe "Organisation" -Tags 'Exchange Online', 'Organisation' {
    if ($Test.Data.HybridConnection) {
        Context "Hybrid" {
            $OnPremOrg = Get-EOLOnPremisesOrganization

            It "OrganizationGUID" {
                $OnPremOrg.OrganizationGuid |
                    Should -Be $Test.Data.OnPremisesOrganization.OrganizationGuid
            }

            It "OrganizationRelationship" {
                $OnPremOrg.OrganizationRelationship |
                    Should -Be $Test.Data.OnPremisesOrganization.OrganizationRelationship
            }

            It "Hybrid Domains" {
                $OnPremOrg.HybridDomains |
                    Should -Be $Test.Data.OnPremisesOrganization.HybridDomains
            }

            It "Inbound Connector" {
                $OnPremOrg.InboundConnector |
                    Should -Be $Test.Data.OnPremisesOrganization.InboundConnector
            }

            It "Outbound Connector" {
                $OnPremOrg.OutboundConnector |
                    Should -Be $Test.Data.OnPremisesOrganization.OutboundConnector
            }
        }

        Context "Relationship" {
            $OrgRelationship = Get-EOLOrganizationRelationship
            $OnPremOrg = Get-EOLOnPremisesOrganization

            It "Hybrid Organization Relationship Exists" {
                $OrgRelationship |
                    Where-Object -Property Identity -eq -Value $OnPremOrg.OrganizationRelationship |
                    Should -Not -BeNullOrEmpty
            }

            It "Hybrid Organization Relationship is Enabled" {
                ($OrgRelationship |
                        Where-Object -Property Identity -eq -Value $OnPremOrg.OrganizationRelationship).Enabled |
                    Should -Be $Test.Data.OrganizationRelationship.Enabled
            }

            It "Hybrid Organization Relationship domains" {
                ($OrgRelationship |
                        Where-Object -Property Identity -eq -Value $OnPremOrg.OrganizationRelationship).HybridDomains |
                    Should -Be $Test.Data.OrganizationRelationship.HybridDomains
            }

            It "Hybrid Organization FreeBusy access" {
                ($OrgRelationship |
                        Where-Object -Property Identity -eq -Value $OnPremOrg.OrganizationRelationship).FreeBusyAccessEnabled |
                    Should -Be $Test.Data.OrganizationRelationship.FreeBusyAccessEnabled
            }

            It "Hybrid Organization FreeBusy settings" {
                ($OrgRelationship |
                        Where-Object -Property Identity -eq -Value $OnPremOrg.OrganizationRelationship).FreeBusyAccessLevel |
                    Should -Be $Test.Data.OrganizationRelationship.FreeBusyAccessLevel

                ($OrgRelationship |
                        Where-Object -Property Identity -eq -Value $OnPremOrg.OrganizationRelationship).FreeBusyAccessScope |
                    Should -Be $Test.Data.OrganizationRelationship.FreeBusyAccessScope
            }

            It "Hybrid Organization Autodiscover URI" {
                ($OrgRelationship |
                        Where-Object -Property Identity -eq -Value $OnPremOrg.OrganizationRelationship).TargetAutodiscoverEpr |
                    Should -Be $Test.Data.OrganizationRelationship.TargetAutodiscoverEpr
            }

            It "Hybrid Organization Delivery Report" {
                ($OrgRelationship |
                        Where-Object -Property Identity -eq -Value $OnPremOrg.OrganizationRelationship).DeliveryReportEnabled |
                    Should -Be $Test.Data.OrganizationRelationship.DeliveryReportEnabled
            }

            It "Hybrid Organization Mailbox Moves" {
                ($OrgRelationship |
                        Where-Object -Property Identity -eq -Value $OnPremOrg.OrganizationRelationship).MailboxMoveEnabled |
                    Should -Be $Test.Data.OrganizationRelationship.MailboxMoveEnabled
            }

            It "Hybrid Organization Mailbox Move Capability" {
                ($OrgRelationship |
                        Where-Object -Property Identity -eq -Value $OnPremOrg.OrganizationRelationship).MailboxMoveCapability |
                    Should -Be $Test.Data.OrganizationRelationship.MailboxMoveCapability
            }

            It "No additional organization relationships exist" {
                $Splat = @{
                    ReferenceObject  = $OrgRelationship.Name
                    DifferenceObject = $Test.Data.OrganizationRelationship.Name
                }

                Compare-Object @Splat | Should -BeNullOrEmpty
            }
        }
    }

    Context "Inbound Connectors" {
        $InboundConnector = Get-EOLInboundConnector
        $OnPremOrg = Get-EOLOnPremisesOrganization

        if ($Test.Data.HybridConnection) {
            It "Hybrid Organization Inbound Connector" {
                $InboundConnector |
                    Where-Object -Property Name -eq -Value $OnPremOrg.InboundConnector |
                    Should -Not -BeNullOrEmpty
            }

            It "Hybrid Organization Inbound Connector is Enabled" {
                ($InboundConnector |
                        Where-Object -Property Name -eq -Value $OnPremOrg.InboundConnector).Enabled |
                    Should -Be $true
            }
        }

        if ($Test.Data.InboundConnector.Count -ge 1) {
            It "<Name> exists" -TestCases ($Test.Data.InboundConnector) {
                Param ($Name, $SenderDomains, $SenderIPAddresses, $RequireTls, $CloudServicesMailEnabled, $Enabled,
                    $TreatMessagesAsInternal, $RestrictDomainsToCertificate, $TlsSenderCertificateName)

                ($InboundConnector |
                        Where-Object -Property Name -eq -Value $Name) | Should -Not -BeNullOrEmpty
            }

            It "<Name> is enabled/disabled" -TestCases ($Test.Data.InboundConnector) {
                Param ($Name, $SenderDomains, $SenderIPAddresses, $RequireTls, $CloudServicesMailEnabled, $Enabled,
                    $TreatMessagesAsInternal, $RestrictDomainsToCertificate, $TlsSenderCertificateName)

                ($InboundConnector |
                        Where-Object -Property Name -eq -Value $Name).Enabled | Should -Be $Enabled
            }

            It "<Name> sender domains" -TestCases ($Test.Data.InboundConnector) {
                Param ($Name, $SenderDomains, $SenderIPAddresses, $RequireTls, $CloudServicesMailEnabled, $Enabled,
                    $TreatMessagesAsInternal, $RestrictDomainsToCertificate, $TlsSenderCertificateName)

                ($InboundConnector |
                        Where-Object -Property Name -eq -Value $Name).SenderDomains | Should -Be $SenderDomains
            }

            It "<Name> sender IPs" -TestCases ($Test.Data.InboundConnector) {
                Param ($Name, $SenderDomains, $SenderIPAddresses, $RequireTls, $CloudServicesMailEnabled, $Enabled,
                    $TreatMessagesAsInternal, $RestrictDomainsToCertificate, $TlsSenderCertificateName)

                ($InboundConnector |
                        Where-Object -Property Name -eq -Value $Name).SenderIPAddresses | Should -Be $SenderIPAddresses
            }

            It "<Name> Inbound additional configuration" -TestCases ($Test.Data.InboundConnector) {
                Param ($Name, $SenderDomains, $SenderIPAddresses, $RequireTls, $CloudServicesMailEnabled, $Enabled,
                    $TreatMessagesAsInternal, $RestrictDomainsToCertificate, $TlsSenderCertificateName)

                ($InboundConnector |
                        Where-Object -Property Name -eq -Value $Name).RequireTls | Should -Be $RequireTls

                ($InboundConnector |
                        Where-Object -Property Name -eq -Value $Name).CloudServicesMailEnabled | Should -Be $CloudServicesMailEnabled

                ($InboundConnector |
                        Where-Object -Property Name -eq -Value $Name).TreatMessagesAsInternal | Should -Be $TreatMessagesAsInternal
            }

            It "<Name> Inbound additional configuration" -TestCases ($Test.Data.InboundConnector) {
                Param ($Name, $SenderDomains, $SenderIPAddresses, $RequireTls, $CloudServicesMailEnabled, $Enabled,
                    $TreatMessagesAsInternal, $RestrictDomainsToCertificate, $TlsSenderCertificateName)

                ($InboundConnector |
                        Where-Object -Property Name -eq -Value $Name).RestrictDomainsToCertificate | Should -Be $RestrictDomainsToCertificate

                ($InboundConnector |
                        Where-Object -Property Name -eq -Value $Name).TlsSenderCertificateName | Should -Be $TlsSenderCertificateName
            }

            It "No additional inbound connectors exist" {
                $Splat = @{
                    ReferenceObject  = $InboundConnector.Name
                    DifferenceObject = $Test.Data.InboundConnector.Name
                }

                Compare-Object @Splat | Should -BeNullOrEmpty
            }
        }
    }

    Context "Outbound Connectors" {
        $OutboundConnector = Get-EOLOutboundConnector
        $OnPremOrg = Get-EOLOnPremisesOrganization

        if ($Test.Data.HybridConnection) {
            It "Hybrid Organization Outbound Connector" {
                $OutboundConnector |
                    Where-Object -Property Name -eq -Value $OnPremOrg.OutboundConnector |
                    Should -Not -BeNullOrEmpty
            }

            It "Hybrid Organization Outbound Connector is Enabled" {
                ($OutboundConnector |
                        Where-Object -Property Name -eq -Value $OnPremOrg.OutboundConnector).Enabled |
                    Should -Be $true
            }
        }

        if ($Test.Data.OutboundConnector.Count -ge 1) {
            It "<Name> exists" -TestCases ($Test.Data.OutboundConnector) {
                Param ($Name, $RecipientDomains, $SmartHosts, $Enabled, $TlsSettings, $CloudServicesMailEnabled,
                    $UseMXRecord, $IsTransportRuleScoped, $RouteAllMessagesViaOnPremises, $AllAcceptedDomains)

                ($OutboundConnector |
                        Where-Object -Property Name -eq -Value $Name) | Should -Not -BeNullOrEmpty
            }

            It "<Name> is enabled/disabled" -TestCases ($Test.Data.OutboundConnector) {
                Param ($Name, $RecipientDomains, $SmartHosts, $Enabled, $TlsSettings, $CloudServicesMailEnabled,
                    $UseMXRecord, $IsTransportRuleScoped, $RouteAllMessagesViaOnPremises, $AllAcceptedDomains)

                ($OutboundConnector |
                        Where-Object -Property Name -eq -Value $Name).Enabled | Should -Be $Enabled
            }

            It "<Name> recipient domains" -TestCases ($Test.Data.OutboundConnector) {
                Param ($Name, $RecipientDomains, $SmartHosts, $Enabled, $TlsSettings, $CloudServicesMailEnabled,
                    $UseMXRecord, $IsTransportRuleScoped, $RouteAllMessagesViaOnPremises, $AllAcceptedDomains)

                ($OutboundConnector |
                        Where-Object -Property Name -eq -Value $Name).RecipientDomains | Should -Be $RecipientDomains
            }

            It "<Name> smart hosts" -TestCases ($Test.Data.OutboundConnector) {
                Param ($Name, $RecipientDomains, $SmartHosts, $Enabled, $TlsSettings, $CloudServicesMailEnabled,
                    $UseMXRecord, $IsTransportRuleScoped, $RouteAllMessagesViaOnPremises, $AllAcceptedDomains)

                ($OutboundConnector |
                        Where-Object -Property Name -eq -Value $Name).SmartHosts | Should -Be $SmartHosts
            }

            It "<Name> Outbound additional configuration" -TestCases ($Test.Data.OutboundConnector) {
                Param ($Name, $RecipientDomains, $SmartHosts, $Enabled, $TlsSettings, $CloudServicesMailEnabled,
                    $UseMXRecord, $IsTransportRuleScoped, $RouteAllMessagesViaOnPremises, $AllAcceptedDomains)

                ($OutboundConnector |
                        Where-Object -Property Name -eq -Value $Name).TlsSettings | Should -Be $TlsSettings

                ($OutboundConnector |
                        Where-Object -Property Name -eq -Value $Name).CloudServicesMailEnabled | Should -Be $CloudServicesMailEnabled
            }

            It "<Name> Outbound routing configuration" -TestCases ($Test.Data.OutboundConnector) {
                Param ($Name, $RecipientDomains, $SmartHosts, $Enabled, $TlsSettings, $CloudServicesMailEnabled,
                    $UseMXRecord, $IsTransportRuleScoped, $RouteAllMessagesViaOnPremises, $AllAcceptedDomains)

                ($OutboundConnector |
                        Where-Object -Property Name -eq -Value $Name).UseMXRecord | Should -Be $UseMXRecord

                ($OutboundConnector |
                        Where-Object -Property Name -eq -Value $Name).IsTransportRuleScoped | Should -Be $IsTransportRuleScoped

                ($OutboundConnector |
                        Where-Object -Property Name -eq -Value $Name).RouteAllMessagesViaOnPremises | Should -Be $RouteAllMessagesViaOnPremises

                ($OutboundConnector |
                        Where-Object -Property Name -eq -Value $Name).AllAcceptedDomains | Should -Be $AllAcceptedDomains
            }

            It "No additional outbound connectors exist" {
                $Splat = @{
                    ReferenceObject  = $OutboundConnector.Name
                    DifferenceObject = $Test.Data.OutboundConnector.Name
                }

                Compare-Object @Splat | Should -BeNullOrEmpty
            }
        }
    }

    if ($Test.Data.RoleGroup.Count -ge 1) {
        Context "Role Groups" {
            $RoleGroups = Get-EOLRoleGroup

            It "<Name> exists" -TestCases ($Test.Data.RoleGroup) {
                Param ($Name, $Guid, $Roles, $Members)

                ($RoleGroups | Where-Object -Property Guid -eq $Guid) | Should -Not -BeNullOrEmpty
                ($RoleGroups | Where-Object -Property Guid -eq $Guid).Name | Should -Be $Name
            }

            It "<Name> has a description" -TestCases ($Test.Data.RoleGroup) {
                Param ($Name, $Guid, $Roles, $Members)

                ($RoleGroups | Where-Object -Property Guid -eq $Guid).Description | Should -Not -BeNullOrEmpty
            }

            It "<Name> has the correct assigned roles" -TestCases ($Test.Data.RoleGroup) {
                Param ($Name, $Guid, $Roles, $Members)

                ($RoleGroups | Where-Object -Property Guid -eq $Guid).Roles | Should -Be $Roles
            }

            It "<Name> has the correct assigned members" -TestCases ($Test.Data.RoleGroup) {
                Param ($Name, $Guid, $Roles, $Members)

                ($RoleGroups | Where-Object -Property Guid -eq $Guid).Members | Should -Be $Members
            }

            It "No additional role groups exist" {
                $Splat = @{
                    ReferenceObject  = $RoleGroups.Guid
                    DifferenceObject = $Test.Data.RoleGroup.Guid
                }

                Compare-Object @Splat | Should -BeNullOrEmpty
            }
        }
    }

    Context "Retention" {
        $DefaultRetention = Get-EOLRetentionPolicy | Where-Object -Property IsDefault -eq -Value $true
        $DefaultRetentionTags = $DefaultRetention.RetentionPolicyTagLinks | ForEach-Object {
            Get-EOLRetentionPolicyTag -Identity $_
        }

        It "Default Retention policy is set to $($Test.Data.RetentionPolicy.Name)" {
            $DefaultRetention.Name | Should -Be $Test.Data.RetentionPolicy.Name
            $DefaultRetention.IsDefault | Should -Be $Test.Data.RetentionPolicy.IsDefault
        }

        It "Default Retention policy has the correct tags applied" {
            $DefaultRetention.RetentionPolicyTagLinks | Should -Be $Test.Data.RetentionPolicy.RetentionPolicyTagLinks
        }

        It "Default Retention policy period" {
            $DefaultMailboxRetention = $DefaultRetentionTags | Where-Object { $_.Type -eq 'All' -and $_.RetentionEnabled -eq $true }

            $DefaultMailboxRetention.AgeLimitForRetention.Split('.')[0] | Sort-Object | Select-Object -Last 1 |
                Should -BeGreaterOrEqual $Test.Data.AgeLimitForRetention
        }
    }
}