#
.\Test-Business\build.ps1 -Task Install
.\BasicExample.TestSuite\build.ps1 -Task Install
.\BasicExample2.TestSuite\build.ps1 -Task Install
.\O365.TestSuite\build.ps1 -Task Install

# Show
Get-TestSuite

# 1
Get-TestSuiteData -TestSuite BasicExample.TestSuite
Invoke-TestSuite -TestSuite BasicExample.TestSuite -TestResultShow All

# 2
Get-TestSuiteData -TestSuite BasicExample2.TestSuite
Invoke-TestSuite -TestSuite BasicExample2.TestSuite -Environment prod -TestResultShow All
Invoke-TestSuite -TestSuite BasicExample2.TestSuite -Environment test -TestResultShow All

# Report
Invoke-TestSuite -TestSuite BasicExample2.TestSuite -OutputHTML -OpenHTML