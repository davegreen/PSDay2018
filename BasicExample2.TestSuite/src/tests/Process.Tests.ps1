Describe "Service Tests" -Tags 'Services' {
    Context "Process Data" {
        It "Required Processes are running" {
            ($Process).ProcessName | Should -Contain $Test.Data.Process
        }
    }
}