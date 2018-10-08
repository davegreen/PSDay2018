# O365-Testing

A PowerShell module for running test suites for platforms using business data rules.

The following functions are included in the module:

## Get-TestSuite

Usage:

> Get-TestSuite

Output:

Outputs module data about test suite modules that have been discovered using names (for module directories) or though paths to a module *.psm1* or *.psd1*.

## Invoke-TestSuiteTest

Usage:

> Invoke-TestSuiteTest -Path .\path\to\tests -OutputPath .\path\to\output

Output:

Pester test output (if requested).

Runs the test suite test files included within the **Path**. Output folder can be chosen. A folder will be created within this folder representing the current date and time in ISO 8601 format and the test XML will be saved there.

## Invoke-ReportUnit

Usage:

> Invoke-ReportUnit -Path .\path\to\nunit\test\output

Output:

Raw output from ReportUnit containing info about the XML files being processed.

This downloads (if required) and runs reportunit on the specified files. **Path** refers to the path of the NUnit test output. **OutputPath** refers to the location to output the HTML files.

## Invoke-TestSuite

Usage:

> Invoke-TestSuite -TestSuite O365.TestSuite -OutputPath .\path\to\output

Output:

None.

Runs the Office 365 Tests (using the module name as the Test suite), with some optional additional functionality around visualization of output and summarising test data. Report visualization is generated using [ReportUnit](http://reportunit.relevantcodes.com/). Test summaries are also written to file using **Write-TestSummary**.

## Write-TestSummary

Usage:

> Write-TestSummary -Path .\path\to\output

Output:

None.

Writes a test summary to standard output. To summarise tests, pass it a folder containing XML files, or an XML file directly and the test summary will be generated.