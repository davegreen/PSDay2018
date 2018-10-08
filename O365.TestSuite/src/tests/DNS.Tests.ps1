Describe "DNS" -Tags 'DNS' {
    $DNSTests = {
        It "Basic DNS <Type> record for <DomainName>" -TestCases ($Test.Data.Records |
                Where-Object -Property Side -Contains -Value $Context) {
            Param ($DomainName, $Type, $Priority, $Value)

            $DNSResult = (Resolve-DnsName -Server $DNSServer -Type $Type -Name $DomainName -ErrorAction SilentlyContinue)
            switch ($Type) {
                'A' {
                    $ExpectedValue = ($Test.Data.Records |
                            Where-Object {
                            $_.DomainName -eq $DomainName -and $_.Type -eq $Type -and $_.Side -contains $Context
                        }).Value

                    $Splat = @{
                        ReferenceObject  = $DNSResult.IPAddress
                        DifferenceObject = $ExpectedValue
                    }

                    Compare-Object @Splat | Should -BeNullOrEmpty -Because (
                        'Expected IP addresses should be returned.')

                    foreach ($IP in $DNSResult.IPAddress) {
                        $IP | Should -BeIn $Value -Because (
                            'Additional IP addresses should not be returned.')
                    }
                }
                'MX' {
                    $MXRecords = $DNSResult | Sort-Object -Property Preference
                    $MXRecords.NameExchange | Should -Be $Value -Because (
                        'Expected MX record target should be returned.')

                    $MXRecords.Preference   | Should -Be $Priority -Because (
                        'Expected MX record priority should be returned.')
                }
                'TXT' {
                    $DNSResult.Strings | Sort-Object | Should -Be $Value -Because (
                        'Expected text string should be returned.')
                }
            }
        }
    }

    Context "Public" {
        [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
        $DNSServer = '8.8.8.8', '8.8.4.4'

        [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
        $Context = 'Public'

        . $DNSTests
    }

    Context "Private" {
        [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
        $DNSServer = '172.26.30.213', '172.26.13.41'

        [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
        $Context = 'Private'

        . $DNSTests
    }
}