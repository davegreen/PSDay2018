Describe "Service Tests" -Tags 'Services' {
    Context "General Data" {
        It "<Name> has the right status"  -TestCases $Test.Data.Services {
            Param ($Status, $Name)
            ($ServiceData | Where-Object Name -eq $Name).Status | Should -Be $Status
        }
    }
}
