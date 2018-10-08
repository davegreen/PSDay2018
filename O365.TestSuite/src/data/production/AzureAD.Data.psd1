@{
    ConnectCredentials     = @{
        Key     = "365Admin"
        Message = "Admin credentials for Azure AD"
    }

    # Azure AD is aware of a directory sync happening in the last two hours.
    CompanyLastDirSyncTime = 1 # Hours
    DisplayName            = 'Tookitaway'
    PrimaryUPNSuffix       = 'tookitaway.co.uk'

    # Some data about the Azure AD applications that should be configured. Applications not here
    AADApplications        = @(
        # No IdentifierUris or Oauth2Permissions yet.
        @{
            AppId       = 'ab5c1106-bb9e-4a14-a122-dc6db1fd6752'
            ObjectId    = 'a17b4a3d-7b46-4a72-be62-ffa0ae25ff65'
            DisplayName = 'THIS IS A TEST!'
            Homepage    = 'https://account.activedirectory.windowsazure.com:444/applications/default.aspx?metadata=customappsso|ISV9.1|primary|z'
            ReplyUrls   = $null
        }
    )

    AADAccessGroups        = @(
        @{
            ResourceDisplayName  = 'Group'
            PrincipalDisplayName = 'DisplayName'
            ObjectId             = '_u0nA_qRakik34hysMNGErRinbjZeBHgpvdhTjU-Mw'
        }
    )

    # Verified domains that should be present in the tenant.
    Domains                = @(
        @{ Domain = 'tookitaway.co.uk' }
    )

    # Other licenses that need to be checked, but are not critical to business operations.
    EnabledSkus            = @(
        #@{ SKU = 'VISIOCLIENT' },
        #@{ SKU = 'POWER_BI_PRO' },
        #@{ SKU = 'POWER_BI_STANDARD' },
        #@{ SKU = 'WINDOWS_STORE' },
        #@{ SKU = 'RMSBASIC' }
        @{ SKU = 'DEVELOPERPACK' }
    )

    # Licenses that are absolutely required for basic functionality.
    RequiredSkus           = @(
        #@{ SKU = 'EMS' },    
        @{ SKU = 'DEVELOPERPACK' }
    )
}