---
external help file: Test-Business-help.xml
online version: 
schema: 2.0.0
---

# Invoke-TestSuite

## SYNOPSIS
Acts as a wrapper for Invoke-TestSuiteTest, Invoke-ReportUnit and Write-TestSummary to orchestrate running test suites.

## SYNTAX

```
Invoke-TestSuite [-TestSuite] <String> [[-Version] <Version>] [[-OutputPath] <DirectoryInfo>] [-OutputHTML]
 [-OpenHTML] [-NoSummary] [[-SummaryPath] <FileInfo>] [[-Environment] <String>] [[-ExcludeTests] <String[]>]
 [[-IncludeTests] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Acts as a wrapper for Invoke-TestSuiteTest, Invoke-ReportUnit and Write-TestSummary to orchestrate running test suites.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-TestSuite -TestSuite O365.TestSuite -OutputPath .\path\to\output
```

Runs the test suite (using the module name as the Test suite).
Test summaries are also written to file using Write-TestSummary.

## PARAMETERS

### -TestSuite
The TestSuite to run.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
The version of the TestSuite to run (of more than one exists).

```yaml
Type: Version
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
The path to output test results to.

```yaml
Type: DirectoryInfo
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: .\reports
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputHTML
Output HTML reports (using ReportUnit).

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpenHTML
Attempt to open the ReportUnit test index.html after running the test suite.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoSummary
Suppress creating a test suite summary.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SummaryPath
The path to write (or append) the summary to.
Defaults to the root of the test/html output.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Environment
{{Fill Environment Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeTests
{{Fill ExcludeTests Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeTests
{{Fill IncludeTests Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: David Green

## RELATED LINKS

