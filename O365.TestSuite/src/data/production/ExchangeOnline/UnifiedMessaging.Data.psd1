@{
    # Unified messaging

    UMDialPlan                                     = @(
        @{
            Identity                      = 'O365-Unified'
            Name                          = 'O365-Unified'
            CountryOrRegionCode           = 44
            LogonFailuresBeforeDisconnect = 3
            NumberOfDigitsInExtension     = 4
            OutsideLineAccessCode         = $null
            UMAutoAttendant               = $null
            AccessTelephoneNumbers        = $null
        }
    )

    UMMailboxPolicy                                = @{
        Identity                    = 'O365-Unified Default Policy'
        Name                        = 'O365-Unified Default Policy'
        AllowCommonPatterns         = $false
        PINLifetime                 = 60 # Days
        PINHistoryCount             = 5
        MinPINLength                = 4
        UMDialPlan                  = 'O365-Unified'
        AllowPinlessVoiceMailAccess = $false
        LogonFailuresBeforePINReset = 5
        MaxLogonAttempts            = 15
    }
}