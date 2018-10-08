Describe "Domains" -Tags 'Exchange Online', 'Domains' {
    $AcceptedDomain = Get-EOLAcceptedDomain
    $RemoteDomain = Get-EOLRemoteDomain

    It "Accepted domain <DomainName> is configured" -TestCases ($Test.Data.AcceptedDomain) {
        Param ($DomainName, $Default)

        $AcceptedDomain.DomainName | Should -Contain $DomainName -Because (
            'configuration specified domain names should exist')

        ($AcceptedDomain | Where-Object -Property DomainName -eq -Value $DomainName).Default | Should -Be $Default -Because (
            'the default domain name should match the specification')
    }

    It "No additional accepted domains exist" {
        $Splat = @{
            ReferenceObject  = $AcceptedDomain.DomainName
            DifferenceObject = $Test.Data.AcceptedDomain.DomainName
        }

        Compare-Object @Splat | Should -BeNullOrEmpty -Because (
            'additional domains should all be in the specified configuration.')
    }

    It "Remote domain <DomainName> is configured" -TestCases ($Test.Data.RemoteDomain) {
        Param ($DomainName, $AllowedOOFType)

        $RemoteDomain.DomainName | Should -Contain $DomainName -Because (
            'configuration specified domain names should exist')

        ($RemoteDomain | Where-Object -Property DomainName -eq -Value $DomainName).AllowedOOFType |
            Should -Be $AllowedOOFType -Because (
            'the out of office configuration should be as specified')
    }

    It "No additional remote domains exist" {
        $Splat = @{
            ReferenceObject  = $RemoteDomain.DomainName
            DifferenceObject = $Test.Data.RemoteDomain.DomainName
        }

        Compare-Object @Splat | Should -BeNullOrEmpty -Because (
            'additional domains should be in the specified configuration')
    }
}