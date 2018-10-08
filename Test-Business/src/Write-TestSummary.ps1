function Write-TestSummary {
    <#
        .Synopsis
        Gets test data from a set of test results and outputs summary information for the results.

        .Description
        Gets test data from a set of test results and outputs summary information for the results.
        To summarise tests, pass it a folder containing XML files, or an XML file directly and the test summary will be generated.

        .Parameter Path
        The folder containing test results to get test summary data for.

        .Example
        Write-TestSummary -Path .\path\to\output

        Writes a test summary to standard output.

        .Notes
        Author: David Green
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo[]]
        $Path
    )

    foreach ($filepath in (Get-ChildItem -Path $Path -Filter '*.xml')) {
        try {
            $xml = [xml](Get-Content -Path $filepath.FullName)

            [int]$Fails = $($xml.'test-results'.invalid) +
            $($xml.'test-results'.errors) +
            $($xml.'test-results'.failures)

            [int]$Passes = $xml.'test-results'.total - $Fails

            if ($Fails -eq 0) {
                $PassPercent = 100
            }
            else {
                $PassPercent = $Passes / ($xml.'test-results'.total) * 100
            }

            $Output = @{
                FileName     = $filepath.Name
                TestDate     = $xml.'test-results'.date
                TestTime     = $xml.'test-results'.time
                Tests        = $xml.'test-results'.total
                Errors       = $xml.'test-results'.errors
                Failures     = $xml.'test-results'.failures
                NotRun       = $xml.'test-results'.'not-run'
                Inconclusive = $xml.'test-results'.inconclusive
                Ignored      = $xml.'test-results'.ignored
                Skipped      = $xml.'test-results'.skipped
                Invalid      = $xml.'test-results'.invalid
                TimeTaken    = $xml.'test-results'.'test-suite'.time
                SuiteTime    = $filepath.Directory.Name
                Passes       = $Passes
                Fails        = $Fails
                PassPercent  = $PassPercent
            }

            New-Object -TypeName psobject -Property $Output
        }
        catch {
            throw "error getting summary results from $($filepath.fullname)"
            break
        }
    }
}