function Invoke-TestSuite {
    <#
        .Synopsis
        Acts as a wrapper for Invoke-TestSuiteTest, Invoke-ReportUnit and Write-TestSummary to orchestrate running test suites.

        .Description
        Acts as a wrapper for Invoke-TestSuiteTest, Invoke-ReportUnit and Write-TestSummary to orchestrate running test suites.

        .Parameter TestSuite
        The TestSuite to run.

        .Parameter Version
        The version of the TestSuite to run (of more than one exists).

        .Parameter OutputPath
        The path to output test results to.

        .Parameter OutputHTML
        Output HTML reports (using ReportUnit).

        .Parameter OpenHTML
        Attempt to open the ReportUnit test index.html after running the test suite.

        .Parameter NoSummary
        Suppress creating a test suite summary.

        .Parameter SummaryPath
        The path to write (or append) the summary to. Defaults to the root of the test/html output.

        .Example
        Invoke-TestSuite -TestSuite O365.TestSuite -OutputPath .\path\to\output

        Runs the test suite (using the module name as the Test suite).
        Test summaries are also written to file using Write-TestSummary.

        .Notes
        Author: David Green
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [Alias('Name')]
        [string]
        $TestSuite,

        [Parameter()]
        [version]
        $Version,

        [Parameter()]
        [System.IO.DirectoryInfo]
        $OutputPath = '.\reports',

        [Parameter()]
        [switch]
        $OutputHTML,

        [Parameter()]
        [switch]
        $OpenHTML,

        [Parameter()]
        [switch]
        $NoSummary,

        [Parameter()]
        [System.IO.FileInfo]
        $SummaryPath,

        [Parameter()]
        [string]
        $Environment,

        [Parameter()]
        [string[]]
        $ExcludeTests,

        [Parameter()]
        [string[]]
        $IncludeTests,
        
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
        $TestResultShow
    )

    # Pre-checks
    if (-not (Test-Path -Path $OutputPath -PathType Container)) {
        $null = New-Item -Path $OutputPath -ItemType Directory
    }

    if ($Version) {
        if ((Get-Module '*.TestSuite').Name -like "$TestSuite*" | Where-Object Version -eq $Version) {
            $Module = ((Get-Module '*.TestSuite') |
                Where-Object { $_.Name -like "$TestSuite*" -and $_.Version -eq $Version } | Select-Object -First 1)
        }
        elseif ((Get-Module '*.TestSuite' -ListAvailable).Name -like "$TestSuite*" | Where-Object Version -eq $Version) {
            $Module = ((Get-Module '*.TestSuite' -ListAvailable) |
                Where-Object { $_.Name -like "$TestSuite*" -and $_.Version -eq $Version } | Select-Object -First 1)
        }
        else {
            throw "No testsuite module found for name $TestSuite with version $Version."
        }
    }
    else {
        if ((Get-Module '*.TestSuite').Name -like "$TestSuite*") {
            $Module = ((Get-Module '*.TestSuite') |
                Where-Object Name -like "$TestSuite*" | Select-Object -First 1)
        }
        elseif ((Get-Module '*.TestSuite' -ListAvailable).Name -like "$TestSuite*") {
            $Module = ((Get-Module '*.TestSuite' -ListAvailable) |
                Where-Object Name -like "$TestSuite*" | Select-Object -First 1)
        }
        else {
            throw "No testsuite module found for name $TestSuite."
        }
    }

    $TestSuite = $Module.Name
    $Path      = $Module.ModuleBase
    $Version   = $Module.Version

    $CurrentTime = Get-Date -Format FileDateTimeUniversal
    $OutputPath = New-Item -Path $OutputPath\$CurrentTime -ItemType Directory

    if (-not $SummaryPath) {
        $SummaryPath = $OutputPath.FullName
    }

    if (-not $Environment) {
        $Environments = (Get-TestSuiteData -TestSuite $TestSuite |
            Where-Object -Property Version -eq $Version).Environment

        if ($Environments -match 'prod|prd|production') {
            $Environment = $Environments -match 'prod|prd|production' | Select-Object -Unique -First 1
        }
        else {
            $Environment = $Environments | Select-Object -Unique -First 1
        }
    }

    $SummaryPath = (Resolve-Path -Path $SummaryPath).Path

    Write-Verbose -Message "Invoking test suite $TestSuite ($Version) from $Path."

    $TestData = Get-TestSuiteData -TestSuite $TestSuite -Environment $Environment |
        Where-Object -Property Version -eq $Version

    if ($ExcludeTests) {
        $TestData = $TestData | Where-Object -Property Name -NotIn $ExcludeTests
    }

    if ($IncludeTests) {
        $TestData = $TestData | Where-Object -Property Name -In $IncludeTests
    }

    foreach ($TestSet in $TestData) {
        if ($TestResultShow) {
            Invoke-TestSuiteTest -TestObject $TestSet -OutputPath $OutputPath.FullName -TestResultShow $TestResultShow
        }
        else {
            Invoke-TestSuiteTest -TestObject $TestSet -OutputPath $OutputPath.FullName
        }
    }

    if ($OutputHTML -or $OpenHTML) {
        Write-Verbose -Message "Invoking ReportUnit on $($OutputPath.FullName)"
        Invoke-ReportUnit -Path $OutputPath.FullName -OpenHtml:$OpenHTML
    }

    if (-not $NoSummary) {
        Write-Verbose -Message "Writing test summary to $SummaryPath"
        Write-TestSummary -Path $OutputPath.FullName |
            Export-Csv -Path "$SummaryPath\testsummary.csv" -NoTypeInformation -Append
    }
}