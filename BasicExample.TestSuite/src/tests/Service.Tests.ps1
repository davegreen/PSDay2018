Describe "Service Tests" -Tags 'Services' {
    Context "General Data" {
        It "<Name> has the right status"  -TestCases $Test.Data.Services {
            Param ($Status, $Name)
            ($ServiceData | Where-Object Name -eq $Name).Status | Should -Be $Status
        }

        It "Required Processes are running" {
            ($Process).ProcessName | Should -Contain $Test.Data.Process
        }
    }
}
