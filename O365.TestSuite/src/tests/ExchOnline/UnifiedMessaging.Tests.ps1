Describe "Unified Messaging" -Tags 'Exchange Online', 'Unified Messaging' {
    $UMAutoAttendant = Get-EOLUMAutoAttendant

    Context "Dial Plan" {
        $UMDialPlan = Get-EOLUMDialPlan

        It "At least one dial plan exists" {
            ($UMDialPlan | Measure-Object).Count | Should -BeGreaterOrEqual 1 -Because (
                'a dial plan should exist')
        }

        It "<Name> exists" -TestCases ($Test.Data.UMDialPlan) {
            Param ($Identity, $Name, $CountryOrRegionCode, $LogonFailuresBeforeDisconnect,
                $NumberOfDigitsInExtension, $OutsideLineAccessCode, $UMAutoAttendant, $AccessTelephoneNumbers)

            $UMDialPlan.Identity | Should -Contain $Identity -Because (
                'existing dial plans should be as configured')
        }

        It "<Name> will disconnect callers after unsuccessful logins" -TestCases ($Test.Data.UMDialPlan) {
            Param ($Identity, $Name, $CountryOrRegionCode, $LogonFailuresBeforeDisconnect,
                $NumberOfDigitsInExtension, $OutsideLineAccessCode, $UMAutoAttendant, $AccessTelephoneNumbers)

            ($UMDialPlan | Where-Object -Property Identity -eq -Value $Identity).LogonFailuresBeforeDisconnect |
                Should -Be $LogonFailuresBeforeDisconnect -Because (
                'dial plans should meet the configured disconnection limit')
        }

        It "<Name> refers to the configured Auto Attendant" -TestCases ($Test.Data.UMDialPlan) {
            Param ($Identity, $Name, $CountryOrRegionCode, $LogonFailuresBeforeDisconnect,
                $NumberOfDigitsInExtension, $OutsideLineAccessCode, $UMAutoAttendant, $AccessTelephoneNumbers)

            ($UMDialPlan | Where-Object -Property Identity -eq -Value $Identity).UMAutoAttendant |
                Should -Be $UMAutoAttendant -Because (
                'dial plans should refer to the expected auto attendant')
        }

        It "Access telephone numbers for <Name> are configured" -TestCases ($Test.Data.UMDialPlan) {
            Param ($Identity, $Name, $CountryOrRegionCode, $LogonFailuresBeforeDisconnect,
                $NumberOfDigitsInExtension, $OutsideLineAccessCode, $UMAutoAttendant, $AccessTelephoneNumbers)

            ($UMDialPlan | Where-Object -Property Identity -eq -Value $Identity).AccessTelephoneNumbers |
                Should -Be $AccessTelephoneNumbers -Because (
                'Access telephone numbers should be as configured')

            (($UMDialPlan | Where-Object -Property Identity -eq -Value $Identity).AccessTelephoneNumbers |
                    Measure-Object).Count | Should -BeGreaterOrEqual 1 -Because (
                'Access telephone numbers are needed for the correct operation of voicemail')

            ($UMDialPlan | Where-Object -Property Identity -eq -Value $Identity).AccessTelephoneNumbers |
                Should -Not -Be $null -Because (
                'Access telephone numbers are needed for the correct operation of voicemail')
        }

        It "Extra dial plans don't exist" {
            $Splat = @{
                ReferenceObject  = $UMDialPlan.Identity
                DifferenceObject = $Test.Data.UMDialPlan.Identity
            }

            Compare-Object @Splat | Should -BeNullOrEmpty -Because (
                'additional dial plans should not exist')
        }
    }

    Context "Mailbox Policy" {
        $UMPolicy = Get-EOLUMMailboxPolicy

        It "At least one UM Mailbox policy exists" {
            ($UMPolicy | Measure-Object).Count | Should -BeGreaterOrEqual 1 -Because (
                'at least one UM mailbox policy exists')
        }

        It "<Name> exists" -TestCases ($Test.Data.UMMailboxPolicy) {
            Param ($Identity, $Name, $AllowCommonPatterns, $PINLifetime, $PINHistoryCount, $MinPINLength,
                $UMDialPlan, $AllowPinlessVoiceMailAccess, $LogonFailuresBeforePINReset, $MaxLogonAttempts)

            $UMPolicy.Identity | Should -Contain $Identity -Because (
                'configured UM mailbox policy exists')
        }

        It "PIN requirements for <Name> are secure" -TestCases ($Test.Data.UMMailboxPolicy) {
            Param ($Identity, $Name, $AllowCommonPatterns, $PINLifetime, $PINHistoryCount, $MinPINLength,
                $UMDialPlan, $AllowPinlessVoiceMailAccess, $LogonFailuresBeforePINReset, $MaxLogonAttempts)

            ($UMPolicy | Where-Object -Property Identity -eq -Value $Identity).AllowCommonPatterns |
                Should -Be $AllowCommonPatterns -Because (
                'UM mailbox policy common patters should be as configured')

            ($UMPolicy | Where-Object -Property Identity -eq -Value $Identity).MinPINLength |
                Should -BeGreaterOrEqual $MinPINLength -Because (
                'UM mailbox PIN length should be as configured')
        }

        It "PIN lifetime and history for <Name> is secure" -TestCases ($Test.Data.UMMailboxPolicy) {
            Param ($Identity, $Name, $AllowCommonPatterns, $PINLifetime, $PINHistoryCount, $MinPINLength,
                $UMDialPlan, $AllowPinlessVoiceMailAccess, $LogonFailuresBeforePINReset, $MaxLogonAttempts)

            [int]($UMPolicy | Where-Object -Property Identity -eq -Value $Identity).PINLifetime.Split('.')[0] |
                Should -BeGreaterOrEqual $PINLifetime -Because (
                'UM mailbox PIN lifetime should be as configured')

            ($UMPolicy | Where-Object -Property Identity -eq -Value $Identity).PINHistoryCount |
                Should -Be $PINHistoryCount -Because (
                'UM mailbox PIN history should be as configured')
        }

        It "Pinless access is disabled for <Name>" -TestCases ($Test.Data.UMMailboxPolicy) {
            Param ($Identity, $Name, $AllowCommonPatterns, $PINLifetime, $PINHistoryCount, $MinPINLength,
                $UMDialPlan, $AllowPinlessVoiceMailAccess, $LogonFailuresBeforePINReset, $MaxLogonAttempts)

            ($UMPolicy | Where-Object -Property Identity -eq -Value $Identity).AllowPinlessVoiceMailAccess |
                Should -Be $AllowPinlessVoiceMailAccess -Because (
                'UM mailbox policy PINless voicemail access should be as configured')
        }

        It "Max login attempts for <Name> are configured" -TestCases ($Test.Data.UMMailboxPolicy) {
            Param ($Identity, $Name, $AllowCommonPatterns, $PINLifetime, $PINHistoryCount, $MinPINLength,
                $UMDialPlan, $AllowPinlessVoiceMailAccess, $LogonFailuresBeforePINReset, $MaxLogonAttempts)

            ($UMPolicy | Where-Object -Property Identity -eq -Value $Identity).LogonFailuresBeforePINReset |
                Should -Be $LogonFailuresBeforePINReset -Because (
                'UM mailbox policy logon attempts before PIN reset should be as configured')

            ($UMPolicy | Where-Object -Property Identity -eq -Value $Identity).MaxLogonAttempts |
                Should -Be $MaxLogonAttempts -Because (
                'UM mailbox policy maximum logon attempts should be as configured')
        }

        It "Extra UM mailbox policies don't exist" {
            $Splat = @{
                ReferenceObject  = $UMPolicy.Identity
                DifferenceObject = $Test.Data.UMMailboxPolicy.Identity
            }

            Compare-Object @Splat | Should -BeNullOrEmpty -Because (
                'additional UM mailbox policies should not exist')
        }
    }

    Context "Auto Attendant" {
        It "At least one UM Auto Attendant exists" {
            ($UMAutoAttendant | Measure-Object).Count | Should -BeGreaterOrEqual 1 -Because (
                'an auto attendant should exist')
        }
    }
}