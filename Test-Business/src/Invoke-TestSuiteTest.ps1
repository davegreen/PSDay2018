function Invoke-TestSuiteTest {
    <#
        .Synopsis
        Runs tests and outputs the results to the output directory.

        .Description
        Runs tests and outputs the results to the output directory.

        .Parameter Path
        The path of the tests to execute.

        .Parameter OutputPath
        The output path to write nUnit test results to.
        A folder will be created within this folder representing the current date and time in ISO 8601 format and the test XML will be saved there.

        .Parameter TestResultShow
        The test results to output to standard output. Valid values are:

            'None',
            'All',
            'Context',
            'Default',
            'Describe',
            'Fails',
            'Failed',
            'Header',
            'Inconclusive',
            'Passed',
            'Pending',
            'Skipped',
            'Summary'

        .Example
        Invoke-TestSuiteTest -Path .\path\to\tests -OutputPath .\path\to\output

        Runs the test suite test files included within the Path and outputs nUnit test data to the Output folder.

        .Notes
        Author: David Green
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [PSCustomObject[]]
        $TestObject,

        [Parameter(Mandatory)]
        [System.IO.FileInfo]
        $OutputPath,

        [Parameter()]
        [ValidateSet(
            'None',
            'All',
            'Context',
            'Default',
            'Describe',
            'Fails',
            'Failed',
            'Header',
            'Inconclusive',
            'Passed',
            'Pending',
            'Skipped',
            'Summary'
        )]
        [string[]]
        $TestResultShow = 'Failed'
    )

    if (-not (Test-Path $OutputPath -Type Container)) {
        throw "Output path must be a folder"
    }
    else {
        foreach ($Test in ($TestObject)) {
            $PesterSplat = @{
                Script       = $Test.TestPath
                OutputFile   = "$OutputPath\$($Test.Name).xml"
                OutputFormat = 'NUnitXml'
                Show         = $TestResultShow
            }

            Write-Verbose -Message "Invoking Tests for $($Test.Name)"

            if ($Test.HelperPath) {
                . $Test.HelperPath
            }

            Invoke-Pester @PesterSplat
        }
    }
}