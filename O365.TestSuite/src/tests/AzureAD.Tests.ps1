Describe "Azure AD" -Tags 'Azure AD' {
    Context "AD Connect" {
        It "Azure AD Connect Sync has run recently" {
            if ($LastSync) {
                $LastSync = [datetime](Get-Date).ToUniversalTime().AddHours( - $($Test.Data.CompanyLastDirSyncTime))
                (Get-AzureADTenantDetail).CompanyLastDirSyncTime |
                    Should -BeGreaterThan $LastSync -Because (
                    'Azure AD sync should be running regularly')
            }
            else {
                $LastSync | Should -Be $null
            }
        }
    }

    Context "AD Connect and Domains" {
        $AADDomains = (Get-AzureADTenantDetail).VerifiedDomains.Name

        It "Domain <domain> is added" -TestCases ($Test.Data.Domains) {
            Param ($Domain)

            $AADDomains | Should -Contain $Domain -Because (
                'domains should exist in Office 365')
        }
    }

    Context "Licensing" {
        $EnabledSKUs = (Get-AzureADSubscribedSku) | Where-Object -Property CapabilityStatus -eq -Value Enabled |
            Select-Object -Property SkuPartNumber, ConsumedUnits -ExpandProperty PrepaidUnits

        Context "Required" {
            It "<SKU>" -TestCases ($Test.Data.RequiredSkus) {
                Param ($SKU)

                $EnabledSKUs.SkuPartNumber | Should -Contain $SKU -Because (
                    'required license SKUs must be available')
            }

            It "Available for <SKU>" -TestCases ($Test.Data.RequiredSkus) {
                Param ($SKU)

                $AADSKU = $EnabledSKUs | Where-Object -Property SkuPartNumber -eq $SKU
                $AADSKU.ConsumedUnits  | Should -BeLessOrEqual ($AADSKU.Enabled + $AADSKU.Warning) -Because (
                    'required license SKUs must be enabled')
            }

            It "No suspended or warnings for <SKU>" -TestCases ($Test.Data.RequiredSkus) {
                Param ($SKU)

                $AADSKU = $EnabledSKUs | Where-Object -Property SkuPartNumber -eq $SKU
                $AADSKU.Suspended      | Should -Be 0 -Because (
                    'required license SKUs should have no suspended items')

                $AADSKU.Warning        | Should -Be 0 -Because (
                    'required license SKUs should have no warning items')
            }

            It "Has 2% extra <SKU> for new starters" -TestCases ($Test.Data.RequiredSkus) {
                Param ($SKU)

                $AADSKU = $EnabledSKUs | Where-Object -Property SkuPartNumber -eq $SKU
                ([int]($AADSKU.ConsumedUnits + $AADSKU.ConsumedUnits * 0.02)) |
                    Should -BeLessOrEqual ($AADSKU.Enabled + $AADSKU.Warning) -Because (
                    'there should be 2% free licenses for growth on the required SKUs for new starters')
            }
        }

        Context "Enabled" {
            It "<SKU>" -TestCases ($Test.Data.EnabledSkus) {
                Param ($SKU)

                $EnabledSKUs.SkuPartNumber | Should -Contain $SKU -Because (
                    'enabled license SKUs must be available')
            }

            It "Available for <SKU>" -TestCases ($Test.Data.EnabledSkus) {
                Param ($SKU)

                $AADSKU = $EnabledSKUs | Where-Object -Property SkuPartNumber -eq $SKU
                $AADSKU.ConsumedUnits  | Should -BeLessOrEqual $AADSKU.Enabled -Because (
                    'consumed license SKUs must be less than available ones')
            }

            It "No suspended or warnings for <SKU>" -TestCases ($Test.Data.EnabledSkus) {
                Param ($SKU)

                $AADSKU = $EnabledSKUs | Where-Object -Property SkuPartNumber -eq $SKU
                $AADSKU.Suspended      | Should -Be 0 -Because (
                    'license SKUs should have no suspended items')

                $AADSKU.Warning        | Should -Be 0 -Because (
                    'license SKUs should have no warning items')
            }
        }
    }

    Context "Applications" {
        $Applications = Get-AzureADApplication
        $AccessGroups = Get-AzureADGroup -all $true | Get-AzureADGroupAppRoleAssignment

        It "No unknowns" {
            $Splat = @{
                ReferenceObject  = $Applications.DisplayName
                DifferenceObject = $Test.Data.AADApplications.DisplayName
            }

            Compare-Object @Splat | Should -BeNullOrEmpty -Because (
                'additional unknown applications should not exist')
        }

        Context "Required" {
            $RequiredApplications = $Test.Data.AADApplications | Where-Object -Property Required -eq -Value $true

            if ($RequiredApplications) {
            It "<DisplayName> exists" -TestCases ($RequiredApplications) {
                Param($AppId, $ObjectId, $DisplayName)

                $Applications.AppId | Should -Contain $AppId -Because (
                    'expected application should exist')

                ($Applications | Where-Object -Property AppId -eq -Value $AppId).ObjectId |
                    Should -Be $ObjectId -Because (
                    'expected application should exist with expected ObjectId')

                ($Applications | Where-Object -Property AppId -eq -Value $AppId).DisplayName |
                    Should -Be $DisplayName  -Because (
                    'expected application should exist with expected display name')
            }

            It "<DisplayName> homepage is configured as desired" -TestCases ($RequiredApplications) {
                Param($AppId, $HomePage, $ReplyUrls)

                ($Applications | Where-Object -Property AppId -eq -Value $AppId).HomePage |
                    Should -Be $HomePage -Because (
                    'application homepage should exist as expected')
            }

            It "<DisplayName> reply urls are configured as desired" -TestCases ($RequiredApplications) {
                Param($AppId, $HomePage, $ReplyUrls)

                ($Applications | Where-Object -Property AppId -eq -Value $AppId).ReplyUrls |
                    Should -Be $ReplyUrls -Because (
                    'application reply URLs should exist as expected')
            }

                It "<DisplayName> access groups are configured as desired" -TestCases ($RequiredApplications) {
                    Param($AppId, $HomePage, $ReplyUrls)

                    $DisplayName = ($Applications | Where-Object -Property AppId -eq -Value $AppId).DisplayName
                    $Groups = $AccessGroups | Where-Object -Property ResourceDisplayName -eq -Value $DisplayName

                    foreach ($Group in $Groups) {
                        $Group.ResourceDisplayName |
                            Should -BeIn $Test.Data.AADAccessGroups.ResourceDisplayName -Because (
                            'application resource display name should exist as expected')

                        $Group.PrincipalDisplayName |
                            Should -BeIn $Test.Data.AADAccessGroups.PrincipalDisplayName -Because (
                            'application principal display name should exist as expected')

                        $Group.ObjectId |
                            Should -BeIn $Test.Data.AADAccessGroups.ObjectId -Because (
                            'application resource object ID should exist as expected')
                    }
                }
            }
        }

        Context "Non-critical" {
            $OtherApplications = $Test.Data.AADApplications | Where-Object -Property Required -ne -Value $true

            It "<DisplayName> exists" -TestCases ($OtherApplications) {
                Param($AppId, $ObjectId, $DisplayName)

                $Applications.AppId | Should -Contain $AppId -Because (
                    'expected application should exist')

                ($Applications | Where-Object -Property AppId -eq -Value $AppId).ObjectId |
                    Should -Be $ObjectId -Because (
                    'expected application should exist with expected ObjectId')

                ($Applications | Where-Object -Property AppId -eq -Value $AppId).DisplayName |
                    Should -Be $DisplayName  -Because (
                    'expected application should exist with expected display name')
            }

            It "<DisplayName> homepage is configured as desired" -TestCases ($OtherApplications) {
                Param($AppId, $HomePage, $ReplyUrls)

                ($Applications | Where-Object -Property AppId -eq -Value $AppId).HomePage |
                    Should -Be $HomePage -Because (
                    'application homepage should exist as expected')
            }

            It "<DisplayName> reply urls are configured as desired" -TestCases ($OtherApplications) {
                Param($AppId, $HomePage, $ReplyUrls)

                ($Applications | Where-Object -Property AppId -eq -Value $AppId).ReplyUrls |
                    Should -Be $ReplyUrls -Because (
                    'application reply URLs should exist as expected')
            }

            It "<DisplayName> access groups are configured as desired" -TestCases ($OtherApplications) {
                Param($AppId, $HomePage, $ReplyUrls)

                $DisplayName = ($Applications | Where-Object -Property AppId -eq -Value $AppId).DisplayName
                $Groups = $AccessGroups | Where-Object -Property ResourceDisplayName -eq -Value $DisplayName

                foreach ($Group in $Groups) {
                    $Group.ResourceDisplayName |
                        Should -BeIn $Test.Data.AADAccessGroups.ResourceDisplayName -Because (
                        'application resource display name should exist as expected')

                    $Group.PrincipalDisplayName |
                        Should -BeIn $Test.Data.AADAccessGroups.PrincipalDisplayName -Because (
                        'application principal display name should exist as expected')

                    $Group.ObjectId |
                        Should -BeIn $Test.Data.AADAccessGroups.ObjectId -Because (
                        'application resource object ID should exist as expected')
                }
            }
        }
    }

    Context "Service Principals" {
        $Applications = Get-AzureADApplication
        $AppServicePrincipals = Get-AzureADServicePrincipal | Where-Object -Property AppId -In $Applications.AppId

        foreach ($SP in ($AppServicePrincipals | Where-Object -Property KeyCredentials)) {
            It "$($SP.DisplayName) Keys valid" {
                $SP.KeyCredentials.EndDate |
                    Should -BeGreaterThan (Get-Date).ToUniversalTime() -Because (
                    'application keys should be valid')
            }

            It "$($SP.DisplayName) Keys valid for more than two months" {
                $SP.KeyCredentials.EndDate |
                    Should -BeGreaterThan (Get-Date).ToUniversalTime().AddMonths(2) -Because (
                    'application keys should be valid for the next two months')
            }
        }

        foreach ($SP in ($AppServicePrincipals | Where-Object -Property PasswordCredentials)) {
            It "$($SP.DisplayName) Passwords valid" {
                $SP.PasswordCredentials.EndDate |
                    Should -BeGreaterThan (Get-Date).ToUniversalTime() -Because (
                    'application passwords should be valid')
            }

            It "$($SP.DisplayName) Passwords valid for more than two months" {
                $SP.PasswordCredentials.EndDate |
                    Should -BeGreaterThan (Get-Date).ToUniversalTime().AddMonths(2) -Because (
                    'application passwords should be valid')
            }
        }
    }

    Context "Users" {
        $AllUsers = Get-AzureADUser -All $true
        $LicensedUsers = $AllUsers | Where-Object -Property AssignedLicenses

        $ErrorUsers = $AllUsers | Where-Object {
            $_.UserPrincipalName -like "*@$($Test.Data.PrimaryUPNSuffix)" -and
            $_.Mail -ne $null -and
            $_.UserPrincipalName -ne $_.Mail -and
            $_.ProvisionedPlans -ne $null -and
            $_.DirSyncEnabled -eq $true
        }

        $LicensedErrorUsers = $LicensedUsers | Where-Object {
            $_.UserPrincipalName -like "*@$($Test.Data.PrimaryUPNSuffix)" -and
            $_.Mail -ne $null -and
            $_.UserPrincipalName -ne $_.Mail -and
            $_.ProvisionedPlans -ne $null -and
            $_.DirSyncEnabled -eq $true
        }

        It "Errors should be under 1% of total users" {
            ($ErrorUsers | Measure-Object).Count / ($AllUsers | Measure-Object).Count * 100 |
                Should -BeLessThan 1  -Because (
                'user errors should be low')
        }

        It "Licensed users should have no errors" {
            ($LicensedErrorUsers | Measure-Object).Count / ($LicensedUsers | Measure-Object).Count * 100 |
                Should -BeLessThan 1  -Because (
                'user errors should be low')
        }

        It "Licensed users should have matching UPNs and Mail addresses" {
            foreach ($User in $LicensedErrorUsers) {
                $User.UserPrincipalName | Should -Be $User.Mail -Because (
                    'all userprincipalnames should match primary email addresses')
            }
        }

        Context "Cloud Users" {
            $CloudUsers = $LicensedUsers | Where-Object {
                $_.DirSyncEnabled -ne $True -and
                $_.UserType -ne 'Guest'
            }

            It "Mailboxes" {
                $CloudUsers.Mail | Should -Not -Be $null -Because (
                    'There should be cloud only users with mailboxes')
            }
        }
        Context "Guests" {
            $GuestUsers = $AllUsers | Where-Object { $_.UserType -eq 'Guest' }

            It "Not too many recent guest shares in the last 30 days" {
                ($GuestUsers |
                    Where-Object -Property RefreshTokensValidFromDateTime -gt -Value ((Get-Date).Adddays(-30)) |
                    Measure-Object).Count |
                    Should -BeLessOrEqual (($GuestUsers | Measure-Object).Count / 2) -Because (
                    'too many guest shares may be a symptom of account/data breach')
            }
        }
    }
}