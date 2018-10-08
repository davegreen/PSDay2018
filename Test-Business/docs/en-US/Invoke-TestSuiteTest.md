---
external help file: Test-Business-help.xml
online version: 
schema: 2.0.0
---

# Invoke-TestSuiteTest

## SYNOPSIS
Runs tests and outputs the results to the output directory.

## SYNTAX

```
Invoke-TestSuiteTest [-TestObject] <PSObject[]> [-OutputPath] <FileInfo> [[-TestResultShow] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Runs tests and outputs the results to the output directory.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-TestSuiteTest -Path .\path\to\tests -OutputPath .\path\to\output
```

Runs the test suite test files included within the Path and outputs nUnit test data to the Output folder.

## PARAMETERS

### -TestObject
{{Fill TestObject Description}}

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
The output path to write nUnit test results to.
A folder will be created within this folder representing the current date and time in ISO 8601 format and the test XML will be saved there.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestResultShow
The test results to output to standard output.
Valid values are:

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

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: Failed
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

