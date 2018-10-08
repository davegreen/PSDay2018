Describe "SaaS Applications" -Tags 'General' {
    Context "Availability" {
        It "Pages for <Name> are available" -TestCases ($Test.Data.SaaSApplication) {
            Param($HomeUri)

            foreach ($Uri in $HomeUri) {
                (Invoke-WebRequest -Uri $Uri -UseBasicParsing).StatusCode | Should -Be 200 -Because (
                    'these webpages should return correctly')
            }
        }
    }
}